#------------------------------------------ output_data ------------------------------------------
#' export R data for NONMEM modeling 
#'
#' This function exports data for NONMEM modeling analyses including
#' options that are frequently necessary to adapt.
#'
#' @param x data frame to be exported.
#' @param csv character with the name of the csv file to generate
#' @param xpt character with the name of the xpt file to generate
#' @param attr character with the name of the rds file to generate
#' @param verbose logical indicating if additional information should be written to the console
#' @param maxdig numeric with the maximum number of decimals for numeric variables to be in output (see details)
#' @param tonum logical indicating if all variables should be made numeric (standard for NONMEM input files)
#' @param firstesc character with escape character for first variable, used to exclude row in NONMEM
#' @param readonly logical indicating if the output csv file should be made readonly
#' @param overwrite logical indicating if (all) output should be overwritten or not
#' @param ... Arguments passed to \code{\link{write.csv}}
#' @details In case tonum is \code{TRUE}, all variables will be made numeric and \code{Inf} values will be
#'   set to \code{NA} (all \code{NA} values will be set to a dot). The rounding set in \code{maxdig}
#'   will only be done in case tonum is set to TRUE. For xpt files, the name of the object to export is used as the name
#'   of the dataset inside the xpt file (e.g. \code{output_data(dfrm,xpt='dataset.xpt')} will result in an xpt file named
#'   'dataset.xpt' with one dataset named 'dfrm').
#' @keywords IO file
#' @seealso \code{\link{write.csv}}
#' @export
#' @return a data frame is written to disk
#' @author Richard Hooijmaijers
#' @examples
#' data(Theoph)
#' out_file <- tempfile(fileext = ".csv")
#' output_data(Theoph, csv = out_file, tonum = FALSE)
output_data <- function(x, csv=NULL, xpt=NULL, attr=NULL, verbose=TRUE,
                        maxdig=6, tonum=TRUE, firstesc=NULL, readonly=FALSE, overwrite=TRUE, ...){

  if(!overwrite) {cli::cli_alert_info("Be aware that when {.str overwrite} is set to FALSE nothing is written");return(invisible())}
  namx <- deparse(substitute(x))
  
  # Set scipen to high value to overcome that values are "rounded" when converting to character
  oset <- as.numeric(unlist(options("scipen")))
  options(scipen=50)
  on.exit(options(scipen=oset))

  # Write attributes (done as first step, otherwise attributes are lost when writing CSV file (e.g. when set to numeric))
  if(!is.null(attr) && overwrite){
    lbl  <- lapply(names(x),function(y) attr(x[,y],'label'))
    rmk  <- lapply(names(x),function(y) attr(x[,y],'remark'))
    fmt  <- lapply(names(x),function(y) attr(x[,y],'format'))
    rdsl <- vector("list", length(names(x)))
    rdsl <- lapply(1:length(rdsl),function(y) list(label=lbl[[y]],format=fmt[[y]],remark=rmk[[y]]))
    names(rdsl) <- names(x)
    saveRDS(rdsl,file=attr)
    if(verbose){
      cli::cli_text(cli::col_green("# Attributes can be added/adapted afterwards, for example"))
      cli::cli_text("rdsl <- readRDS('{normalizePath(attr,winslash = '/')}')")
      cli::cli_text("rdsl$CWRES <- list(label='Conditional weighted residuals',format=NULL,remark=NULL)")
      cli::cli_text("saveRDS(rdsl, file='{normalizePath(attr,winslash = '/')}')\n")
    }
  }

  # write csv - readonly is only applied to csv, xpt file is by default not easily editable outside SAS
  if(!is.null(csv) && overwrite){
    x <- data.frame(x)
    # Set to numeric, else test for existence of commas and warn
    if(tonum){
      for(i in 1:ncol(x)){
        x[,i] <- suppressWarnings(round(as.numeric(as.character(x[,i])),maxdig))
        x[,i] <- ifelse(is.infinite(x[,i]),NA,x[,i])
      }
    }else{
      chk <- sapply(x, function(vars) typeof(vars)=="character" && any(grepl(",",vars)))
      if(any(chk)) cli::cli_alert_danger("{.strong Found comma in character variable ({names(chk[chk])}), this will cause issues in NONMEM!}")
    }
    if(!is.null(firstesc)) names(x)[1] <- paste0(firstesc,names(x)[1])
   
    minchk <- suppressWarnings(apply(x,2,function(y) min(abs(as.numeric(y)[as.numeric(y)!=0]),na.rm = TRUE)))
    maxchk <- suppressWarnings(apply(x,2,function(y) max(abs(as.numeric(y)),na.rm = TRUE)))
    digchk <- suppressWarnings(apply(x,2,function(y) max(nchar(trimws(gsub("\\.|,","",as.numeric(y)))),na.rm = TRUE)))
    if(verbose){
      cli::cli_alert_info(paste("Dataset for writing has overall (abs) min/max of {.val {min(minchk)}} ({names(which(minchk==min(minchk)))})/",
                                "{.val {max(maxchk)}} ({names(which(maxchk==max(maxchk)))}) with maximum number of digits of",
                                "{.val {max(digchk)}} ({names(which(digchk==max(digchk)))})"))
    }                          

    # Following steps are done for readonly/overwrite/etc 
    if(file.exists(csv)){
      # Check if files are readonly and remove if this is the case
      ro_att <- fs::file_info(csv)$permissions
      ro_att <- substr(ro_att,2,3)=="--" # TRUE: readonly
      if(ro_att){
        cli::cli_alert_info("Be aware that file exists and is read-only, this means it will always be replaced (even if it is open!)") 
        try(fs::file_chmod(csv, "777")) # set fully open because we want to remove file
      } 
      try_rem <- suppressWarnings(file.remove(normalizePath(csv)))
      # if files cannot be removed, set readonly back (if necessary) and return warning
      if(!try_rem && ro_att) try(fs::file_chmod(csv, "444"))
      if(!try_rem) cli::cli_alert_danger("CSV file in could not be overwritten") 
    }
    if(!file.exists(csv) || try_rem){
      tr1 <- try(utils::write.csv(x,csv, quote=FALSE, row.names=FALSE, na=".", ...),silent=TRUE)
      if(inherits(tr1,"try-error")) cli::cli_alert_danger("Could not write CSV file, please check if path exists")
      if(readonly && !inherits(tr1,"try-error")) try(fs::file_chmod(csv, "444"))
    }  
  }

  # write xpt
  if(!is.null(xpt) && overwrite){
    if(verbose){
      chk1 <- ifelse(nchar(basename(xpt))<=32,"\u2714","\u2718")
      chk2 <- ifelse(nchar(namx)<=8,"\u2714","\u2718")
      chk3 <- ifelse(max(nchar(names(x)))<=8,"\u2714","\u2718")
      chk4 <- ifelse(!grepl("[[:upper:]]", xpt),"\u2714","\u2718")
      chk5 <- ifelse(!grepl("\\.", tools::file_path_sans_ext(xpt)),"\u2714","\u2718")
      chk6 <- ifelse(!grepl("\\.", namx),"\u2714","\u2718")
      cli::cli_text("An xpt file will be generated with filename {.file {xpt}} The dataset inside the xpt is named {.strong {namx}}")
      cli::cli_text("The dataset name is automatically generated based on the dataset name provided to the function.\f")
      cli::cli_text("The following checks were done (please review carefully):")
      cli::cli_ul()
      cli::cli_li("Filename for xpt is 32 characters or less {chk1}")
      cli::cli_li("Dataset within xpt is 8 characters or less {chk2}")
      cli::cli_li("All variable names within xpt are 8 characters or less {chk3}")
      cli::cli_li("Name of xpt only contains lower case letters {chk4}")
      cli::cli_li("No dots available in xpt file name {chk5}")
      cli::cli_li("No dots available in dataset within the xpt file name {chk6}")
    }
    trx <- try(haven::write_xpt(x,xpt,version=5,name=namx))
    if(inherits(trx,"try-error")) cli::cli_alert_danger("Could not write to XPT file, please check if path exists and file is not read-only")
  }
}


#------------------------------------------ read_data ------------------------------------------
#' read external data with logging of results
#'
#' This function reads external data with support for file types that are most commonly used in
#' clinical and pre-clinical data, and provide manual functions for less common types
#'
#' @param file character with the name of the file to read (see details for more information)
#' @param manfunc character with the manual function to use to read data (can have the form "package::function")
#' @param comment character with comment/information for the data that was read-in
#' @param verbose logical indicating if information regarding the data that is read is printed in console
#' @param ascii_check character of length one defining if the data that has been read in should be checked for valid ASCII characters (see details)
#' @param ... Additional arguments passed to the read data functions. This can be used to add
#'   arguments to for instance read.table or read_excel or for the function defined in manfunc
#'
#' @details The function reads in data, and uses the file extension to select the applicable function
#'   for reading. Below is a list of extensions that are recognized and the corresponding function that
#'   is used to read the data:
#'   - sas7bdat: [haven::read_sas]
#'   - xpt: [haven::read_xpt]
#'   - xls/xlsx: [readxl::read_excel]
#'   - prn/par: [read.table]
#'   - csv: [read.csv]
#'
#'   The prn and par file formats are basically space delimited files but with some specifics for modeling software 
#'   (e.g. prn is NONMEM input file with header starting with '#' and par is NONMEM output file as defined in $TABLE).
#'   This function can be used to read any type of data by using the manfunc
#'   argument. Any function available in R can be used here and even user written functions (see example section).
#'   This argument has precedence over the recognition of extensions. This means for instance that a CSV file can
#'   also be read-in using a different function (e.g. using `data.table::fread`).
#'   This flexibility is build in to ensure all possible data can be read in using this single function. This is mainly
#'   important for documentation purposes, to ensure all used data can be logged and documented.
#'   The data can be checked for valid ASCII characters using the "ascii_check" argument. By defualt this is done for
#'   excel files with extension xls or xlsx (ascii_check="xls") other options are "none" to never perform a check 
#'   or "all" to perform a check regardless of the way it is read in. The default is chosen as it is likely 
#'   that excel files are created manually and could therefore include non ASCII characters, and because 
#'   it puts additional overhead on function otherwise.
#'
#' @keywords IO file
#' @export
#' @return data frame containing a representation of the data in the file
#' @author Richard Hooijmaijers
#' @examples
#'
#' \dontrun{
#'
#' # For a known filetype you can use:
#' dat <- read_data(paste0(R.home(),"/doc/CRAN_mirrors.csv"))
#'
#' # We can use the arguments from the underlying package that does the reading
#' dat <- read_data("test1.xlsx", range="A2:B3")
#'
#' # In case we get a file format not directly supported by the function
#' # we can use the manfunc to use another function
#' sav <- system.file("files", "electric.sav", package = "foreign")
#' dat <- read_data(sav,manfunc = "foreign::read.spss")
#'
#' # It is also possible to write your own function that reads data (e.g from a PDF file):
#' read_pdf <- function(file){
#'   ret     <- pdftools::pdf_data(file)[[1]]
#'   ret$seq <- rep(1:2,each=(nrow(ret)/2))
#'   ret     <- tidyr::pivot_wider(ret,names_from = seq, values_from=text,id_cols=y,names_prefix="V")
#'   ret     <- as.data.frame(ret[-1,names(ret)!="y"])
#'   ret
#' }
#' # This function can then directly be used by read_data
#' dat <- read_data("test1.pdf",manfunc = "read_pdf")
#' }
read_data <- function(file,manfunc=NULL,comment="",verbose=TRUE,ascii_check="xls",...){
  file <- try(normalizePath(file, winslash = "/", mustWork = TRUE), silent=TRUE)
  if(inherits(file,"try-error")) cli::cli_abort("File could not be found, please check syntax")

  if(!is.null(manfunc)){
    res <- try(eval(parse(text=paste0("inds <- ",manfunc,"(\"",file,"\",...)"))), silent=TRUE)
    if(inherits(res,"try-error")) cli::cli_abort("Manual function resulted in an error, please check syntax")
  }else{
    if(tools::file_ext(file)=='sas7bdat') {
      inds <- haven::read_sas(file,...)
    }else if(tools::file_ext(file)=='xpt') {
      inds <- haven::read_xpt(file,...)
    }else if(tools::file_ext(file)=='prn') {
      inds <- utils::read.table(file,stringsAsFactors = FALSE,...)
      hdr  <- scan(file,nlines=1,what='character')
      names(inds) <- hdr
    }else if(tools::file_ext(file)=='par') {
      inds <- utils::read.table(file,stringsAsFactors = FALSE,skip=1,header=TRUE,...)
    }else if(tools::file_ext(file)=='csv') {
      inds <- utils::read.csv(file,stringsAsFactors = FALSE,...)
    }else if(tools::file_ext(file)%in%c("xls","xlsx")) {
      inds <- data.frame(readxl::read_excel(file,...))
    }else{
      cli::cli_abort("Extension not recognized as default file, try to read in file using the 'manfunc' option")
    }
  }
  if(verbose) cli::cli_alert_info("Read in {.file {file}} which has {.val {nrow(inds)}} records and {.val {ncol(inds)}} variables")
  inds <- data.frame(inds) # ensure inds is always a data.frame

  # Perform ASCII check 
  check_ascii <- function(dfrm){
    res <- sapply(names(dfrm),function(x) identical(iconv(dfrm[,x], from = 'UTF-8', to = 'ASCII'),as.character(dfrm[,x])))
    if(!all(res)) cli::cli_alert_danger("Non ASCII characters found in data ({names(res)[!res]}). Adapt this using something like: {.code iconv(var, from = 'UTF-8', to = 'ASCII')}")
  }
  if((ascii_check=="xls" && tools::file_ext(file)%in%c("xls","xlsx")) || ascii_check=="all")  check_ascii(inds)

  # Create information data frame with attributes (check if a data frame is present / available duplicates)
  if("data.frame"%in%class(inds)){roco <- dim(inds)}else{roco <- c(NA,NA)}
  nfo  <- data.frame(datain = normalizePath(file,winslash="/"),datainrows = roco[1], dataincols = roco[2],comment=comment,stringsAsFactors = FALSE)
  if("read_nfo" %in% ls(envir = .amp.dm)){
    diffs <- sapply(1:nrow(.amp.dm$read_nfo),function(x) identical(unlist(.amp.dm$read_nfo[x,]),unlist(nfo)))
    if(TRUE%in%diffs){
      nfo <- rbind(.amp.dm$read_nfo[!diffs,],nfo)
    }else{
      nfo <- rbind(.amp.dm$read_nfo,nfo)
    }
  }
  lbl <- c(datain = "Data in",  datainrows = "Num rows Data in", dataincols  = "Num cols Data in", comment = "Comment")
  for(i in seq_along(lbl)) attr(nfo[,names(lbl)[i]],'label') <- lbl[i]
  attr(nfo,'type')  <- "read_nfo"
  .amp.dm$read_nfo <- nfo

  return(inds)
}

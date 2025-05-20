#------------------------------------------ attr_xls ------------------------------------------
#' Reads in attributes from an external excel file
#'
#' This function reads in attributes available in an excel file and creates a structured list 
#'
#' @param xls character with the name of the excel file containing the attributes
#' @param sepfor character of length 1 indicating what the seperator for formats should be 
#' @param nosort logical indicating if sorting of variables should be omitted (otherwise sorting of no. column in excel file is applied)
#' @keywords documentation
#' @export
#' @return named list with the attributes
#' @author Richard Hooijmaijers
#' @examples
#' \dontrun{
#'   xmpl  <- system.file("example/Attr.Template.xlsx",package = "amp.dm")
#'   attr_xls(xmpl)
#' }
attr_xls <- function(xls,sepfor="\n",nosort=FALSE){

  # Read attributes and perform checks
  attrf <- try(readxl::read_excel(xls), silent=TRUE)
  if(inherits(attrf,"try-error")) cli::cli_abort("Could not read excel file")
  spc <- stats::setNames(attrf,tolower(names(attrf)))
  for(i in c("label", "format", "remark")){
    spcc <- gsub("\n|\r|\t","",spc[,i,drop=TRUE])
    spcc <- spcc[grepl("[^ -~]", spcc)]
    if(length(spcc)>0) cli::cli_alert_danger("The following non-ascii characters in {.val {i}} should be fixed: {spcc}")
  }

  names(attrf) <- tolower(names(attrf))
  if(!all(c("no.", "variable", "label", "format", "remark")%in%names(attrf))) cli::cli_abort("Not all essential variables present")
  attrf        <- attrf[!is.na(attrf$variable),]
  if(any(duplicated(attrf$variable)))  cli::cli_abort("Duplicate variables found in excel file, please check before continueing")
  if(!nosort) attrf <- attrf[order(attrf$no.),]
  
  # Create a list with attributes 
  makevec <- function(str){
    splt <- trimws(strsplit(str,sepfor)[[1]])
    ret  <- trimws(sub("^([^=]+)=","",splt))
    names(ret) <- trimws(sub("([^=]*).*","\\1",splt))
    return(ret)
  }

  attrl <- try(lapply(attrf$variable, function(x){
    label  <- if(!is.na(attrf$label[attrf$variable==x])) attrf$label[attrf$variable==x] else  NULL
    format <- if(!is.na(attrf$format[attrf$variable==x]))  makevec(attrf$format[attrf$variable==x]) else NULL
    remark <- if(!is.na(attrf$remark[attrf$variable==x]))  attrf$remark[attrf$variable==x] else NULL 
    list(label = label, format = format, remark = remark)
  }), silent = TRUE)

  if(inherits(attrl,"try-error")) cli::cli_abort("Could not create attribute list")
  attrl <- stats::setNames(attrl,attrf$variable)
   
  return(attrl)
}

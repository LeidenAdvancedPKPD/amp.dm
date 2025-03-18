#------------------------------------------ get_script ------------------------------------------
#' Get the current script name (either interactive Rstudio, markdown or batch script)
#'
#' @param base logical indicating if the basename should be returned (without path)
#' @param noext logical indicating if the file extension should be omitted
#'
#' @export
#' @return character with the current script name
#' @author Richard Hooijmaijers
get_script <- function(base=TRUE,noext=TRUE){
  if(!is.null(knitr::current_input(dir=TRUE))){
    ret <- knitr::current_input(dir=TRUE)
  }else if(commandArgs()[1]=="RStudio"){
    ret <- rstudioapi::getSourceEditorContext()$path
  }else{
    ret <- commandArgs()
    ret <- ret[grepl("--file=",ret)]
    if(length(ret)>0){ret <- paste0(normalizePath(getwd(),winslash="/"),"/",sub("--file=","",ret))}else{ret <- ""}
  }
  if(base)  ret <- basename(ret)
  if(noext) ret <- tools::file_path_sans_ext(ret)
  return(ret)
}

#------------------------------------------ session_tbl ------------------------------------------
#' Create information for R session
#'
#' This function creates a latex table or data frame with information from the R session
#' (sessionInfo() and Sys.info())
#'
#' @param ret a character vector to define what kind of output should be returned (either "dfrm", "tbl", "file")
#' @param capt character with the caption of the table (not used in case data frame is returned)
#' @param align alignment of the table passed to [general_tbl] (not used in case data frame is returned)
#' @param size character with font size as for the table [general_tbl] 
#' @param incscript logical indicating if the name of the script should be included (using [get_script])
#' @param ... additional arguments passed to [general_tbl]
#' @details This function can be used to create a table with the most important information of a R session,
#'   the user that is running the R session and the current date/time
#' @keywords documentation
#' @export
#' @return a data frame, code for table or nothing in case a PDF file is created
#' @author Richard Hooijmaijers
#' @examples
#'
#' session_tbl()
session_tbl <- function(ret="tbl", capt="Session info", align="lp{8cm}", size="\\footnotesize", incscript=FALSE, ...){
  sess <- utils::sessionInfo()
  pcks <- sapply(sess$otherPkgs,function(x) paste0(x$Package," (",x$Version,")"))
  pars <- c("R version","System","OS","Base packages","Other packages","Logged in User","Machine","Time")
  vals <- c(sess$R.version$version.string,sess$platform,sess$running,paste(sess$basePkgs,collapse=", "),
            paste(pcks,collapse=", "),Sys.info()["user"],Sys.info()["nodename"],as.character(Sys.time()))
  out  <- data.frame(parameter=pars,value=vals)
  if(incscript) out <- rbind(out, data.frame(parameter="Script", value=get_script(base=FALSE, noext=FALSE)))
  
  general_tbl(out, ret=ret, capt=capt, align=align, size=size, ...)
}



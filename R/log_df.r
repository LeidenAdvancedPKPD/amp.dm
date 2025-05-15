#------------------------------------------ log_df ------------------------------------------
#' Create information for all functions that log actions
#'
#' This function creates a table including information on functins that log informations suchs as
#' `filterr`, `left_joinr` and `read_data` 
#'
#' @param log list with logged information typically obtained with [get_log]
#' @param type character with the type of info that should be taken from log (either "filterr_nfo","joinr_nfo" or "read_nfo")
#' @param coding logical indicating if the coding (within `filterr`) should be displayed
#' @param ret a character vector to define what kind of output should be returned (either "dfrm", "tbl", "file")
#' @param capt character with the caption of the table (not used in case data frame is returned)
#' @param align alignment of the table passed to [general_tbl] (not used in case data frame is returned)
#' @param size character with font size as for the table [general_tbl] 
#' @param ... additional arguments passed to [general_tbl]
#' @details This function generates information for function that logs information. It attempts to find a good alignment
#'  and caption, mainly for outputting to a table. It is possible to set your own captions and alignment, take into
#'  account that the alignment differs per type and in case the coding argument is changed.
#' @keywords documentation
#' @export
#' @return function creates a PDF file or returns a data frame
#' @author Richard Hooijmaijers
#' @examples
#'
#' \dontrun{
#'   dat1 <- filterr(Theoph,Subject==1)
#'   dat2 <- Theoph |> filterr(Subject==2)
#'   dat3 <- Theoph %>% filterr(Subject==3)
#'   log_df(get_log(), "filterr_nfo")
#' }
log_df <- function(log, type , coding=FALSE, ret="dfrm", capt=NULL, align=NULL, size="\\footnotesize", ...){
  
  # return nothing when type is not present, this way we can include the function even if there is no output
  out <- log[[type]]
  if(is.null(out)) return() 
  
  if(type=="read_nfo" & ret!="dfrm"){
    out$datain <- paste0("\\path{",out$datain,"}")
    attr(out$datain,'label') <- "Data in"
  }
  if(!coding){
    out   <- out[,names(out)[names(out)!="coding"]]
    addal <- c("","p{8cm}")
  }else{
    addal <- c("p{3.5cm}","p{4.5cm}")
  } 
  
  if(!is.null(align)){
    algn <- align
  }else{
    if(type=="read_nfo")    algn  <- "p{7cm}p{1.5cm}p{1.5cm}p{4.5cm}" 
    if(type=="filterr_nfo") algn  <- paste0("p{2cm}",addal[1],"p{1.5cm}p{1.5cm}p{1.5cm}",addal[2])
    if(type=="joinr_nfo")   algn  <- "p{1.5cm}p{1.5cm}p{1.5cm}p{1.5cm}p{1.5cm}p{1.5cm}p{5cm}" 
  } 
  if(!is.null(capt)){
    cpt <- capt
  }else{
    if(type=="read_nfo")    cpt  <- "Overview of data read-in" 
    if(type=="filterr_nfo") cpt  <- "Overview of filtered data" 
    if(type=="joinr_nfo")   cpt  <- "Overview of joined data" 
  } 
  
  if(ret!="dfrm"){
    lbl  <- stats::setNames(names(out),sapply(names(out),function(x) attr(out[,x],'label')))
    out  <- dplyr::rename(out,dplyr::all_of(lbl))
  }
  if(type=="read_nfo" & ret=="tbl"){
   general_tbl(out, capt=cpt, ret=ret, align=algn, sanitize.text.function = identity, size=size, ...)
  }else{
   general_tbl(out, capt=cpt, ret=ret, align=algn, convchar = FALSE, size=size, ...)
  } 
}

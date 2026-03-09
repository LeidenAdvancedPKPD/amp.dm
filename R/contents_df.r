#------------------------------------------ contents_df ------------------------------------------
#' Create information for multiple data frames
#'
#' This function creates a latex table or data frame with the number of records, subjects and variables
#' of one or multiple data frames.
#'
#' @param dfv a character vector with data frame(s) in global environment for which the overview should be created
#' @param subject character string that identifies the subject variable within the data frame
#' @param ret a character vector to define what kind of output should be returned (either "dfrm", "tbl", "file")
#' @param capt character with the caption of the table (not used in case data frame is returned)
#' @param align alignment of the table passed to [general_tbl] (not used in case data frame is returned)
#' @param ... additional arguments passed to [general_tbl] 
#' @details This function can be used to create a table with the most important information of a data
#'   frame for documentation. The function will list the the number of records, subjects and variables
#'   of each data frame within dfv. This function is especially usable to indicate the differences between
#'   similar data frames or an overview of all data frames within a working environment
#' @keywords documentation
#' @export
#' @return a data frame, code for table or nothing in case a PDF file is created
#' @author Richard Hooijmaijers
#' @examples
#'
#' Theoph1 <-  subset(Theoph,Subject!=1)
#' Theoph2 <-  subset(Theoph,Subject!=2)
#' contents_df(c('Theoph1','Theoph2'),subject='Subject',ret='dfrm')
contents_df <- function(dfv, subject=NULL, ret="tbl", capt="Information multiple data frames", align="lllp{8cm}",...){
  dfl <- try(mget(dfv,envir=.GlobalEnv), silent=TRUE)
  if(inherits(dfl,'try-error')) cli::cli_abort("Not all data frames could be found")

  out <- try({lapply(dfl,function(x){
    ret   <- data.frame(records = nrow(x), variables = paste0(names(x),collapse=", "))
    if(!is.null(subject) && subject%in%names(x)) ret$subjects <- nrow(x[!duplicated(x[,subject]),])
    return(ret)    
  })})
  out <- data.frame(dataset=names(out),do.call(rbind,out) )
  out <- if(!is.null(subject)) out[,c("dataset","records","subjects","variables")] else out[,c("dataset","records","variables")]

  general_tbl(out, ret=ret, capt=capt, align=align, ...)
}

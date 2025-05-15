#------------------------------------------ stats_df ------------------------------------------
#' Calculate basic statistics on data frame
#'
#' This function creates a latex table or data frame with the basic statistics of a
#' data frame.
#'
#' @param data a data frame for which the overview should be created
#' @param missingval numeric with the value that indicates missing values, if NULL no missings will be recorded
#' @param ret a character vector to define what kind of output should be returned (either "dfrm", "tbl", "file")
#' @param capt character with the caption of the table (not used in case data frame is returned)
#' @param align alignment of the table passed to [general_tbl] (not used in case data frame is returned)
#' @param size character with font size as for the table [general_tbl] 
#' @param ... additional arguments passed to [general_tbl]
#' @details This function can be used to create a table with basic statistics of a data
#'   frame. The function will list the min, max, number of NA/missing values, number of unique categories and
#'   type of variable of all data items within a data frame. In case a data item has less than 10 unique categories, it
#'   will list the unique values.
#'   The main reason to use this function is to create a structured table with
#'   statistics of a data frame to be included in documentation.
#' @keywords documentation
#' @export
#' @return either tex code for table a data frame
#' @author Richard Hooijmaijers
#' @examples
#'
#' stats_df(Theoph)
stats_df <- function(data, missingval=-999, ret="tbl", capt="Statistics data frame", 
                     align="p{2cm}p{1cm}p{1cm}p{4cm}p{1.7cm}p{1.7cm}p{0.8cm}p{1.3cm}", size="\\footnotesize", ...){

  printnum <- function(x){
    if(x==0) return("0")
    if(x<1)  return("<1")
    if(x>=1 & x<10)  return(formatC(x,digits=2,format="f"))
    if(x>10 & x<100) return(formatC(x,digits=1,format="f"))
    if(x>=100)       return(">=100")
  }

  out <- lapply(data, function(x){
    if(suppressWarnings(min(as.numeric(x),na.rm=TRUE))==Inf){
      nNA   <- length(x[which(x=='NA' | x=='NaN' | is.na(x))])
      nMiss <- if(is.null(missingval)) 0 else length(x[x==as.character(missingval)])
      min   <- max <- "-"
    }else{
      min   <- formatC(min(as.numeric(x),na.rm=TRUE),digits=3,format="g")
      max   <- formatC(max(as.numeric(x),na.rm=TRUE),digits=3,format="g")
      nNA   <- length(x) - length(stats::na.omit(as.numeric(x)))
      nMiss <- if(is.null(missingval)) 0 else length(x[x==missingval])
    }
    nNA     <- paste0(nNA," [",printnum((as.numeric(nNA)/length(x))*100),"%]")
    nMiss   <- paste0(nMiss," [",printnum((as.numeric(nMiss)/length(x))*100),"%]")
    maxchar <- max(nchar(as.character(x)),na.rm = TRUE)
    cat     <- ifelse(length(unique(x))>10,paste0('More than 10 cats',' (',length(unique(x)),')'),paste0(unique(x),collapse=" / "))
    type    <- paste(class(x),collapse=", ")
    
    return(data.frame(Min=min,Max=max,Categories=cat,Nna=nNA,Nmiss=nMiss,MaxChar=maxchar,Type=type,stringsAsFactors = FALSE))
  })
  out <- cbind(Variable=names(out),do.call(rbind,out))

  general_tbl(out, capt=capt, align=align, ret=ret,size=size, ...)
}

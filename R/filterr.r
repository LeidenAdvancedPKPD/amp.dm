#------------------------------------------ filterr ------------------------------------------
#' Filter data with logging of results
#'
#' This function is a wrapper around [dplyr::filter]. Additional actions are performed on the background to
#' log the information of the filter action, and info regarding the step is printed. 
#'
#' @param .data the data frame for which the filter should be created
#' @param ... arguments passed to [dplyr::filter]
#' @param comment character with the reason of filtering used in log file
#' @details The function can be used to keep track of records that are omitted in the data management process.
#'   In general one would like to keep all records from the source database (and use flags instead to exclude data) but
#'   in cases where this is not possible it is important to know what records are omitted and for which reason.
#'   Every time the function is used it creates a records in in a log file which can be used in the documentation.
#' @keywords manipulation
#' @seealso [dplyr::filter]
#' @export
#' @return a filtered data frame
#' @author Richard Hooijmaijers
#' @examples
#'
#' # For full trace-ability of source data, no pipes or 
#' # base R pipes are preferred 
#' \dontrun{
#'   dat1 <- filterr(Theoph,Subject==1)
#'   dat2 <- Theoph |> filterr(Subject==2)
#'   dat3 <- Theoph %>% filterr(Subject==3)
#'   # Show what is being logged
#'   get_log()$filterr_nfo
#' }
filterr <- function(.data, ..., comment=""){
  # Apply the filter function from dplyr 
  ret <- dplyr::filter(.data,...)

  # Create information for the applied filter
  nfo <- data.frame(datain = deparse(substitute(.data)),
                    coding = paste(deparse(substitute(...)),collapse=""),
                    datainrows = nrow(.data),
                    dataoutrows = nrow(ret),
                    rowsdropped = nrow(.data) - nrow(ret),
                    comment = comment,
                    stringsAsFactors = FALSE)
  
  # Combine with available information, only if information is not duplicate
  if("filterr_nfo" %in% ls(envir = .amp.dm)){
    diffs <- sapply(1:nrow(.amp.dm$filterr_nfo),function(x) identical(unlist(.amp.dm$filterr_nfo[x,]),unlist(nfo)))
    if(TRUE%in%diffs){
      nfo <- rbind(.amp.dm$filterr_nfo[!diffs,],nfo)
    }else{
      nfo <- rbind(.amp.dm$filterr_nfo,nfo)
    }
  }
  
  # Apply attributes to information to save and present information
  lbl <- c(datain="Data in",coding = "Coding", datainrows = "Num rows Data in",
           dataoutrows = "Num rows Data out", rowsdropped = "Num rows dropped",
           comment = "Reason for filter")
  for(i in seq_along(lbl)) attr(nfo[,names(lbl)[i]],'label') <- lbl[i]
  attr(nfo,'type')  <- "filterr_nfo"
  cli::cli_alert_info("Filter applied with {.val {nrow(.data) - nrow(ret)}} record(s) deleted")
    
  # Save overall information and return results
  .amp.dm$filterr_nfo <- nfo
  return(ret)
}
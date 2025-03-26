#------------------------------------------ left_joinr ------------------------------------------
#' Perform a left join of two data frames with logging of results
#'
#' This function is a wrapper around [dplyr::left_join]. Additional actions are performed on the background to
#' log the information of the join action, and info regarding the step is printed. 
#'
#' @param x,y a pair of data frames used for joining
#' @param by character vector of variables to join by
#' @param ... additional arguments passed to [dplyr::left_join]
#' @param comment information for the reason of merging 
#' @param keepids logical indicating if merge identifiers should be available in output data (for checking purposes)

#' @details The function can be used to keep track of records that are available after a join in the data management process.
#'   Joining of data could lead to unexpected results, e.g. creation of cartesian product or loosing data.
#'   Therefore it is important to know what the result of a join step is.
#'   Every time the function is used it creates a records in in a log file which can be used in the documentation.
#' @keywords manipulation
#' @seealso [dplyr::left_join]
#' @export
#' @return a joined data frame
#' @author Richard Hooijmaijers
#' @examples
#'
#' \dontrun{
#'   dose  <- data.frame(Subject = unique(Theoph$Subject),
#'                       dose = sample(1:3,length(unique(Theoph$Subject)),
#'                                     replace = TRUE))
#'   dose2 <- dose[dose$Subject%in%1:6,]
#'   # Preferred to explicitly list by
#'   dat1 <- left_joinr(Theoph, dose, by="Subject")
#'   # The base R pipe is preferred for better logging of source data
#'   dat2 <- Theoph |> left_joinr(dose, by="Subject")
#'   dat3 <- Theoph %>% left_joinr(dose2, by="Subject")
#'   # Avoid long pipes before function for readability in log. e.g dont:
#'   dat4 <- Theoph |> dplyr::mutate(ID=3) |> dplyr::bind_cols(X=3) |> 
#'     left_joinr(dose, by="Subject")
#'   # Show what is being logged
#'   get_log()$joinr_nfo
#' }
left_joinr <- function(x,y,by=NULL,...,comment="", keepids=FALSE){
  # Apply the left_join function from dplyr 
  dfl          <- data.frame(x)
  dfl$mergeidl <- 1
  dfr          <- data.frame(y)
  dfr$mergeidr <- 1
  ret <- dplyr::left_join(dfl,dfr,by=by,...) 
  
  # Create information for the applied join
  nfo <- data.frame(datainl      = deparse(substitute(x)),
                    datainr      = deparse(substitute(y)),
                    datainrowsl  = nrow(x),
                    datainrowsr  = nrow(y),
                    dataoutrowsl = nrow(ret[which(ret$mergeidl==1 & is.na(ret$mergeidr)),]),
                    dataoutrows  = nrow(ret),
                    reason       = comment,
                    stringsAsFactors = FALSE)
  
  # Combine with available information, only if information is not duplicate
  if("joinr_nfo" %in% ls(envir = .amp.dm)){
    diffs <- sapply(1:nrow(.amp.dm$joinr_nfo),function(x) identical(unlist(.amp.dm$joinr_nfo[x,]),unlist(nfo)))
    if(TRUE%in%diffs){
      nfo <- rbind(.amp.dm$joinr_nfo[!diffs,],nfo)
    }else{
      nfo <- rbind(.amp.dm$joinr_nfo,nfo)
    }
  }
  
  # Apply attributes to information to save and present information
  lbl <- c(datainl = "Data in L", datainr = "Data in R",  datainrowsl = "Num rows Data in L", datainrowsr  = "Num rows Data in R",
           dataoutrowsl = "Rows only in L", dataoutrows = "Rows Data out", reason = "Reason for join")
  
  for(i in seq_along(lbl)) attr(nfo[,names(lbl)[i]],'label') <- lbl[i]
  attr(nfo,'type')  <- "joinr_nfo"
  cli::cli_alert_info("Output data contains {.val {nrow(ret)}} records")
  cli::cli_alert_info("{.emph {deparse(substitute(x))}} contained {.val {nrow(x)}} records")
  cli::cli_alert_info("{.emph {deparse(substitute(y))}} contained {.val {nrow(y)}} records")
  if(nrow(ret) >  nrow(x)) cli::cli_alert_warning("Be aware for possible cartesian product")

  # Save overall information and return results
  .amp.dm$joinr_nfo <- nfo
  if(!keepids) ret <- ret[,names(ret)[!names(ret)%in%c('mergeidl','mergeidr')]]
  return(ret)
}
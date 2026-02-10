#------------------------------------------ expand_addl_ii ------------------------------------------
#' Expand rows in case ADDL and II variables are present
#'
#' This function expands ADDL and II records. This is done by placing each ADDL record
#' on a separate line. This is convenient in case of individual dose calculations
#'
#' @param data data frame to perform the expantion on
#' @param evid character identifying the event ID (EVID) within the data frame
#'  This is used to distinguish observations from dosing records, e.g. 0 for observations
#' @param del_iiaddl logical identifying if the ADDL and II variables can be deleted from output
#' @details The function expects that certain variables are present in the data (at least ID, TIME, ADDL and II)
#' @keywords manipulation
#' @export
#' @return a data frame with expanded dose records
#' @author Richard Hooijmaijers
#' @examples
#'
#' dfrm <- data.frame(ID=c(1,1), TIME=c(0,12),II=c(12,0),ADDL=c(5,0),AMT=c(10,0),EVID=c(1,0))
#' expand_addl_ii(dfrm,evid="EVID")
expand_addl_ii <- function(data, evid=NULL, del_iiaddl=TRUE){

  notdat   <- c("ID","TIME","ADDL","II")[!c("ID","TIME","ADDL","II")%in%names(data)]
  if(length(notdat) > 0) cli::cli_abort("Required variable{?s} {.var {notdat}} not present in data")
  if(!is.null(evid)){
    if(!evid%in%names(data)) cli::cli_abort("{.var {evid}} not present in data")
    obs    <- dplyr::filter(data,.data[[evid]]==0)
    data   <- dplyr::filter(data,.data[[evid]]!=0)
  }
  
  data  <- data |> dplyr::mutate(ADDL = ifelse(is.na(.data$ADDL), 0, .data$ADDL))
  cntr  <- unlist(lapply(data$ADDL+1,seq_len))
  data  <- as.data.frame(lapply(data, rep, data$ADDL+1)) |>
    dplyr::mutate(TIME = .data$TIME+(.data$II* (cntr -1)))
  if(!is.null(evid) && nrow(obs)!=0) data <- rbind(data, obs) 
  #if(del_iiaddl) data <- dplyr::select(data, -c(.data$ADDL,.data$II))
  if(del_iiaddl) data <- dplyr::select(data, -c("ADDL","II"))
  data <- dplyr::arrange(data, .data$ID, .data$TIME)
  return(data)
}

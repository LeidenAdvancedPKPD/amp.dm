#------------------------------------------ fill_dates ------------------------------------------
#' Fills down dates within a data frame that include a start and end date
#'
#' This function can be used in case a start and end date is known for dosing. This function fills down
#' the dates so each date between start and end is placed on a separate row. Subsequently the dataset
#' can be used to merge with available date information and impute missing dates.
#'
#' @param data data frame for which the dates should be filled down
#' @param start <[`data-masking`][rlang::args_data_masking]> that includes the start date (as date format)
#' @param end <[`data-masking`][rlang::args_data_masking]> that includes the end date (as date format)
#' @param tau integer with the tau in days (e.g. 2 for dosing every other day)
#' @param repdat integer with repeats per day (e.g. 2 in case of twice daily dosing)
#'
#' @keywords manipulation
#' @export
#' @return a data frame with filled out dates
#' @author Richard Hooijmaijers
#' @examples
#'
#' dfrm <- data.frame(ID=1:2,first=as.Date(c("2016-10-01","2016-12-01"), "%Y-%m-%d"),
#'                    last=as.Date(c("2016-10-03","2016-12-02"), "%Y-%m-%d"))
#' fill_dates(dfrm, first, last)
#' fill_dates(dfrm, first, last, 2, 3)
fill_dates <- function(data, start, end, tau=1, repdat=1){

  chk      <- rlang::enquos(start,end,.named = TRUE, .ignore_empty="all") |> sapply(rlang::as_name)
  notdat   <- chk[!chk%in%names(data)]
  if(length(notdat) > 0) cli::cli_abort("Variable{?s} {.var {notdat}} not present in data")
  if(!inherits(data[,chk[1]], "Date") | !inherits(data[,chk[2]], "Date")) cli::cli_abort("Make sure {.var start} and {.var end} are in Date format")
  if(any(is.na(data[,chk[1]])) | any(is.na(data[,chk[2]])))               cli::cli_abort("Missing data found for {.var start} or {.var end} which is not permitted")
    
  nums   <- data |> dplyr::mutate(nums = as.numeric(difftime({{end}},{{start}}), units="days")+1) |> dplyr::pull()
  cntr   <- unlist(lapply(nums,seq_len)) - 1
  fldose <- as.data.frame(lapply(data, rep, nums)) |>
    dplyr::mutate(dat = as.Date({{start}}+cntr))
  
  del    <- cntr%%tau
  fldose <- fldose[del==0,]
  
  nums2  <- rep(repdat,nrow(fldose))
  cntr2  <- unlist(lapply(nums2,seq_len))
  fldose <- as.data.frame(lapply(fldose, rep, nums2)) |>
    dplyr::mutate(datnum = cntr2)

  return(fldose)
}

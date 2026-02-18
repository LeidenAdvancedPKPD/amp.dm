#------------------------------------------ impute_dose ------------------------------------------
#' Imputes dose records using ADDL and II by looking forward and backwards
#'
#' This function imputes dose records by looking at the missing doses between available records
#' based on a given II value
#'
#' @param data data frame to perform the calculations on
#' @param id character identifying the id variable within the data frame
#' @param datetime character identifying the date/time variable (POSIXct) within the data frame
#' @param amt character identifying the AMT (amount) variable within the data frame
#' @param ii character identifying the II (Interdose Interval)  variable within the data frame
#' @param thr numeric indicating the threshold percentage for imputation (see details)
#' @param back logical indicating if the time for imputed doses should be taken from the previous record (TRUE) or the next (FALSE)
#'
#' @details The function fills in the doses by looking at the time difference and  II between all records. 
#'   Be aware that this can result in unexpected results in a few cases, so results should always be handled with care.  
#'   The function will determine if a dose should be imputed based on the 'thr' value. For each dose, the function determines the percentage 
#'   difference from the previous dose based on the II value. In case this the expected difference is above the threshold value imputation will be done.
#'   
#' @keywords manipulation
#' @export
#' @return a data frame with imputed dose records
#' @author Richard Hooijmaijers
#' @examples
#'
#' dfrm <- data.frame(id=c(1,1), dt=c(Sys.time(),Sys.time()+ 864120),
#'                    II=c(24,24),AMT=c(10,10))
#' impute_dose(dfrm,"id","dt")
impute_dose <- function(data, id, datetime, amt="AMT", ii="II", thr = 50, back=TRUE){

  if(missing(datetime) | missing(id)) cli::cli_abort("Variables {.var datetime} and {.var id} are required")
  notdat <- c(datetime,id,amt,ii)[!c(datetime,id,amt,ii)%in%names(data)]
  if(length(notdat) > 0) cli::cli_abort("Variable{?s} {.var {notdat}} not present in data")

  imput <- data |> dplyr::group_by(dplyr::across(dplyr::all_of(c(id,amt)))) |> 
    dplyr::arrange(dplyr::across(dplyr::all_of(c(id,amt,datetime)))) |> 
    dplyr::mutate(prevdt  = dplyr::lag(.data[[datetime]]), 
                  nextdt  = dplyr::lead(.data[[datetime]]),
                  tdif    = as.numeric(difftime(.data[[datetime]], .data$prevdt, units="hours")),
                  percdif = (abs(.data$tdif - .data[[ii]]) / .data[[ii]]) * 100) |> 
    dplyr::filter(!is.na(.data$prevdt) & .data$percdif > thr)   |> # these records should be imputed
    dplyr::mutate(imptm = if(back==TRUE) format(.data$prevdt, "%H:%M:%S") else format(.data[[datetime]], "%H:%M:%S"),
                   dt    = as.POSIXct(paste(as.Date(.data$prevdt + .data[[ii]] * 3600), .data$imptm), format = "%Y-%m-%d %H:%M:%S"),
                   dt    = as.POSIXct(ifelse(.data[[ii]]<24, as.POSIXct(paste(as.Date(.data$prevdt), .data$imptm), format = "%Y-%m-%d %H:%M:%S") + (.data[[ii]]*3600), .data$dt)),
                   ADDL  = round((.data$tdif - .data[[ii]]) / .data[[ii]]) - 1,
                   ADDL  = ifelse(.data$ADDL<0, 0, .data$ADDL)) |> 
    #dplyr::select(-c(.data$prevdt, .data$nextdt, .data$tdif, .data$percdif, .data$imptm))
    dplyr::select(-c("prevdt", "nextdt", "tdif", "percdif", "imptm"))
  
  ret  <- dplyr::bind_cols(data, type = "original") |> 
    dplyr::bind_rows(dplyr::bind_cols(imput,type = "additional")) |>  dplyr::arrange(dplyr::across(dplyr::all_of(c(id,datetime))))
  
  if(nrow(dplyr::distinct(data,dplyr::across(dplyr::all_of(c(id,ii))))!=nrow(dplyr::distinct(data,dplyr::across(dplyr::all_of(id)))))){
    cli::cli_alert_warning("Found unequal TAU values check before using results")
  } 
  
  return(ret)
}

#------------------------------------------ impute_dose ------------------------------------------
#' Imputes dose records using ADDL and II by looking forward and backwards
#'
#' This function imputes dose records by looking at the missing doses between available records
#' based on a given II value
#'
#' @param data data frame to perform the calculations on
#' @param id <[`data-masking`][rlang::args_data_masking]> identifies the id variable within the data frame
#' @param datetime <[`data-masking`][rlang::args_data_masking]> identifies the date/time variable (POSIXct) within the data frame
#' @param amt <[`data-masking`][rlang::args_data_masking]> identifies the AMT (amount) variable within the data frame
#' @param ii <[`data-masking`][rlang::args_data_masking]> identifies the II (Interdose Interval)  variable within the data frame
#' @param thr numeric indicating the threshold percentage for imputation (see details)
#' @param back logical indicating if the time for imputed doses should be taken from the previous record (TRUE) or the next (FALSE)
#'
#' @details The function fills in the doses by looking at the time difference and  II between all records. 
#'   Be aware that this can result in unexpected results in a few cases, so results should always be handled with care.  
#'   The function will determine if a dose should be imputed based on the 'thr' value. For each dose, the function detemines the percentage 
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
#' impute_dose(dfrm,id,dt)
impute_dose <- function(data, id, datetime, amt=AMT, ii=II, thr = 50, back=TRUE){

  chk      <- rlang::enquos(datetime, id, amt, ii,.named = TRUE, .ignore_empty="all") |> sapply(rlang::as_name)
  if(length(chk)!=4) cli::cli_abort("Variables {.var datetime}, {.var id}, {.var amt} and {.var ii} are required")
  notdat   <- chk[!chk%in%names(data)]
  if(length(notdat) > 0) cli::cli_abort("Variable{?s} {.var {notdat}} not present in data")
  
  imput <- data |> dplyr::group_by({{id}}, {{amt}}) |> dplyr::arrange({{id}}, {{amt}}, {{datetime}}) |> 
    dplyr::mutate(prevdt  = dplyr::lag({{datetime}}), 
                  nextdt  = dplyr::lead({{datetime}}),
                  tdif    = as.numeric(difftime({{datetime}}, prevdt, units="hours")),
                  percdif = (abs(tdif-{{ii}})/{{ii}})*100) |> 
    dplyr::filter(!is.na(prevdt) & percdif > thr) |> # these records should be imputed
    dplyr::mutate(imptm = if(back==TRUE) format(prevdt, "%H:%M:%S") else format({{datetime}}, "%H:%M:%S"),
                  dt    = as.POSIXct(paste(as.Date(prevdt + {{ii}} * 3600), imptm), format = "%Y-%m-%d %H:%M:%S"),
                  dt    = as.POSIXct(ifelse({{ii}}<24,as.POSIXct(paste(as.Date(prevdt), imptm), format = "%Y-%m-%d %H:%M:%S")+({{ii}}*3600),dt)),
                  ADDL  = round((tdif-{{ii}})/{{ii}}) - 1,
                  ADDL  = ifelse(ADDL<0, 0, ADDL)) |> dplyr::select(-c(prevdt, nextdt, tdif, percdif, imptm),)
  
  ret  <- dplyr::bind_cols(data, type = "original") |> 
    dplyr::bind_rows(dplyr::bind_cols(imput,type = "additional")) |>  dplyr::arrange({{id}},  {{datetime}})
  
  if(nrow(dplyr::distinct(data,{{id}},{{ii}}))!=nrow(dplyr::distinct(data,{{id}}))){
    cli::cli_alert_warning("Found unequal TAU values check before using results")
  } 
  
  return(ret)
}

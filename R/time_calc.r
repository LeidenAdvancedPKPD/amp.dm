#------------------------------------------ time_calc ------------------------------------------
#' Create time variables for usage in NONMEM analyses
#'
#' This function calculates the most important time variables based on multiple variables in
#' a data frame.
#'
#' @param data data frame to perform the calculations on
#' @param datetime <[`data-masking`][rlang::args_data_masking]> identifies the date/time variable (POSIXct) within the data frame
#' @param evid <[`data-masking`][rlang::args_data_masking]> identifies the event ID (EVID) within the data frame
#' @param addl <[`data-masking`][rlang::args_data_masking]> identifies the additional dose levels (ADDL) within the data frame
#' @param ii <[`data-masking`][rlang::args_data_masking]> identifies the interdose interval (II) within the data frame
#' @param amt <[`data-masking`][rlang::args_data_masking]> identifies the amount variable (only needed if `evid` is not provided)
#' @param id <[`data-masking`][rlang::args_data_masking]> identifies the ID or subject variable
#' @param dig numeric indicating with how many digits the resulting times should be available
#' @details The function calculates the TIME, TALD (time after last dose) and TAFD (time after first dose).
#'   The different time variables are calculated in hours, where a POSIXct for the datetime variable is expected.
#'   The function takes into account ADDL and II records when provided, to correctly identify the TALD. 
#'   One must be cautious however when having ADDL/II and a complex dosing schedule (e.g. alternating dose schedules, 
#'   more than 1 dose per day, multiple compounds administration). In general it is good practice to double check the 
#'   output for multiple subjects in case of complex designs including ADDL/II.
#' @keywords manipulation
#' @export
#' @return a data frame with the calculated times
#' @author Richard Hooijmaijers
#' @examples
#'
#' dfrm <- data.frame(ID=rep(1,5), dt=Sys.time() + c(0,8e+5,1e+6,2e+6,3e+6),
#'                    AMT=c(NA,10,NA,0,NA), II=rep(24,5),EVID=c(0,1,0,1,0))
#' time_calc(dfrm,dt,EVID)
time_calc <- function(data,datetime,evid=NULL,addl=NULL,ii=NULL,amt=AMT,id=ID,dig=2){
  # Perform checks: Be aware the we need the following to account for allowed NULL and variables not present in data
  chk  <- rlang::enquos(datetime, amt, id, evid, addl, ii, .named = TRUE, .ignore_empty="all")  
  if(length(chk)<6) cli::cli_abort("Required variable datetime not provided")
  chk  <- setNames(chk,c("datetime", "amt", "id", "evid", "addl", "ii"))
  chk2 <- sapply(chk,rlang::quo_get_expr) |> sapply(is.null)
  chk3 <- sapply(chk[!chk2],rlang::quo_get_expr) |> sapply(rlang::as_name)
  notdat   <- chk3[!chk3%in%names(data)]
  if(length(notdat) > 0) cli::cli_abort("Variable{?s} {.var {notdat}} not present in data")
  if(!"evid"%in%names(chk3) && !"amt"%in%names(chk3)) cli::cli_abort('If evid is not provided make sure amt variable is present in data')
  
  if(!"evid"%in%names(chk3)){
    out <- dplyr::mutate(data, EVIDtmp = ifelse(is.na({{amt}}) | AMT==0, 0, 1))
  }else{
    out <- dplyr::mutate(data, EVIDtmp = {{evid}})
  }
  if(!"addl"%in%names(chk3)) out$ADDLtmp <- 0 else out$ADDLtmp <- out[,chk3[names(chk3)=="addl"]]
  if(!"ii"%in%names(chk3))   out$IItmp   <- 0 else out$IItmp   <- out[,chk3[names(chk3)=="ii"]]
  
  out <- out |> dplyr::arrange({{id}},{{datetime}},EVIDtmp)
  fdl <- dplyr::filter(out, EVIDtmp%in%c(1,4)) |> dplyr::distinct({{id}}, .keep_all = TRUE) |> 
    dplyr::select({{id}},{{datetime}}) |> dplyr::rename("firstDS"=unname(chk3[names(chk3)=="datetime"]))
  frc <- out |> dplyr::distinct({{id}}, .keep_all = TRUE) |> 
    dplyr::select({{id}},{{datetime}}) |> dplyr::rename("firstRC"=unname(chk3[names(chk3)=="datetime"]))
  
  idv <- unname(chk3[names(chk3)=="id"])
  out <- out |> dplyr::left_join(fdl, by = idv) |> dplyr::left_join(frc, by = idv) |> dplyr::group_by({{id}}) |>
    dplyr::mutate(
      TIME    = round(as.numeric(difftime({{datetime}}, firstRC, units = "hours")) , dig),
      TAFD    = round(as.numeric(difftime({{datetime}}, firstDS, units ="hours")) , dig),
      TIMEND  = dplyr::case_when(!EVIDtmp %in% c(1, 4) ~ NA, .default = {{datetime}}),
      ADDLtmp = ifelse(is.na(ADDLtmp) & EVIDtmp != 0, 0, ADDLtmp),
      ADDLtmp = ifelse(EVIDtmp == 0, NA, ADDLtmp),
      IItmp   = ifelse(is.na(IItmp) & EVIDtmp != 0, 0, IItmp),
      IItmp   = ifelse(EVIDtmp == 0, NA, IItmp),
      lastDS  = vctrs::vec_fill_missing(TIMEND),
      ADDLF   = vctrs::vec_fill_missing(ADDLtmp),
      IIF     = vctrs::vec_fill_missing(IItmp),
      TALD    = round(as.numeric(difftime({{datetime}}, lastDS + (ADDLF * IIF * 3600), units = "hours")), dig),
      # Set TALD to NA for non-obs records
      TALD    = ifelse(EVIDtmp %in% c(1, 4), NA, TALD),
      # Correct for negative times due to TALD records
      TALD    = ifelse(TALD < 0, round(TALD %% IIF , dig), TALD),
      # Correct for negative times due to TALD records
      TALD    = ifelse(is.na(TIMEND) & !EVIDtmp %in% c(1, 4) & is.na(TALD),
                       round(as.numeric(difftime({{datetime}}, firstDS, units = "hours")), dig),TALD)
      # TALD    = ifelse(is.na(TIMEND) & EVIDtmp %in% c(1, 4),
      #                  round(as.numeric(difftime({{datetime}}, firstDS, units = "hours")), dig),TALD)
    ) |> dplyr::select(-c(EVIDtmp, ADDLtmp, IItmp, TIMEND, firstDS, firstRC, lastDS, ADDLF, IIF)) |> 
    dplyr::ungroup()
  
  return(out)
}

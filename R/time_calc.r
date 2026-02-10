#------------------------------------------ time_calc ------------------------------------------
#' Create time variables for usage in NONMEM analyses
#'
#' This function calculates the most important time variables based on multiple variables in
#' a data frame.
#'
#' @param data data frame to perform the calculations on
#' @param datetime character identifying the date/time variable (POSIXct) within the data frame
#' @param evid character identifying the event ID (EVID) within the data frame
#' @param addl character identifying the additional dose levels (ADDL) within the data frame
#' @param ii character identifying the interdose interval (II) within the data frame
#' @param amt character identifying the amount variable (only needed if `evid` is not provided)
#' @param id character identifying the ID or subject variable
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
#' time_calc(dfrm,"dt","EVID")
time_calc <- function(data,datetime,evid=NULL,addl=NULL,ii=NULL,amt="AMT",id="ID",dig=2){
  
  if(missing(datetime)) cli::cli_abort("Variable {.var datetime} is required")
  if(is.null(evid) && (is.null(amt) || !amt%in%names(data))) cli::cli_abort('If evid is not provided make sure amt variable is present in data')
  mc     <- as.list(match.call())
  mcc    <- unlist(mc[names(mc)%in%c("datetime","evid","addl","ii","amt","id")])
  notdat <- mcc[!mcc%in%names(data)]
  if(length(notdat) > 0) cli::cli_abort("Variable{?s} {.var {notdat}} not present in data")
    
  if(is.null(evid)){
    out <- dplyr::mutate(data, EVIDtmp = ifelse(is.na(.data[[amt]]) | .data[[amt]]==0, 0, 1))
  }else{
    out <- dplyr::mutate(data, EVIDtmp = .data[[evid]])
  }
  if(is.null(addl)) out$ADDLtmp <- 0 else out$ADDLtmp <- out[,addl]
  if(is.null(ii))   out$IItmp   <- 0 else out$IItmp   <- out[,ii]
  
  out <- out |>  dplyr::arrange(dplyr::across(dplyr::all_of(c(id,datetime,"EVIDtmp")))) 
  fdl <- dplyr::filter(out, .data$EVIDtmp%in%c(1,4)) |> dplyr::distinct(dplyr::across(dplyr::all_of(id)), .keep_all = TRUE) |> 
    #dplyr::select(.data[[id]],.data[[datetime]]) |> dplyr::rename("firstDS"=datetime)
    dplyr::select(dplyr::all_of(c(id,datetime))) |> dplyr::rename("firstDS"=dplyr::all_of(datetime))
  frc <- out |> dplyr::distinct(dplyr::across(dplyr::all_of(id)), .keep_all = TRUE) |> 
    #dplyr::select(.data[[id]],.data[[datetime]]) |> dplyr::rename("firstRC"=datetime)
    dplyr::select(dplyr::all_of(c(id,datetime))) |> dplyr::rename("firstRC"=dplyr::all_of(datetime))
  
  
  out <- out |> dplyr::left_join(fdl, by = id) |> dplyr::left_join(frc, by = id) |> 
    dplyr::group_by(dplyr::across(dplyr::all_of(id))) |> dplyr::mutate(
      TIME    = round(as.numeric(difftime(.data[[datetime]], .data$firstRC, units = "hours")) , dig),
      TAFD    = round(as.numeric(difftime(.data[[datetime]], .data$firstDS, units ="hours")) , dig),
      TIMEND  = dplyr::case_when(!.data$EVIDtmp %in% c(1, 4) ~ NA, .default = .data[[datetime]]),
      ADDLtmp = ifelse(is.na(.data$ADDLtmp) & .data$EVIDtmp != 0, 0, .data$ADDLtmp),
      ADDLtmp = ifelse(.data$EVIDtmp == 0, NA, .data$ADDLtmp),
      IItmp   = ifelse(is.na(.data$IItmp) & .data$EVIDtmp != 0, 0, .data$IItmp),
      IItmp   = ifelse(.data$EVIDtmp == 0, NA, .data$IItmp),
      lastDS  = vctrs::vec_fill_missing(.data$TIMEND),
      ADDLF   = vctrs::vec_fill_missing(.data$ADDLtmp),
      IIF     = vctrs::vec_fill_missing(.data$IItmp),
      TALD    = round(as.numeric(difftime(.data[[datetime]], .data$lastDS + (.data$ADDLF * .data$IIF * 3600), units = "hours")), dig),
      # Set TALD to NA for non-obs records
      TALD    = ifelse(.data$EVIDtmp %in% c(1, 4), NA, .data$TALD),
      # Correct for negative times due to TALD records
      TALD    = ifelse(.data$TALD < 0, round(.data$TALD %% .data$IIF , dig), .data$TALD),
      # Correct for negative times due to TALD records
      TALD    = ifelse(is.na(.data$TIMEND) & !.data$EVIDtmp %in% c(1, 4) & is.na(.data$TALD),
                       round(as.numeric(difftime(.data[[datetime]], .data$firstDS, units = "hours")), dig), .data$TALD)
    #) |> dplyr::select(-c(.data$EVIDtmp, .data$ADDLtmp, .data$IItmp, .data$TIMEND, .data$firstDS, .data$firstRC, .data$lastDS, .data$ADDLF, .data$IIF)) |> 
    ) |> dplyr::select(-c("EVIDtmp", "ADDLtmp", "IItmp", "TIMEND", "firstDS", "firstRC", "lastDS", "ADDLF", "IIF")) |> 
    dplyr::ungroup()
  
  return(out)
}

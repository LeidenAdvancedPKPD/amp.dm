#------------------------------------------ create_addl ------------------------------------------
#' Create ADDL data item and deletes unnecessary amount lines
#'
#' This function determines if subsequent dose items are exactly the same as the tau value.
#' If this is the case it will count the number of times this occur and create the applicable number
#' of additional dose levels and removes unnecessary rows
#'
#' @param data data frame to perform the action on
#' @param datetime <[`data-masking`][rlang::args_data_masking]> identifies the date/time variable (POSIXct) within the data frame
#' @param id <[`data-masking`][rlang::args_data_masking]> identifies the subject ID within the data frame
#' @param dose <[`data-masking`][rlang::args_data_masking]> identifies the dose within the data frame (ADDL can only be set for equal doses)
#' @param tau <[`data-masking`][rlang::args_data_masking]> identifies the tau (or II) within the data frame
#' @param evid <[`data-masking`][rlang::args_data_masking]> identifies the event ID (EVID) within the data frame.
#'  This is used to distinguish observations from dosing records, e.g. 0 for observations
#'
#' @keywords manipulation
#' @export
#' @return a data frame with ADDL records added
#' @author Richard Hooijmaijers 
#' @examples
#'
#' dts  <- c(Sys.time(),Sys.time() + (24*60*60),Sys.time() + (48*60*60),Sys.time() + (96*60*60))
#' data <- data.frame(id=1,dt=dts,dose=10,tau=24)
#' create_addl(data=data, datetime=dt, id=id, dose=dose, tau=tau)
#' 
#' data2 <- rbind(cbind(data,evid=1),data.frame(id=1,dt=dts[4]+60,dose=10,tau=24,evid=0))
#' create_addl(data=data2, datetime=dt, id=id, dose=dose, tau=tau, evid=evid)
#' 
#' # tidyeval is used but we can use characters, e.g.
#' create_addl(data=data, datetime=!!as.name("dt"), id=!!as.name("id"), 
#'             dose=!!as.name("dose"), tau=!!as.name("tau"))
#' 
create_addl <- function(data, datetime, id, dose, tau, evid=NULL){
  chk      <- rlang::enquos(datetime,id,dose,tau,.named = TRUE, .ignore_empty="all") |> sapply(rlang::as_name)
  if(length(chk)!=4) cli::cli_abort("Variables {.var datetime}, {.var id}, {.var dose} and {.var tau} are required")
  notdat   <- chk[!chk%in%names(data)]
  if(length(notdat) > 0) cli::cli_abort("Variable{?s} {.var {notdat}} not present in data")
  nullevid <- is.null(rlang::eval_tidy(rlang::enquo(evid), data = data))
  
  if(!nullevid){
    chk    <- rlang::as_name(rlang::enquo(evid))
    if(!chk%in%names(data)) cli::cli_abort("{.var {chk}} not present in data")
    #obs    <- dplyr::filter(data,.data[[evid]]==0)
    #data   <- dplyr::filter(data,.data[[evid]]!=0)
    obs    <- dplyr::filter(data,{{evid}}==0)
    data   <- dplyr::filter(data,{{evid}}!=0)
  }
  data <- dplyr::group_by(data, {{id}},{{dose}}) |>
    dplyr::arrange({{id}},{{datetime}}) |>
    dplyr::mutate(lagdt  = dplyr::lag({{datetime}}),
                  tdiff  = round(difftime({{datetime}}, .data$lagdt, units = "h"), 4),
                  addlk  = (.data$tdiff - {{tau}})==0,
                  addlk  = ifelse(is.na(.data$addlk), FALSE, .data$addlk)) |>
    dplyr::arrange(dplyr::desc({{datetime}})) |>
    dplyr::mutate(ADDL   = 0,
                  CS     = cumsum(c(FALSE, utils::head(.data$addlk, -1))),
                  RETN   = ifelse(!.data$addlk, .data$CS, NA),
                  RETN   = c(0, utils::head(.data$RETN, -1)),
                  RETN   = vctrs::vec_fill_missing(.data$RETN),
                  RETN   = ifelse(is.na(.data$RETN),0,.data$RETN),
                  ADDL   = .data$CS - .data$RETN) |> dplyr::ungroup()
  #return(data)
  if(!nullevid && nrow(obs)!=0) data <- dplyr::bind_rows(data,cbind(obs,addlk=FALSE))
  data <- data |> dplyr::arrange({{id}}, {{datetime}}) |>
    dplyr::filter(!.data$addlk) |> dplyr::select(-c(.data$lagdt, .data$tdiff, .data$addlk, .data$CS, .data$RETN))
  return(data)
}

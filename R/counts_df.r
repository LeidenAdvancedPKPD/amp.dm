#------------------------------------------ counts_df ------------------------------------------
#' Create counts and frequencies within in data frame
#'
#' This function calculates and reports counts and frequencies stratified by one or more variables within a
#' data frame
#'
#' @param data data frame for which the table should be created
#' @param by <[`data-masking`][rlang::args_data_masking]> identifies by variables within the data frame for stratification
#' @param id <[`data-masking`][rlang::args_data_masking]> identifies the ID variable within the data frame (see details)
#' @param style numeric with the type of output to return  (see details)
#' @param ret a character vector to define what kind of output should be returned (either "dfrm", "tbl", "file")
#' @param capt character with the caption of the table (not used in case data frame is returned)
#' @param align alignment of the table passed to [general_tbl] (not used in case data frame is returned)
#' @param ... additional arguments passed to [general_tbl] 
#' @details This function generates frequency tables, by default for the number of observation per strata. In case the id argument is used 
#'  the function will also report the number and frequencies of distinct IDs. By default the observations and percentages are reported in
#'  separate columns (convenient for further processing). In case style is set to a value of 2, a single column is created that holds the 
#'  observations and percentages in a formatted ways (convenient for tabulating)
#' @keywords documentation
#' @export
#' @return a data frame, code for table or nothing in case a PDF file is created
#' @author Richard Hooijmaijers
#' @examples
#'
#' data("Theoph")
#' Theoph$trt <- ifelse(as.numeric(Theoph$Subject)<6,1,2)
#' Theoph$sex <- ifelse(as.numeric(Theoph$Subject)<4,1,0)
#' counts_df(data=Theoph, by=c(trt,sex),id=Subject)
#' counts_df(data=Theoph, by=sex,id=Subject)
#' counts_df(data=Theoph, by=c(trt,sex),id=Subject, style=2)
#'
counts_df <- function(data, by, id=NULL, style=1, ret="tbl", capt="Information multiple data frames", align=NULL, ...){
  
  # function for counting
  inner_count <- function(dfrm){
    nobs  <- dfrm |>  dplyr::group_by(dplyr::across({{by}})) |> dplyr::summarise(Nobs=dplyr::n()) |> 
      dplyr::ungroup() |> dplyr::mutate(PERCobs = prop.table(.data$Nobs) * 100)
    nobst <- nobs |>  dplyr::mutate(Nobs=sum(.data$Nobs), PERCobs=100, dplyr::across({{by}}, ~paste("Total"))) |> 
      dplyr::distinct(dplyr::across({{by}}), .keep_all = TRUE)
    return(rbind(nobs,nobst))
  }
  obs <- suppressMessages(inner_count(data))
  
  # Apply counts per id if applicable
  nullid <- is.null(rlang::eval_tidy(rlang::enquo(id), data = data))
  if(!nullid){
    ids <- suppressMessages(inner_count(dplyr::distinct(data,dplyr::across({{id}}),.keep_all = TRUE))) |> 
      dplyr::rename(dplyr::all_of(c(Nid = 'Nobs', PERCid='PERCobs')))
    obs <- suppressMessages(dplyr::left_join(obs,ids))
  }
  
  # Apply style and report output
  if(style==2){
    obs <- obs |> dplyr::mutate(Obs=paste0(.data$Nobs," (",signif(.data$PERCobs,3),"%)")) |> dplyr::select(-c(.data$Nobs,.data$PERCobs))
    if(!nullid) obs <- obs |> dplyr::mutate(Ids=paste0(.data$Nid," (",signif(.data$PERCid,3),"%)")) |> dplyr::select(-c(.data$Nid,.data$PERCid))
  }
  general_tbl(obs, capt=capt, align=align, ret=ret, ...)
}

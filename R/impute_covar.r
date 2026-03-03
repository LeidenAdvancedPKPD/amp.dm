#------------------------------------------ impute_covar ------------------------------------------
#' Imputute missing covariates
#'
#' The function will impute all NA values with either a given statistic (e.g. median) or with the largest group 
#'
#' @param var      vector with the items that should be imputed
#' @param uniques  vector that defines unique records to enable calculation of stats on non duplicate values
#' @param type     character of length one defining the type of statistics to perform for imputation (see details)
#' @param verbose  logical indicating if additional information should be given 
#'
#' @details The function can be used to impute continuous or categorical covariates. In case continuous covariates the type 
#'  argument should be a statistic like median or mean. In case a categorical covariate is used, the type should be set
#'  to 'largest' in which case the category that occurs most is used. In case multiple values occur most, the last encountered
#'  is used.
#' @keywords manipulation
#' @export
#' @return a vector where missing values are imputed
#'                
#' @author Richard Hooijmaijers
#' @examples 
#' dfrm  <- data.frame(num1 = c(NA,110))
#' impute_covar(dfrm$num1,type="median")
impute_covar <- function(var,uniques=NULL,type="median",verbose=FALSE){
  if(!is.null(uniques)) ustat <- var[!duplicated(uniques)] else ustat <- var 
  ustat <- ustat |> stats::na.omit()
  if(type!="largest"){
    impval <- do.call(type,list(x=ustat))  
  }else{
    impval <- table(ustat) |> sort() 
    if(impval[length(impval)]==impval[length(impval)-1]) cli::cli_alert_warning("Multiple values are largest, last value used")
    impval <- impval |> utils::tail(1) |> names() 
    if(!is.factor(var) & !is.character(var)) impvval <- as.numeric(impval)
  }
  if(verbose) cli::cli_alert_info("Impute missing with: {impval}")
  if(is.factor(var)) var[is.na(var)] <- factor(impval) else var[is.na(var)] <- impval
  return(var)
}
#------------------------------------------ flag_outliers ------------------------------------------
#' Creates a flag for outlying values
#'
#' This function creates a flag identifying the outliers in a vector
#'
#' @param var   numeric vector that should be checked for outliers
#' @param type  character with the type of test to perform for outliers (currently only the "boxstats" is available that uses the [boxplot] method)
#' @keywords manipulation
#' @export
#' @return a numeric vector the same length as `var` with either 0 (no outlier) or 1 (outlier)
#' @author Richard Hooijmaijers
#' @examples
#'
#' dfrm <- data.frame(a = 1:10, b = c(1:9,50))
#' flag_outliers(dfrm$a)
#' flag_outliers(dfrm$b)
flag_outliers <- function(var,type="boxstat"){
  if(!is.numeric(var)) cli::cli_abort("Variable should be numeric")
  if(type=="boxstat"){
    outl <- grDevices::boxplot.stats(var)$out
    ret  <- rep(0,length(var))
    ret[which(var%in%outl)] <- 1
  }else{
    cli::cli_abort("Incorrect type provided")
  }
  return(ret)
}

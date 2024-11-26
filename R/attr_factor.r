#------------------------------------------ attr_factor ------------------------------------------
#' Create factors for variables within a data frame using the format attribute
#'
#' This function searches for the 'format' attribute within a data frame, if found it applies the format to
#' that variable. The resulting variable will be a factor useful for plotting and reporting
#'
#' @param data the data.frame for which factors should be created
#' @param verbose a logical indicating if datachecks should be printed to console
#' @details In order to make this function work the 'format' attribute should be present and should be available
#'   as a named vector (e.g. `attr(data$GENDER,'format')   <- c('0' = 'Male', '1' = 'Female')`). If the
#'   attribute is found it overwrites the variable with the format applied to it. Be aware that the original
#'   levels defined in the format could be lost. The `factor` function in R always sets the levels from 1 to n.
#'   This means that if a format does not start with 1 or skips categories the underlying levels may differ.
#' @keywords attribute
#' @seealso [factor], [attr_add], [attr_xls]
#' @export
#' @return data frame with the formats assigned
#' @author Richard Hooijmaijers
#' @examples
#'
#' tmp <- data.frame(GENDER=rep(c(0,1),4),RESULT=rnorm(8))
#' attr(tmp$GENDER,'format')   <- c('0' = 'Male', '1' = 'Female')
#' tmp <- attr_factor(tmp)
#' str(tmp$GENDER)
attr_factor <- function(data, verbose = TRUE){
  data <- as.data.frame(data)
  for(i in names(data)){
    if(!is.null(attr(data[,i],'format'))){
      ufm <- names(attr(data[,i],'format'))
      udi <- as.character(stats::na.omit(unique(data[,i])))
      
      if(length(setdiff(ufm, udi))>0 && verbose)  cli::cli_alert_info("More formats in attributes than categories in data for: {i}")
      if(length(setdiff(udi, ufm))>0 && verbose)  cli::cli_alert_danger("More categories in data than formats in attributes for: {i}")
      
      if(is.numeric(data[,i])) lvl <- as.numeric(names(attr(data[,i],'format'))) else lvl <- names(attr(data[,i],'format'))
      data[,i]  <- factor(data[,i],levels=lvl,labels=attr(data[,i],'format'))
    }
  }
  return(data)
}
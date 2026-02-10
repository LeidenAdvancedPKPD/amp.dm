#------------------------------------------ attr_factor ------------------------------------------
#' Create factors for variables within a data frame using the format attribute
#'
#' This function searches for the 'format' attribute within a data frame, if found it applies the format to
#' that variable. The resulting variable will be a factor useful for plotting and reporting
#'
#' @param data the data.frame for which factors should be created
#' @param verbose a logical indicating if datachecks should be printed to console
#' @param largestfirst either a logical or a character vector indicating if the largest group should be the first level (see details)
#' @details In order to make this function work the 'format' attribute should be present and should be available
#'   as a named vector (e.g. `attr(data$GENDER,'format')   <- c('0' = 'Male', '1' = 'Female')`). If the
#'   attribute is found it overwrites the variable with the format applied to it. Be aware that the original
#'   levels defined in the format could be lost in this process. 
#'   The 'largestfirst' argument could be set to a logical which indicates if a for all variables in the dataset, the
#'   largest group should be the first level. The argument could also be a character vector indicating for which of the variables
#'   in the dataset, the largest group should be the first level. In case you want to set a specific order, this can be done
#'   directly in the the format attribute, e.g. `attr(data$VAR,'format') <- c('2' = 'level 1', '1' = 'Level 2')`
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
attr_factor <- function(data, verbose = TRUE, largestfirst = FALSE){
  data <- as.data.frame(data)
  for(i in names(data)){
    if(!is.null(attr(data[,i],'format'))){
      ufm <- names(attr(data[,i],'format'))
      udi <- as.character(stats::na.omit(unique(data[,i])))
      
      if(length(setdiff(ufm, udi))>0 && verbose)  cli::cli_alert_info("More formats in attributes than categories in data for: {i}")
      if(length(setdiff(udi, ufm))>0 && verbose)  cli::cli_alert_danger("More categories in data than formats in attributes for: {i}")
      
      if(is.numeric(data[,i])) lvl <- as.numeric(names(attr(data[,i],'format'))) else lvl <- names(attr(data[,i],'format'))

      if((is.logical(largestfirst) && isTRUE(largestfirst)) || (!is.logical(largestfirst) && i%in%largestfirst)) {
        largest <- table(data[,i]) |> sort() |> tail(1) |> names() 
        if(is.numeric(data[,i])) largest <- as.numeric(largest)
        lvl     <- c(largest, lvl[lvl!=largest])
      }
      lbl  <- attr(data[,i],'format')
      lbl  <- lbl[match(as.character(lvl),names(lbl))]
      if(is.numeric(data[,i])) newl <- as.numeric(names(lbl)) else newl <- names(lbl)
      sava <- attributes(data[,i])  
      data[,i]  <- factor(data[,i],levels=newl,labels=lbl)
      attributes(data[,i]) <- c(attributes(data[,i]),sava[names(sava)!="format"]) # add all original attributes except the format
    }
  }
  return(data)
}
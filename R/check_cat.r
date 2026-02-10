#------------------------------------------ check_cat ------------------------------------------
#' Create an overview of the available categories
#'
#' This function reports information for the categories, mainly the frequencies, proportions
#' and missing values
#'
#' @param x         numeric vector with the categories
#' @param missing   vector with the values that present missing information
#' @param detail    numeric with he level of detail to print (see below for details)
#' @param threshold numeric vector with the threshold numbers and proportions (see details)
#'
#' @details The detail argument can be used to print certain information:
#'   - 5: All possible information is printed
#'   - 4: Only the table with frequencies and proportions
#'   - 3: Only information regarding missing data
#'   - 2: Only a warning in case number of missing is above threshold (see below)
#'   - 1: A named vector with the available categories that can be used in [num_lump]
#' The threshold presents the absolute number (first number) and proportions (second number) to check.
#' If either one of these numbers is above the threshold for missing values, a warning is given.
#' This can be convenient to decide whether or not a category should be used during analyses.
#' @keywords documentation
#' @export
#' @return Nothing is returned information is printed on screen
#'                
#' @author Richard Hooijmaijers
#' @examples 
#' 
#' data1   <- data.frame(cat1 = c(rep(1:5,10),-999), 
#'                       cat2 = c(rep(letters[1:5],10),-999))
#' check_cat(data1$cat1)
#' check_cat(data1$cat2, detail=1)                       
#' check_cat(data1$cat1,detail=2,threshold = c(NA,0.1))
check_cat <- function(x, missing=c(-999,NA), detail=5, threshold=c(NA,NA)){
  ft          <- table(x, useNA = "ifany")
  ftp         <- prop.table(ft)
  ftpf        <- paste0(ft, " (", formatC(ftp*100, digits=1, format="f"),"%)") 
  names(ftpf) <- formatC(attr(ft,"dimnames")[[1]])
  missn       <- sum(ft[names(ft)%in%missing])
  missp       <- sum(ftp[names(ftp)%in%missing])
  
  if(detail%in%c(5,4)){
    cli::cli_rule("freq (prop) for x")
    cat(paste0(names(ftpf),": ",ftpf),sep="\n") # we need cat as cli does not handle whitespaces as expected
  }
  
  if(detail%in%c(5,3)){
    cli::cli_rule("missing values x")
    cli::cli_text("Total of {missn} missing values resulting in {formatC(missp*100, digits=1, format='f')}%")
  }  
  
  if(detail%in%c(5,2)){
    warn1 <- warn2 <- 0
    if(!is.na(threshold[1]) && missn>=threshold[1]) warn1 <- missn
    if(!is.na(threshold[2]) && missp>=threshold[2]) warn2 <- missp
    if(warn1>0|warn2>0){
      cli::cli_rule("Alert for missing")
      cli::cli_alert_danger("Number of missing values above threshold: {missn} ({formatC(missp, digits=2, format='f')})")
    } 
  }
  
  if(detail%in%c(5,1)){
    cli::cli_rule("String copy for lumping")
    cli::cli_text(paste0('c(',paste0("\"",sort(unique(x)),"\"",' = ',sort(unique(x)), collapse=", "),')'))
  }
}
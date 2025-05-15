# Make sure that environemnt and get_log function are in the same file
.amp.dm <- new.env(parent = emptyenv())
#------------------------------------------ get_log ------------------------------------------
#' Retrieve log objects
#'
#' Returns one or more dataframes with log information
#' related to function like [filterr], [left_joinr], [cmnt], [srce] and [read_data] 
#'
#' @keywords documentation
#' @return a named list of dataframes
#' @author Richard Hooijmaijers
#' @export
#' @examples
#' \dontrun{
#'   xldat <- readxl::readxl_example("datasets.xlsx")
#'   xlin  <- read_data(xldat, saveit = FALSE)
#'   get_log()
#' }
get_log <- function() {
  onam <- ls(envir = .amp.dm)
  ret  <- lapply(onam,function(x) get(x, envir = .amp.dm))
  return(stats::setNames(ret,onam))
}

#------------------------------------------ cmnt ------------------------------------------
#' Add comment to environment to present in documention
#'
#' Adds a comment regarding assumptions and special attention into package environment,
#' which can be used in code chunks and easily printed after a code chunk
#'
#' @param string character of length one with the comment to add
#' @param bold logical indicating if the string should be printed in bold to emphasize importance
#' @param verbose logical indicating if the comment should be printed when function is called
#'
#' @keywords documentation
#' @return no return value, called for side effects
#' @author Richard Hooijmaijers
#' @export
#' @examples
#'   cmnt("Exclude time points > 12h")
#'   cmnt("Subject 6 deviates and is excluded in the analysis", TRUE)
#'   # Markdown syntax can be used for comments:
#'   cmnt("We can use **bold** and *italic* or `code`")
#'   # we can print the contents of the comments with
#'   get_log()$cmnt_nfo
cmnt <- function(string = "", bold = FALSE, verbose = TRUE){
  if(verbose) cli::cli_alert_info(string)
  cmnt_nfo <- data.frame(string=string, bold=bold)
  if("cmnt_nfo" %in% ls(envir = .amp.dm)){
    diffs <- sapply(1:nrow(.amp.dm$cmnt_nfo),function(x) identical(unlist(.amp.dm$cmnt_nfo[x,]),unlist(cmnt_nfo)))
    if(TRUE%in%diffs){
      cmnt_nfo <- rbind(.amp.dm$cmnt_nfo[!diffs,],cmnt_nfo)
    }else{
      cmnt_nfo <- rbind(.amp.dm$cmnt_nfo,cmnt_nfo)
    }
  }
  .amp.dm$cmnt_nfo <- cmnt_nfo
}

#------------------------------------------ srce ------------------------------------------
#' Add source information to environment to present in documention
#'
#' Adds the source of variables into package environment,
#' which can be used in code chunks at the applicable locations and easily added to 
#' documention afterwards
#'
#' @param var unquoted string with the variable for which the source should be defined
#' @param source unquoted strings with the source(s) used for var (see example)
#' @param type character with the type of variable can be either 'c' (copied) or 'd' (derived)
#'
#' @keywords documentation
#' @return no return value, called for side effects
#' @author Richard Hooijmaijers
#' @export
#' @examples
#'   # variable AMT copied from Dose variable in Theoph data frame
#'   srce(AMT,Theoph.Dose)
#'   # variable BMI derived from WEIGHT variable in wt data frame
#'   # and HEIGHT variable in ht data frame
#'   srce(BMI,c(wt.WEIGHT,ht.HEIGHT),'d')
#'   get_log()$srce_nfo
srce <- function(var,source,type='c'){
  srce_nfo <- data.frame(variable = deparse(substitute(var)), type = type, source=gsub("^c\\(|)$","",deparse(substitute(source))))
  if("srce_nfo" %in% ls(envir = .amp.dm)){
    diffs <- sapply(1:nrow(.amp.dm$srce_nfo),function(x) identical(unlist(.amp.dm$srce_nfo[x,]),unlist(srce_nfo)))
    if(TRUE%in%diffs){
      srce_nfo <- rbind(.amp.dm$srce_nfo[!diffs,],srce_nfo)
    }else{
      srce_nfo <- rbind(.amp.dm$srce_nfo,srce_nfo)
    }
  }
  .amp.dm$srce_nfo <- srce_nfo
}
#------------------------------------------ cmnt_print ------------------------------------------
#' Function that prints the comments given by [cmnt]
#'
#' Prints the results in markdown format to be used directly in inline coding
#'
#' @param clean logical indicating if the comments should be deleted after printing (see details)
#' @details The function returns a text string with the comments given up to the point
#'  it was called. When clean is set to TRUE (default), the content of the comment
#'  dataset is cleaned to overcome repetition of comments each time it is called
#' @keywords documentation
#' @return character string with the comments
#' @author Richard Hooijmaijers
#' @export
#' @examples
#'   cmnt("Comment to print")
#'   cmnt_print()
cmnt_print <- function(clean=TRUE){
  res <- get_log()$cmnt_nfo
  if(!is.null(res) && nrow(res)>0){
    ret <-paste0("Assumptions and special attention:\n\n",
                  paste0("- ",ifelse(res$bold,"**",""),res$string,ifelse(res$bold,"**",""),collapse="\n"),"\n\n")
  }else{
    return()
  }
  if(clean) rm("cmnt_nfo", envir = .amp.dm)
  return(ret)
}

#------------------------------------------ typearg ------------------------------------------
#' Function that takes the formals of a function and return the type
#'
#' function get the [typeof] of a function arguments but also reports na, missing, null and empty
#'
#' @param frml a list typically obtained by the [formals] function
#' @keywords documentation
#' @return named vector with the type of values for the function arguments
#' @author Richard Hooijmaijers
#' @export
#' @examples
#'   typearg(formals(lm))
typearg <- function(frml){
  sapply(frml, function(x){
    if(typeof(x)=="symbol"){
      chk <- try(get(x),silent = TRUE)
      if(inherits(chk,"try-error")) ret <- "missing" else ret <- typeof(chk)
    }else{
      ret <- typeof(x)
      if(is.null(x)) ret <- "null" else if(is.na(x)) ret <- "na" else if(x=="") ret <- "empty"
    }
    ret
  })
}
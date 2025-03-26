#------------------------------------------ attr_extract ------------------------------------------
#' Reads in attributes from an external excel file
#'
#' This function extracts attributes available in a data frame and creates a structured list 
#'
#' @param dfrm data frame containing the attributes
#' @keywords documentation
#' @export
#' @return named list with the attributes
#' @author Richard Hooijmaijers
#' @examples
#' \dontrun{
#'   attrl  <- attr_xls(system.file("example/Attr.Template.xlsx",package = "amp.dm"))
#'   nm     <- read.csv(system.file("example/NM.theoph.V1.csv",package = "amp.dm"))
#'   nmf    <- attr_add(nm, attrl, verbose = FALSE)
#'   attrl2 <- attr_extract(nmf)
#'   all.equal(attrl,attrl2)
#' }
attr_extract <- function(dfrm){

  attrl <- try(lapply(names(dfrm), function(x){
    label   <- attr(dfrm[,x],"label")
    format  <- attr(dfrm[,x],"format")
    remark  <- attr(dfrm[,x],"remark")
    list(label = label, format = format, remark = remark)
  }), silent = TRUE)

  if(inherits(attrl,"try-error")) cli::cli_abort("Could not create attribute list")
  attrl <- stats::setNames(attrl,names(dfrm))
   
  return(attrl)
}



#------------------------------------------ general_tbl ------------------------------------------
#' General table wrapper for documentation functions
#'
#' This function creates a latex table
#'
#' @param dfrm data frame for which the table should be created
#' @param capt character with the caption of the table 
#' @param align alignment of the table passed to [R3port::ltx_list] or [xtable::print.xtable] (see details below)
#' @param outnm character with the name of the tex file to generate and compile, e.g. "define.tex" (only applicable in case file is returned) 
#' @param ret a character vector to define what kind of output should be returned (either "dfrm", "tbl", "file")
#' @param tmpl character with the template file to use (only applicable in case file is returned)
#' @param ... additional arguments passed to either [R3port::ltx_list] or [xtable::print.xtable] depending on what is returned
#' @details This function is a general function to create a xtable suitable for documentation, or directly creates an compiles a 
#'  latex file using the `R3port` package. The align argument can be used to change the column widths of a table to be able to fit a table
#'  on a page (e.g. in latex wide tables can fall off a page). The way this should be used is to provide a vector of one with
#'  a specification for each column. For example 'lp{3cm}r' can be used for left align first column, second column of 3 cm
#'  and third column right aligned. In case align is set to NULL a default alignment is used
#' @keywords internal
#' @export
#' @return a data frame, code for table or nothing in case a PDF file is created
#' @author Richard Hooijmaijers
#' @examples
#'
#' general_tbl(Theoph)
general_tbl <- function(dfrm, capt="General table", align=NULL, outnm=NULL, ret="tbl", tmpl = system.file("simple.tex",package = "R3port"), ...){
  if(ret=="dfrm"){
    return(dfrm)
  }else if(ret=="tbl"){
    # Notice that we need to paste "l" with align (by default it assumes row names are include and is used for alignment)
    algn <- if(is.null(align)) NULL else paste0("l",align)
    xtable::print.xtable(xtable::xtable(dfrm, caption=capt, align=algn), caption.placement="top", comment=FALSE,
                       tabular.environment = "longtable", floating=FALSE, include.rownames=FALSE, hline.after=NULL,
                       add.to.row = list(pos=list(-1,0),command=c("\\toprule ","\\midrule\\endhead ")),...)
  }else if(ret=="file"){
    # Notice here we escape latex characters and set convchar to FALSE
    dfrm[]  <- apply(dfrm,2,function(x) gsub('([#$%&_\\^\\\\{}])', '\\\\\\1', as.character(x), perl = TRUE))
    dfrm[]  <- apply(dfrm,2,function(x) gsub("<","$<$",as.character(x)))
    dfrm[]  <- apply(dfrm,2,function(x) gsub(">","$>$",as.character(x)))
    dfrm[]  <- apply(dfrm,2,function(x) gsub("\n"," ",as.character(x)))
    # set tmpl as option, this enable using a default or company specific template
    #R3port::ltx_list(dfrm, out=outnm, orientation=orientation, mancol = align, porder=FALSE, hyper=FALSE, convchar=FALSE, template=tmpl,...)
    R3port::ltx_list(dfrm, out=outnm, mancol = align, template=tmpl, ...)
  } 
}
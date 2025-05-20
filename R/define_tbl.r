#------------------------------------------ define_tbl ------------------------------------------
#' Create define PDF file for submission of pharmacometric data files
#'
#' This function creates the define.pdf file necessary for esubmission.
#'
#' @param attr list with datasets attributes
#' @param ret a character vector to define what kind of output should be returned (either "dfrm", "tbl", "file")
#' @param capt character with the caption of the table 
#' @param align alignment of the table passed to [general_tbl] 
#' @param outnm character with the name of the tex file to generate and compile (e.g. define.tex)
#' @param orientation character the page orientation in case a file is to be returned (can be either 'portrait' or 'landscape')
#' @param size character with font size as for the table [general_tbl] 
#' @param src object that holds information regarding the source (e.g. `get_log()$srce_nfo` ), if NULL an attempt is made to get it from the environment
#' @param ... additional arguments passed to [general_tbl] 
#'
#' @export
#' @return a data frame, code for table or nothing in case a PDF file is created
#' @author Richard Hooijmaijers
#' @examples
#'
#' \dontrun{definePDF(attrl,outnm='define.tex')}
define_tbl <- function(attr=NULL, ret="dfrm", capt="Dataset define form", align="lp{3cm}lp{8cm}", outnm=NULL, 
                       orientation="portrait",size="\\footnotesize",src=NULL,...){
 
  if(is.null(attr) || !is.list(attr)) cli::cli_abort("Make sure attr is provided and is a list with attributes")

  todf <- lapply(attr,function(x){
      desc   <- ifelse(is.null(x$label),"-",gsub(" *\\(.*?\\) *","",x$label))
      unit   <- gsub(".*\\((.*)\\).*", "\\1", x$label)
      if(length(unit)==0 || is.null(x$label) || !grepl("\\(.*\\)",x$label)) unit <- "-"
      rmk    <- ifelse(is.null(x$remark),"",x$remark)
      fmt    <- ifelse(is.null(x$format),"",paste(names(x$format),"=",x$format,collapse=", "))
      remark <- ifelse(trimws(paste(rmk,fmt))=="","-",paste(rmk,fmt))
      c(desc,unit,remark)
  })
  definedf        <- data.frame(cbind(names(attr),do.call(rbind,todf)))
  names(definedf) <- c("Data.Item","Description","Unit","Remark")

  # If available, add the source information
  if(is.null(src)) srce_nfo <- try(get("srce_nfo",envir = .amp.dm),silent=TRUE) else srce_nfo <- src
  if(!inherits(srce_nfo,"try-error") && nrow(srce_nfo)>0){
      rmrk <- paste0("[source: ",srce_nfo$source," (",ifelse(srce_nfo$type=='d','derived','copied'),")","]")
      definedf$Remark[match(srce_nfo$variable,definedf$Data.Item)] <- paste(definedf$Remark[match(srce_nfo$variable,definedf$Data.Item)],rmrk)
  }
  
  # Output either as data frame, pdf (latex) or latex code to implement in quarto
  general_tbl(definedf, ret=ret, capt=capt, align=align, outnm=outnm, 
              orientation=orientation, porder=FALSE, hyper=FALSE, convchar=FALSE, size=size, ...)
}

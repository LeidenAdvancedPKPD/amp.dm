#------------------------------------------ num_lump ------------------------------------------
#' Perform lumping of numerical values
#'
#' This function is mainly a wrapper for [forcats::fct_lump] but applied on numeric variables. Furthermore
#' there is the option to use uniques to determine small categories for instance on individual level
#'
#' @param x        numeric vector with the items that should be lumped
#' @param lumpcat  the category in which the lumped levels should be added (see details)
#' @param uniques  vector that defines unique records to enable lumping on non duplicate values 
#' @param prop     numeric with the threshold proportions for lumping
#' @param min      numeric with the min number of times a level should appear to not lump
#' @param ...      additional arguments passed to [forcats::fct_lump_min] and/or [forcats::fct_lump_prop] 
#'
#' @details The argument lumpcat is the level in which lumped values should appear and can be one of the following:
#'  - numeric with the category number to set the levels to
#'  - character specifying "largest" to select the largest category (selected before lumping)
#'  - named vector to set the 'algorithm' for instance:
#'    c('5'='3', '4'='6') to set category 5 to 3 and 4 to 6 when these categories need lumping
#' @keywords manipulation
#' @export
#' @return vector with the lumping applied
#' @author Richard Hooijmaijers
#' @examples 
#' 
#' dfrm <- data.frame(id = 1:30, cat = c(rep(1,8),rep(2,13), rep(3,4),rep(4,5)))
#' num_lump(x=dfrm$cat, lumpcat=99, prop=0.15)
num_lump <- function(x, lumpcat=99, uniques=NULL, prop=NULL, min=NULL,...){
  if((is.null(prop) && is.null(min))) cli::cli_abort("Specifiy either `prop`, `min` or a combination")
  if(!is.numeric(x)) cli::cli_abort("Make sure `x` is numeric")
  
  if(!is.null(uniques)) uret <- x[!duplicated(uniques)] else uret <- x
  if(is.numeric(lumpcat) && is.null(names(lumpcat))){ # set category to specific number
    oth_lev <- as.character(lumpcat)
  }else if(length(lumpcat)==1 && lumpcat=="largest"){ # set category to largest category
    oth_lev <- forcats::fct_count(as.character(uret), TRUE) |> head(1) |> _$f |> as.character()
  }else if(!any(is.na(names(lumpcat)))){             # set custom category 
    oth_lev <- "num_lump_temp"
  }
  
  # Only support fct_lump_min or fct_lump_prop
  iret <- uret |> factor() 
  if(!is.null(min) && !is.null(prop)){
    iret1 <- forcats::fct_lump_min(iret, other_level = oth_lev, min = min, ...)   
    iret2 <- forcats::fct_lump_prop(iret, other_level = oth_lev, prop = prop, ...) 
    cret  <- unique(c(which(iret1==oth_lev),which(iret2==oth_lev)))
    levels(iret) <- c(levels(iret),oth_lev)
    iret[cret]   <- oth_lev
  }else if(!is.null(min)){
    iret <- forcats::fct_lump_min(iret, other_level = oth_lev, min = min, ...)   
  }else if(!is.null(prop)){
    iret <- forcats::fct_lump_prop(iret, other_level = oth_lev, prop = prop, ...) 
  }  
  
  if(oth_lev=="num_lump_temp"){
    tolump <- base::setdiff(forcats::fct_count(factor(uret))$f, forcats::fct_count(iret)$f)
    if(!all(as.character(tolump)%in%names(lumpcat))) cli::cli_abort("You need to specify all aplicable lumping categories when done manual")
    chk     <- lumpcat[as.character(lumpcat)!=names(lumpcat)]
    if(any(as.character(chk)%in%names(chk))) cli::cli_alert_warning("Circular assignment in {.field lumpcat}, check for unexpected results")
    
    iret   <- uret 
    for(i in 1:length(lumpcat)){
      if(names(lumpcat)[i]%in%tolump) iret[iret==as.numeric(names(lumpcat)[i])] <- as.numeric(lumpcat[i])
    }
  }else{
    iret <-  iret |> as.character() |> as.numeric()
  }   
  
  chkn <- table(iret)
  chkp <- prop.table(chkn)
  if(!is.null(min) && !is.null(prop)) {
    if(min(chkn)<min && min(chkp)<prop) cli::cli_alert_warning("Lumping performed but there are still categories < min or prop ({c(names(chkn[chkn<min]),names(chkp[chkp<prop]))})")
  }else if(!is.null(min)){
    if(min(chkn)<min)  cli::cli_alert_warning("Lumping performed but there are still categories < min ({names(chkn[chkn<min])})")
  }else if(!is.null(prop)){
    if(min(chkp)<prop) cli::cli_alert_warning("Lumping performed but there are still categories < prop ({names(chkp[chkp<prop])})")
  } 
  
  if(!is.null(uniques)) iret <- iret[match(x,uret)]
  if(identical(iret,x)){
    cli::cli_alert_info("Lumping not performed, original vector returned")  
  }else{
    cli::cli_alert_info("Numbers lumped, returned {length(unique(iret))} categories")  
  }
  return(iret) 
}
#------------------------------------------ check_nmdata ------------------------------------------
#' Checks nonmem dataset for common errors/mistakes
#'
#' This function checks if there are any common errors or mistakes within a NONMEM dataset,
#' and reports the results back to console, table or dataframe
#'
#' @param x either a path to a CSV file or a data frame  with the NONMEM data that should be checked
#' @param type integer with the type of checks. Currently 1 can be used for checks that should all pass for a valid analysis
#'   and 2 for checks that trigger further investigation
#' @param ret a character vector to define what kind of output should be returned (either "dfrm", "tbl", "file")
#' @param capt character with the caption of the table (not used in case data frame is returned)
#' @param align alignment of the table passed to [general_tbl] (not used in case data frame is returned)
#' @param size character with font size as for the table [general_tbl] 
#' @param ... additional arguments passed to [general_tbl]
#'
#' @keywords manip
#' @export
#' @return the checks are either printed, returned as dataframe or placed in a PDF
#' @author Richard Hooijmaijers
#' @examples
#'
#' \dontrun{
#'   check_nmdata("nonmemData.csv")
#'   check_nmdata(dataframe)
#' }
check_nmdata <- function(x, type=1, ret="tbl", capt=NULL, align=NULL, size="\\footnotesize", ...){
  if(!is.data.frame(x)){
    chk1   <- try(suppressWarnings(utils::read.csv(x,stringsAsFactors = FALSE, na.strings = c("NA","."))), silent=TRUE)
  }else{
    chk1   <- x
  }
  
  t1res  <- c("1"="CSV is readable","2"="More than 1 line of data","3"="More than 1 data item","4"="First name set (row.names set to FALSE)",
              "5"="Variables ID, TIME and DV present in data","6"="Data ordered on ID and TIME","7"="Quotes not present around data items")
  t2res  <- c("1"="CSV is readable","2"="There are no NA values in data (excluding DV column)","3"="All non-NA DV values have MDV=0",
              "4"="All observation records with DV=0 have MDV=0", "5"="Positive DV not present at t=0","6"="There are no dose records with AMT=0",
              "7"="Default NM variables present","8"="Default NM variables not present","9"="All variable names less than 8 char",
              "10"="All variable contents less than 14 char", "11"="ID variable has less than 5 characters (consider NONMEM FORMAT option if no)")
  if(type==1) resv <- t1res else resv <- t2res
  outchk <- data.frame(Check=resv,result="-",stringsAsFactors=FALSE)

  if(inherits(chk1, "try-error")){
    outchk$result[1] <- "No"
  }else{
    if(!is.data.frame(x)) outchk$result[1] <- "Yes" else outchk$result[1] <- "-"
    if(type==1){
      outchk$result[2] <- ifelse(nrow(chk1)<=1,"No","Yes")
      outchk$result[3] <- ifelse(ncol(chk1)<=1,"No","Yes")
      outchk$result[4] <- ifelse(names(chk1)[1]=="X" | names(chk1)[1]=="", "No", "Yes")
      chkv <- all(c("ID","TIME","DV")%in%names(chk1))
      outchk$result[5] <- ifelse(!chkv,"No","Yes")
      if(chkv){
        chk1$ID <- as.numeric(chk1$ID); chk1$TIME <- as.numeric(chk1$TIME)
        ord <- chk1[order(chk1$ID,chk1$TIME),]
        outchk$result[6] <- ifelse(!all(row.names(chk1)==row.names(ord)),"No","Yes")
      }
      if(!is.data.frame(x)) chkq <- suppressWarnings(readLines(x,n=1)) else chkq <- ""
      outchk$result[7] <- ifelse(any(grepl("\\\"",chkq)),"No","Yes")
    }else if(type==2){
      evidch <- ifelse("EVID"%in%names(chk1),TRUE,FALSE)
      amtch  <- ifelse("AMT"%in%names(chk1),TRUE,FALSE)
      outchk$result[2] <- ifelse(any(apply(chk1[names(chk1)!="DV",,drop=FALSE],2,anyNA)),"No","Yes")
      if(all(c("MDV","DV")%in%names(chk1))){
        outchk$result[3] <- ifelse(sum(chk1$MDV[!is.na(chk1$DV)],na.rm = TRUE)==0,"Yes","No")
        if(evidch) outchk$result[4] <- ifelse(sum(chk1$MDV[chk1$EVID==0 & chk1$DV==0],na.rm = TRUE)==0,"Yes","No") else outchk$result[4] <- "Could not check (no EVID)"
      }
      if(all(c("TIME","DV")%in%names(chk1)))  outchk$result[5] <- ifelse(any(!is.na(chk1$DV) & chk1$TIME==0 & chk1$DV>0),"No","Yes")
      if(evidch && amtch) outchk$result[6] <- ifelse(0%in%chk1$AMT[chk1$EVID==1],"No","Yes") else outchk$result[6] <- "Could not check (no EVID and/or AMT)"
      nmvars            <- c("RECN","MDV","CMT","EVID","AMT","DOSE","RATE")
      outchk$result[7]  <- paste(nmvars[nmvars%in%names(chk1)],collapse=", ")
      outchk$result[8]  <- paste(nmvars[!nmvars%in%names(chk1)],collapse=", ")
      outchk$result[8]  <- ifelse(outchk$result[8]=="","-",outchk$result[8])
      chklen            <- any(nchar(names(chk1))>8)
      outchk$result[9]  <- ifelse(chklen==TRUE,paste0("no (",paste(names(chk1)[nchar(names(chk1))>8],collapse=", "),")"),"yes")
      chkchar           <- apply(chk1,2,function(x) max(nchar(as.character(x),keepNA = TRUE),na.rm = TRUE))
      outchk$result[10] <- ifelse(any(chkchar>14),paste0("no (",paste(names(which(chkchar>14)),collapse=", "),")"),"yes")
      outchk$result[11] <- ifelse("ID"%in%names(chk1) && max(nchar(as.character(chk1$ID)),na.rm = TRUE)<5,"yes","No")
      # The check if csv is readable can be left out here
      outchk <- outchk[outchk$Check!="CSV is readable",]
    }
  }
  if(type==1) cpt <- "Result of essential data checks" else cpt <- "Result of non essential data checks"
  if(!is.null(capt)) cpt <- capt
  general_tbl(outchk, capt=cpt, align=align, ret=ret, size=size, ...)
}

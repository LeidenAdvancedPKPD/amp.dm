#------------------------------------------ attr_add ------------------------------------------
#' Add attributes from a list to a dataframe
#'
#' This function adds data attributes available in a list to a data frame. Additional checks
#' are done to verify if the attributes are in a vliad format and useable
#'
#' @param data the data frame for which the attributes should be set
#' @param attrl named list with the attributes for the dataset (see details)
#' @param attrib a vector of attributes that should be set for data (currently 'label', 'format' and 'remark' are applicable)
#' @param verbose a logical indicating if datachecks should be printed to console
#' @details This function adds attributes available in a list to a data frame. The structure of this list should be available
#'  in a specific format. The names items in the list are aligned with the variables in the data frame. For each item,
#'  the content of the 'label', 'format' and 'remark' elements will be added as attributes to the dataset. For an example
#'  of the format of list see for instance [attr_xls].
#' @keywords attribute
#' @seealso [attr_xls]
#' @export
#' @return dataframe with the attributes added
#' @author Richard Hooijmaijers
#' @examples
#'
#' data(esoph)
#' attr(esoph$ncontrols,'label')   <- 'number of controls'
#' tmp <- subset(esoph,,-agegp)
#' str(tmp)
attr_add <- function(data,attrl,attrib = c('label','format','remark'), verbose = TRUE){

  # perform initial check
  diff1 <- setdiff(names(attrl),names(data))
  diff2 <- setdiff(names(data),names(attrl))
  if(length(diff1)>0 && verbose) cli::cli_alert_danger("Take into account that the following parameters are in list but not in data: {diff1}")
  if(length(diff2)>0 && verbose) cli::cli_alert_danger("Take into account that the following parameters are in data but not in list: {diff2}")

  charat  <- names(data)[nchar(names(data))>8]
  inatt   <- attrl[names(attrl)%in%names(data)]
  inattl  <- sapply(inatt, "[[","label")
  charatl <- inattl[nchar(inattl)>24]
  if(length(charat)>0 && verbose)  cli::cli_alert_danger("Variables in data detected with names > 8 characters (issue for eSubmission): {charat}")
  if(length(charatl)>0 && verbose) cli::cli_alert_warning("Labels detected with > 24 characters (possible issue for reporting): {charatl}")

  # Add attributes to dataframe and return results 
  # For now we have a label (e.g. Time (h)) and units (e.g. h)
  # maybe we need have others as well (e.g. label without unit and LaTeX variants)
  addcats <- misscats <- vector("character")
  for(i in names(data)){
    if(i%in%names(attrl)){
      if('label'%in%attrib && !is.null(attrl[[i]]$label)){
        attr(data[,i],"label")  <- attrl[[i]]$label
        unt <- gsub("[\\(\\)]", "", regmatches(attrl[[i]]$label, gregexpr("\\(.*?\\)", attrl[[i]]$label)))
        unt <- ifelse(unt=="character0","",unt)
        attr(data[,i],"unit")  <- unt
      }  
      if('format'%in%attrib && !is.null(attrl[[i]]$format)){
        charchk <- suppressWarnings(data[,i, drop = TRUE] |> as.numeric() |> is.na() |> all())
        if(charchk){
          fmtchk <- attrl[[i]]$format |> names()
          varchk <- data[,i, drop = TRUE] |> unique() |> stats::na.omit()
        }else{
          fmtchk <- attrl[[i]]$format |> names() |> as.numeric()  
          varchk <- suppressWarnings(data[,i, drop = TRUE] |> unique() |> as.numeric() |> stats::na.omit())          
        }
        if(length(setdiff(fmtchk, varchk)) > 0) misscats <- c(misscats,i)
        if(length(setdiff(varchk, fmtchk)) > 0) addcats  <- c(addcats,i) 
        attr(data[,i],"format")  <- attrl[[i]]$format
      } 
      if('remark'%in%attrib && !is.null(attrl[[i]]$remark)) attr(data[,i],"remark")  <- attrl[[i]]$remark
    }
  }   
  if(length(misscats)>0 && verbose) cli::cli_alert_info("The following variables have less categories than defined in attribute list: {misscats}")
  if(length(addcats)>0 && verbose)  cli::cli_alert_danger("The following variables have more categories than defined in attribute list: {addcats}")
  return(data)
}


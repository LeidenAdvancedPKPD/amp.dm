#------------------------------------------ make_readonly ------------------------------------------
#' Sets the read-only attribute for all files available within a folder
#'
#' This function will change the file attributes so only read access is set
#'
#' @param x character of length 1 with the path that contains files or character vector with filenames to be set to read-only
#' @keywords IO file
#' @export
#' @return nothing is returned, only system commands are issued
#' @author Richard Hooijmaijers
#' @details
#'  This function will attempt to set a read-only attributes on files. This is either done through system commands
#'  such as `attrib` for windows and `chmod` for linux (444). With the latter take into account possible issues
#'  with (sudo) rights on files. 
#'  In case x is a directory, the function will set readonly attribute for all files in the folder (and recurse into all subfolders!).
#' 
#' @examples
#' tmpf <- tempfile(fileext = ".txt")
#' cat("test",file=tmpf)
#' make_readonly(tmpf)   
make_readonly <- function(x){
  if(length(x)>1 || (length(x)==1 && !fs::is_dir(x))){
    ret <- suppressWarnings(try(lapply(normalizePath(x, winslash = "/"),function(fn) fs::file_chmod(fn, "444"))))
  }else{
    if(Sys.info()['sysname']=="Windows"){
      ret <- suppressWarnings(try(shell(paste0("attrib +R \"",normalizePath(x, winslash = "\\") ,"/*\""," /S")), silent=TRUE))  # intern = TRUE, ignore.stdout = TRUE, ignore.stderr = TRUE
    }else if(Sys.info()['sysname']!="Windows"){
      ret <- suppressWarnings(try(system(paste0("chmod -R 444 \"",normalizePath(x) ,"\"")), silent=TRUE))
    }
  }
  if(inherits(ret,"try-error")) cli::cli_alert_danger("Issues in making files read-only, check file attributes")
}

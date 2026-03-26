
context("Test if data can be correctly read and checked")

#--------------------------
# Test read_data function
test_that("read_data correctly reads and logs data and can use a custom function", {
  try(rm(list=ls(envir = .amp.dm),envir = .amp.dm), silent = TRUE)
  xldat    <- readxl::readxl_example("datasets.xlsx")
  sasdat   <- system.file("examples", "iris.sas7bdat", package = "haven")
  spssdat  <- system.file("examples", "iris.sav", package = "haven") 
  dummydat <- data.frame(ID=1,TIME=0:5,res=rnorm(6))
  xptdat   <- tempfile(fileext = ".xpt")
  csvdat   <- tempfile(fileext = ".csv")
  prndat   <- tempfile(fileext = ".prn")
  haven::write_xpt(dummydat, xptdat)
  utils::write.csv(dummydat,csvdat,row.names=FALSE)
  utils::write.table(setNames(dummydat,c("#ID","T","DV")),prndat,row.names=FALSE, quote = FALSE)
  
  xlin    <- read_data(xldat, verbose = FALSE)
  sasin   <- read_data(sasdat, verbose = FALSE)
  xptin   <- read_data(xptdat, verbose = FALSE)
  csvin   <- read_data(csvdat,nrows=3, verbose = FALSE)
  prnin   <- read_data(prndat, verbose = FALSE)
  spssin  <- read_data(spssdat,manfunc="haven::read_sav",comment="custom read-in", verbose = FALSE)
  
  expect_s3_class(xlin,  "data.frame")
  expect_s3_class(sasin,  "data.frame")
  expect_s3_class(xptin,  "data.frame")
  expect_s3_class(csvin,  "data.frame")
  expect_s3_class(prnin,  "data.frame")
  expect_s3_class(spssin,  "data.frame")
  
  expect_message(read_data(csvdat,nrows=3),"Read in.*3.*records")
  expect_error(read_data(csvdat,manfunc="nonexisting"),"Manual function")
  expect_error(read_data(spssdat),"Extension not recognized")
  expect_error(read_data("NonexistingFile.csv"),"File could not be found")
  
  read_nfo <- get_log()$read_nfo
  expect_setequal(dim(read_nfo),c(6,4))
  expect_equal(nrow(xlin),as.numeric(read_nfo$datainrows[grep("xlsx",read_nfo$datain)]))
  expect_equal(nrow(csvin),as.numeric(read_nfo$datainrows[grep("csv",read_nfo$datain)]))
  expect_equal(ncol(sasin),as.numeric(read_nfo$dataincols[grep("sas7bdat",read_nfo$datain)]))
  expect_equal(read_nfo$comment[grep("sav",read_nfo$datain)],"custom read-in")
})

#----------------------------
# Test make_readonly function
test_that("make_readonly correctly sets readonly attribute", {
  tmpfn1 <- tempfile(fileext = ".txt")
  tmpfn2 <- tempfile(fileext = ".txt")
  fs::file_create(tmpfn1, mode = "777")
  fs::file_create(tmpfn2, mode = "777")
  fs::dir_create(paste0(tempdir(),"/newpath/"))
  fs::file_create(paste0(tempdir(),"/newpath/",basename(tmpfn1)), mode = "777")
  
  make_readonly(tmpfn1)
  #expect_equal(substr(fs::file_info(tmpfn1)$permissions,1,3),"r--")
  expect_true(file.access(tmpfn1,mode=2)<0)
  
  make_readonly(tempdir())
  #expect_equal(substr(fs::file_info(tmpfn2)$permissions,1,3),"r--")
  expect_true(file.access(tmpfn2,mode=2)<0)
  #expect_equal(substr(fs::file_info(paste0(tempdir(),"/newpath/",basename(tmpfn1)))$permissions,1,3),"r--")
  expect_true(file.access(paste0(tempdir(),"/newpath/",basename(tmpfn1)),mode=2)<0)
  
  #expect_message(make_readonly("nonexistent_directory"),  "Issues in making files read-only")
})

#--------------------------
# Test output_data function
test_that("output_data correctly outputs data", {
  nm   <- data.frame(ID=1,TIME=0:5,DV=c(NA,1.23456789,rnorm(4)),MDV=c(1,1,0,0,0,0),DAT=Sys.Date() + round(rnorm(6,sd=20),0),LONGVARIABLE=0)
  # Be aware we need check=TRUE/normalizePath for mac_devel version!
  tmpf <- paste0(tempdir(check=TRUE),"/test") |> normalizePath(winslash = "/", mustWork = FALSE)
  
  output_data(nm,csv=paste0(tmpf,".csv"))
  nmr  <- utils::read.csv(paste0(tmpf,".csv"),stringsAsFactors = FALSE)

  expect_equal(unique(nmr$DAT),".")
  expect_equal(dim(nm),dim(nmr))
  expect_equal(as.numeric(nmr$DV[2]),1.234568)
  
  output_data(nm,csv=paste0(tmpf,".csv"),tonum=FALSE,firstesc="#")
  nmrf <- readLines(paste0(tmpf,".csv"),n=1)
  nmr  <- utils::read.csv(paste0(tmpf,".csv"),stringsAsFactors = FALSE)
  expect_true(grepl("#ID,",nmrf))
  expect_true(!any(is.na(nmr$DAT)))
  
  output_data(nm,csv=paste0(tmpf,".csv"),tonum=FALSE,readonly = TRUE)
  output_data(nm,csv=paste0(tmpf,".csv"),tonum=TRUE,readonly = TRUE)
  nmr  <- utils::read.csv(paste0(tmpf,".csv"),stringsAsFactors = FALSE)
  expect_equal(unique(nmr$DAT),".")

  nm2  <- nm[,1:5] # for xpt naming is taken from object name
  output_data(x=nm2,xpt=paste0(tmpf,".xpt"),readonly=TRUE)
  expect_true(basename(paste0(tmpf,".xpt"))%in%list.files(tempdir()))
  
  nm3 <- nm2
  attr(nm3$TIME,"label") <- "Time (h)"
  attr(nm3$MDV,"format") <- c("0"="non-missing", "1"="missing")
  output_data(x=nm3,attr=paste0(tmpf,".rds"),readonly=TRUE)
  attrl <- readRDS(paste0(tmpf,".rds"))
  expect_equal(attrl$TIME$label,"Time (h)")
  expect_equal(attrl$MDV$format,c("0"="non-missing", "1"="missing"))
})

#----------------------------
# Test get_sript function
# skip("difficult to test in testhat environment")
# test_that("get_sript gets the valid script name", {
#   expect_equal(get_script(base=TRUE,noext=TRUE),"test_dataio")
#   expect_equal(get_script(base=TRUE,noext=FALSE),"test_dataio.R")
#   expect_equal(get_script(base=FALSE,noext=TRUE),paste0(getwd(),"/test_dataio"))
#   expect_equal(get_script(base=FALSE,noext=FALSE),paste0(getwd(),"/test_dataio.R"))
# })



context("Test if data can be correctly read and checked")

#--------------------------
# Test read_data function
test_that("read_data correctly reads and logs data and can use a custom function", {
  rm(list=ls(envir = .amp.dm),envir = .amp.dm)
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

#-------------------------------------
# Test write_data function: DEPRECATED
# test_that("write_data correctly exports a NONMEM dataset", {
#   nm   <- data.frame(ID=1,TIME=0:5,DV=c(NA,1.23456789,rnorm(4)),MDV=c(1,1,0,0,0,0),DAT=Sys.Date() + round(rnorm(6,sd=20),0))
#   tmpf <- tempfile(fileext = ".csv")
#   suppressWarnings(write_data(nm,tmpf))
#   nmr  <- utils::read.csv(tmpf,stringsAsFactors = FALSE)
# 
#   expect_equal(unique(nmr$DAT),".")
#   expect_equal(dim(nm),dim(nmr))
#   expect_equal(as.numeric(nmr$DV[2]),1.234568)
# 
#   write_data(nm,tmpf,tonum=FALSE,firstesc="#")
#   nmrf <- readLines(tmpf,n=1)
#   nmr  <- utils::read.csv(tmpf,stringsAsFactors = FALSE)
#   expect_true(grepl("#ID,",nmrf))
#   expect_true(!any(is.na(nmr$DAT)))
# })
# 
# #--------------------------
# # Test output_data function
# test_that("output_data correctly outputs data", {
#   nm   <- data.frame(ID=1,TIME=0:5,DV=c(NA,1.23456789,rnorm(4)),MDV=c(1,1,0,0,0,0),DAT=Sys.Date() + round(rnorm(6,sd=20),0),LONGVARIABLE=0)
#   tmpf <- tempfile()
#   dir.create(paste0(tempdir(),"/","analsysisfolder"),showWarnings = FALSE)
# 
#   output_data(nm,csv=paste0(tmpf,".csv"),dmfolder=tempdir(),anfolder=paste0(tempdir(),"/","analsysisfolder"))
#   nmr  <- utils::read.csv(paste0(tmpf,".csv"),stringsAsFactors = FALSE)
# 
#   expect_equal(unique(nmr$DAT),".")
#   expect_equal(dim(nm),dim(nmr))
#   expect_equal(as.numeric(nmr$DV[2]),1.234568)
# 
#   expect_true(paste0(basename(tmpf),".csv")%in%list.files(paste0(tempdir(),"/","analsysisfolder")))
#   expect_true(paste0(basename(tmpf),".csv")%in%list.files(paste0(tempdir(),"/","analsysisfolder")))
#   expect_true(paste0(basename(tmpf),".rds")%in%list.files(paste0(tempdir(),"/","analsysisfolder")))
#   expect_true("script_attributes.r"%in%list.files(paste0(tempdir(),"/","analsysisfolder")))
# 
#   output_data(nm,csv=paste0(tmpf,".csv"),tonum=FALSE,firstesc="#",dmfolder=tempdir(),anfolder=paste0(tempdir(),"/","analsysisfolder"))
#   nmrf <- readLines(paste0(tmpf,".csv"),n=1)
#   nmr  <- utils::read.csv(paste0(tmpf,".csv"),stringsAsFactors = FALSE)
#   expect_true(grepl("#ID,",nmrf))
#   expect_true(!any(is.na(nmr$DAT)))
# 
#   # Implemented a try structure to overcome an error when file is readonly!
#   # output_data(x=nm,csv=paste0(tmpf,".csv"),readonly=TRUE,dmfolder=tempdir(),anfolder=paste0(tempdir(),"/","analsysisfolder"))
#   # suppressWarnings(expect_error(output_data(x=nm,csv=paste0(tmpf,".csv"),readonly=TRUE,dmfolder=tempdir(),anfolder=paste0(tempdir(),"/","analsysisfolder"))))
# 
#   nm2  <- nm[,1:5] # the output_data function does not work with directly subsetting in testthat (e.g. output_data(x=nm[,1:5]))?
#   suppressWarnings(output_data(x=nm2,xpt=paste0(tmpf,".xpt"),readonly=TRUE,dmfolder=tempdir(),attributes=FALSE))
#   expect_true(basename(paste0(tmpf,".xpt"))%in%list.files(tempdir()))
#   # the output is too ellobarate to fully check, omit test therefore
#   #expect_output(suppressWarnings(output_data(x=nm,xpt=paste0(tmpf,".xpt"),readonly=TRUE,dmfolder=tempdir(),attributes=FALSE)),"8 characters or less <U\\+2718>")
# })
# 
# #----------------------------------
# # Test defineR function: DEPRECATED
# test_that("defineR function works as expected", {
#   nm     <- data.frame(ID=1,TIME=0:5,DV=c(NA,1.23456789,rnorm(4)),MDV=c(1,1,0,0,0,0),DAT=Sys.Date() + round(rnorm(6,sd=20),0))
#   dir.create(paste0(tempdir(),"/anfold"), showWarnings = FALSE)
#   writeLines("dummyModel",paste0(tempdir(),"/run1.mod"))
#   suppressWarnings(defineR(nm,dmfolder=tempdir(),anfolder=paste0(tempdir(),"/anfold"),models=paste0(tempdir(),"/run1.mod"),
#                            xpt = FALSE, pdf = FALSE, rds = FALSE, attr_tmpl = FALSE))
# 
#   expect_true("nm.csv"%in%list.files(tempdir()))
#   expect_true("nm.csv"%in%list.files(paste0(tempdir(),"/anfold")))
#   expect_true("run1_mod.txt"%in%list.files(tempdir()))
#   expect_equal(readLines(paste0(tempdir(),"/run1.mod")),"dummyModel")
#   expect_true(!"nm.xpt"%in%list.files(tempdir()))
#   expect_true(!"define.pdf"%in%list.files(tempdir()))
#   expect_true(!"nm.rds"%in%list.files(tempdir()))
# 
#   nm2 <- nm
#   # omitted checks, this fails because SASxport is no longer present. This function is however deprecated and will not be changed
#   # defineR(nm2,dmfolder=tempdir(),anfolder=paste0(tempdir(),"/anfold"),models=paste0(tempdir(),"/run1.mod"),
#   #         xpt = TRUE, pdf = FALSE, rds = TRUE, attr_tmpl = TRUE)
#   #
#   # expect_true("nm2.xpt"%in%list.files(tempdir()))
#   # expect_true("nm2.rds"%in%list.files(paste0(tempdir(),"/anfold")))
#   # expect_true("script_attributes.r"%in%list.files(paste0(tempdir(),"/anfold")))
# })
# 
# #------------------------
# # Test definePDF function
# test_that("definePDF function works as expected", {
# 
#   tmpf1 <- tempfile(fileext = ".tex")
#   suppressWarnings(definePDF(xls=system.file("/tests/NM.test.Attr.xls.A.v1.xlsx", package = "DMTools"),outnm=tmpf1,show=FALSE))
#   res1  <- readLines(tmpf1)
#   expect_match(res1[grep("RECN",res1)],"1 & RECN & Record number & - & - \\\\")
#   expect_match(res1[grep("ID",res1)],"2 & ID & Unique subject identifier & - & Combination between SUBJECT and STUD  \\\\")
#   expect_match(res1[grep("TIME",res1)],"3 & TIME & Time & h & - \\\\")
#   expect_match(res1[grep("DV",res1)][1],"4 & DV & Dependent variable & unit & - \\\\")
#   expect_match(res1[grep("CMT",res1)],"6 & CMT & Compartment & - &  1=Dosing compartment")
# 
#   tmpf2 <- tempfile(fileext = ".tex")
#   dfrm  <- data.frame(GENDER=rep(c(0,1),4),RESULT=rnorm(8),TRT=sample(1:3,8,TRUE))
#   attr(dfrm$GENDER,'format')   <- c('0' = 'Male > 20', '1' = 'Female < 20')
#   attr(dfrm$RESULT,'label')    <- 'Results (ng)'
#   suppressWarnings(definePDF(dfrm=dfrm,show=FALSE,cols="llllp{8cm}",outnm=tmpf2))
#   res2  <- readLines(tmpf2)
#   expect_true(file.exists(gsub("\\.tex",".pdf",tmpf2)))
#   expect_match(res2[grep("GENDER",res2)],"1 & GENDER & - & - &  0  =  Male \\$>\\$ 20, 1  =  Female \\$<\\$ 20 \\\\")
#   expect_true(any(grepl("8cm" ,res2)))
# 
#   tmpf3 <- tempfile(fileext = ".tex")
#   output_data(dfrm,csv="test3.csv",dmfolder=tempdir(),anfolder=tempdir(),attributes = TRUE)
#   suppressWarnings(definePDF(rds=paste0(tempdir(),"/test3.rds"),outnm=tmpf3,show=FALSE))
#   res3  <- readLines(tmpf3)
#   expect_match(res3[grep("GENDER",res3)],"1 & GENDER & - & - &  0 = Male \\$>\\$ 20, 1 = Female \\$<\\$ 20 \\\\")
#   expect_true(file.exists(gsub("\\.tex",".pdf",tmpf3)))
# })
# 
# #---------------------------
# # Test check_nmdata function
# test_that("check_nmdata correctly checks a NONMEM dataset", {
#   nm   <- data.frame(ID=1,TIME=0:5,DV=c(NA,rnorm(5)),MDV=c(1,1,0,0,0,0))
#   tmpf <- tempfile(fileext = ".csv")
#   utils::write.csv(nm,tmpf,row.names = FALSE, na=".",quote=FALSE)
#   res  <- check_nmdata(file=tmpf,ret="df")
#   tbl  <- capture.output(check_nmdata(tmpf,ret="tbl"))
# 
#   expect_true(all(res$result=="Yes"))
#   expect_true(any(grepl("begin\\{longtable\\}",tbl)))
# 
#   utils::write.csv(nm[1,1,drop=FALSE],tmpf,row.names = FALSE, na=".",quote=FALSE)
#   res    <- check_nmdata(tmpf,ret="df")
#   varin1 <- c("More than 1 line of data","More than 1 data item","Variables ID, TIME and DV present in data")
#   varin2 <- "Data ordered on ID and TIME"
#   expect_equal(unique(res$result[res$Check%in%varin1]),"No")
#   expect_equal(unique(res$result[res$Check%in%varin2]),"-")
# 
#   res  <- check_nmdata(file=tmpf,ret="df",type=2)
#   expect_equal(nrow(res),10)
# })

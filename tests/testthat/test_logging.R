
context("Test if attribute functions work as expected")

#-----------------------
# Test cmnt and cmt_print function
test_that("cmnt function works as expected", {
  rm(list=ls(envir = .amp.dm),envir = .amp.dm)
  expect_message(cmnt("Exclude time points > 12h"),"Exclude time")
  expect_no_message(cmnt("Exclude time points > 12h",verbose = FALSE))
  
  expect_vector(cmnt_print(FALSE), size=1)  
  expect_match(cmnt_print(FALSE),"Assumptions and special attention.*> 12h")
  
  expect_vector(cmnt_print(), size=1)  
  expect_null(cmnt_print())  
  
  cmnt("First comment", bold = TRUE, verbose = FALSE)
  cmnt("**Comment** *with* `md`", verbose = FALSE)
  res <- get_log()
  expect_s3_class(res$cmnt_nfo, "data.frame")
  expect_true(nrow(res$cmnt_nfo)==2)
  expect_true(all(res$cmnt_nfo$bold%in%c(TRUE,FALSE)))
})

#-----------------------
# Test srce function
test_that("srce function works as expected", {
  rm(list=ls(envir = .amp.dm),envir = .amp.dm)
  srce(AMT,Theoph.Dose)
  srce(AMT,Theoph.Dose)
  res <- get_log()
  expect_s3_class(res$srce_nfo, "data.frame")
  expect_equal(nrow(res$srce_nfo), 1)
  srce(BMI,c(wt.WEIGHT,ht.HEIGHT),'d')
  res <- get_log()
  expect_setequal(dim(res$srce_nfo),c(2,3))
  expect_equal(res$srce_nfo$variable[1], "AMT")
  expect_equal(res$srce_nfo$type[1], "c")
  expect_equal(res$srce_nfo$source[2], "wt.WEIGHT, ht.HEIGHT")
  expect_equal(res$srce_nfo$type[2], "d")
})

#-----------------------
# Test filterr function
test_that("filterr function works as expected", {
  rm(list=ls(envir = .amp.dm),envir = .amp.dm)
  dfrm  <- data.frame(GENDER=rep(c(0,1),4),RESULT=rnorm(8),TRT=sample(1:3,8,TRUE))
  dfrm2 <- suppressMessages(filterr(dfrm, GENDER==0,comment="deleted gender 0"))
  
  res <- get_log()
  expect_equal(unique(dfrm2$GENDER), 0)
  expect_s3_class(res$filterr_nfo, "data.frame")
  expect_equal(nrow(subset(dfrm,GENDER==0)),as.numeric(res$filterr_nfo$dataoutrows))
  expect_equal(nrow(dfrm), as.numeric(res$filterr_nfo$datainrows))
  expect_equal(nrow(dfrm) - nrow(subset(dfrm,GENDER==0)), as.numeric(res$filterr_nfo$rowsdropped))
  expect_equal(as.character(res$filterr_nfo$comment),"deleted gender 0")
  
  dfrm2 <- suppressMessages(filterr(dfrm, GENDER==0,comment="deleted gender 0"))
  res   <- get_log()
  expect_equal(nrow(res$filterr_nfo),1)
  
  expect_message(filterr(dfrm, GENDER!=999),"Filter.*0.*deleted")
  dfrm3 <- suppressMessages(filterr(dfrm, GENDER==1,comment="deleted gender 1"))
  res   <- get_log()
  expect_equal(nrow(res$filterr_nfo),3)
})

#-----------------------
# Test left_joinr function
test_that("left_joinr function works as expected", {
  rm(list=ls(envir = .amp.dm),envir = .amp.dm)
  dfrm1 <- data.frame(ID=1:8,GENDER=rep(c(0,1),4),RESULT=rnorm(8),TRT=sample(1:3,8,TRUE))
  dfrm2 <- data.frame(ID=8:2,AGE=18:24)
  
  test1 <- suppressMessages(left_joinr(dfrm1,dfrm2,comment="merge dfrm1 with ages"))
  test2 <- merge(dfrm1,dfrm2, all.x = TRUE)
  expect_equal(test1,test2)
  
  res   <- get_log()
  expect_s3_class(res$joinr_nfo, "data.frame")
  expect_equal(nrow(dfrm1),as.numeric(res$joinr_nfo$datainrowsl))
  expect_equal(nrow(dfrm2),as.numeric(res$joinr_nfo$datainrowsr))
  expect_equal(as.character(res$joinr_nfo$comment),"merge dfrm1 with ages")
  
  dfrm3 <- rbind(dfrm1,c(8,1,1.2345,3))
  dfrm4 <- rbind(dfrm2,c(8,26))
  expect_message(left_joinr(dfrm3,dfrm4,relationship="many-to-many"),"cartesian product")
  
  test3 <- suppressMessages(left_joinr(dfrm1,dfrm2,comment="merge dfrm1 with ages"))
  res <- get_log()
  expect_equal(nrow(res$joinr_nfo),2)
})

#----------------------------
# Test get_sript function
# skip("get script does not work as expected when sourced")
# test_that("get_sript gets the valid script name", {
#   expect_equal(get_script(base=TRUE,noext=TRUE),"test_logging")
#   expect_equal(get_script(base=TRUE,noext=FALSE),"test_logging.R")
#   expect_equal(get_script(base=FALSE,noext=TRUE),paste0(getwd(),"/test_logging"))
#   expect_equal(get_script(base=FALSE,noext=FALSE),paste0(getwd(),"/test_logging.R"))
# })

#--------------------------------
# Test log_df function
test_that("log_df correctly creates output of logged information", {
  
  dat1 <- filterr(Theoph,Subject==1)
  dat2 <- Theoph |> filterr(Subject==2,comment = "keep id 2")

  sasdat  <- system.file("examples", "iris.sas7bdat", package = "haven")
  sasin   <- read_data(sasdat, verbose = FALSE)
  
  dfrm1 <- data.frame(ID=1:8,GENDER=rep(c(0,1),4),RESULT=rnorm(8),TRT=sample(1:3,8,TRUE))
  dfrm2 <- data.frame(ID=8:2,AGE=18:24)
  dfrm3 <- suppressMessages(left_joinr(dfrm1,dfrm2,comment="merge dfrm1 with ages"))
  
  res1 <- log_df(get_log(), "filterr_nfo")
  expect_equal(unique(res1$datainrows),nrow(Theoph))
  expect_equal(unique(res1$dataoutrows[2]),nrow(Theoph[Theoph$Subject==2,]))
  expect_equal(unique(res1$comment[2]),"keep id 2")
  
  res2 <- log_df(get_log(), "joinr_nfo")
  expect_equivalent(res2,get_log()$joinr_nfo)
  
  res3 <- log_df(get_log(), "read_nfo")
  expect_equivalent(res3,get_log()$read_nfo)
  
  res4 <- capture.output(log_df(get_log(), "filterr_nfo", ret="tbl", align = "lllll"))
  expect_true(any(grepl("lllll",res4)))
  res5 <- capture.output(log_df(get_log(), "read_nfo", ret="tbl"))
  expect_true(any(grepl("path\\{",res5)))
  expect_true(any(grepl("Data in",res5)))
  res6 <- log_df(get_log(), "filterr_nfo", coding=FALSE)
  expect_equal(ncol(res6),5)
  res7 <- capture.output(log_df(get_log(), "filterr_nfo", capt="test output",ret="tbl"))
  expect_true(any(grepl("test output",res7)))
  res8 <- log_df(get_log(), "dummy")
  expect_null(res8)
})

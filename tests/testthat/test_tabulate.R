#--------------------------
# Test general_tbl function
test_that("general_tbl correctly creates generic latex table",{
  tbl <- capture.output(general_tbl(Theoph))
  
  expect_true(any(grepl("longtable",tbl)))
  expect_true(any(grepl("toprule",tbl)))
  expect_true(any(grepl("midrule",tbl)))
  expect_true(any(grepl("endhead",tbl)))
  
  th2 <- general_tbl(Theoph, ret="dfrm")
  expect_equal(Theoph,th2)
  
  tmpf1 <- tempfile(fileext = ".tex")
  general_tbl(Theoph, outnm=tmpf1, ret="file", show=FALSE)
  ret2  <- readLines(tmpf1)
  expect_true(any(grepl("begin\\{document\\}",ret2)))
  expect_true(any(grepl("11 & 65.0 & 4.92 &  0.00 &  0.00 \\\\\\\\",ret2)))
})

#----------------------
# Test define_tbl function
test_that("define_tbl correctly tabulates attributes",{
  expect_error(define_tbl(),"Make sure attr is provided")
  attrl <- attr_xls(system.file("example","Attr.Template.xlsx",package = "amp.dm"))
  
  ret <- define_tbl(attrl)
  expect_equal(ret$Description[ret$Data.Item=="ID"],"Unique subject identifier")
  expect_equal(ret$Unit[ret$Data.Item=="AMT"],"mg")
  expect_equal(trimws(ret$Remark[ret$Data.Item=="SEX"]),"0 = Male, 1 = Female")
  
  tbl  <- capture.output(define_tbl(attrl,ret="tbl"))
  expect_true(any(grepl("begin\\{longtable\\}",tbl)))
  
  tmpf1 <- tempfile(fileext = ".tex")
  define_tbl(attrl, outnm=tmpf1, ret="file", show=FALSE)
  ret2  <- readLines(tmpf1)
  expect_true(any(grepl("begin\\{document\\}",ret2)))
  expect_match(ret2[grep("^TIME ",ret2)],"TIME & Time & h & - \\\\\\\\")
  
  srce(BMI,c(wt.WEIGHT,ht.HEIGHT),'d')
  ret <- define_tbl(attrl)
  expect_match(ret$Remark[ret$Data.Item=="BMI"],"source.*wt.WEIGHT.*ht.HEIGHT.*derived")
})


#----------------------
# Test contents_df function
test_that("contents_df correctly tabalates records",{
  Theoph2 <- subset(Theoph,Subject==1)
  assign("Theoph",Theoph,envir=.GlobalEnv)   # Make sure data frames are in global environment
  assign("Theoph2",Theoph2,envir=.GlobalEnv) # Make sure data frames are in global environment
  
  expect_error(contents_df(c('dummy')),"Not all data frames could be found")
  res     <- contents_df(c('Theoph','Theoph2'),subject='Subject',ret='dfrm')
  
  expect_equal(res$records[1],nrow(Theoph))
  expect_equal(res$records[2],nrow(Theoph2))
  expect_equal(res$subjects[2],length(unique(Theoph2$Subject)))

  res     <- contents_df(c('Theoph','Theoph2'),ret='dfrm')
  expect_true(!"subject"%in%names(res))
})

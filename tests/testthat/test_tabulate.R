#--------------------------
# Test general_tbl function
test_that("general_tbl correctly creates generic latex table, file or passes data frame",{
  tbl <- capture.output(general_tbl(Theoph))
  
  expect_true(any(grepl("longtable",tbl)))
  expect_true(any(grepl("toprule",tbl)))
  expect_true(any(grepl("midrule",tbl)))
  expect_true(any(grepl("endhead",tbl)))
  
  th2 <- general_tbl(Theoph, ret="dfrm")
  expect_equal(Theoph,th2)
  
  tmpf1 <- tempfile(fileext = ".tex")
  general_tbl(Theoph, outnm=tmpf1, ret="file", show=FALSE, compile = FALSE)  
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
  define_tbl(attrl, outnm=tmpf1, ret="file", show=FALSE, compile = FALSE)  
  ret2  <- readLines(tmpf1)
  expect_true(any(grepl("begin\\{document\\}",ret2)))
  expect_match(ret2[grep("^TIME ",ret2)],"TIME & Time & h & - \\\\\\\\")
  
  define_tbl(attrl, outnm=tmpf1, ret="file", show=FALSE, compile = FALSE,
             template = system.file("listing.tex",package = "R3port"))
  ret3  <- readLines(tmpf1)
  expect_true(any(grepl("ttdefault",ret3)))  
  
  
  srce(BMI,c(wt.WEIGHT,ht.HEIGHT),'d')
  ret  <- define_tbl(attrl)
  expect_match(ret$Remark[ret$Data.Item=="BMI"],"source.*wt.WEIGHT.*ht.HEIGHT.*derived")
  ret2 <- define_tbl(attrl, src=get_log()$srce_nfo)
  expect_equal(ret,ret2)
})


#----------------------
# Test contents_df function
test_that("contents_df correctly tabulates records",{
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

#----------------------
# Test counts_df function
test_that("counts_df correctly tabulates counts and frequencies",{
  
  data("Theoph")
  Theoph$trt <- ifelse(as.numeric(Theoph$Subject)<6,1,2)
  Theoph$sex <- ifelse(as.numeric(Theoph$Subject)<4,1,0)
  
  res   <- counts_df(data=Theoph, by=c("trt","sex"),id="Subject", ret="dfrm")
  resm1 <- table(Theoph$trt,Theoph$sex)
  resm2 <- prop.table(resm1)
  expect_equal(dim(res),c(4,6))
  expect_equal(res$Nobs[nrow(res)],nrow(Theoph))
  expect_equal(res$Nobs[res$trt=="1" & res$sex=="0"],resm1[1,1])
  expect_equal(res$PERCobs[res$trt=="1" & res$sex=="0"],resm2[1,1]*100)
  
  res <- counts_df(data=Theoph, by=c("trt","sex"),id="Subject", style=2, ret="dfrm")
  expect_equal(dim(res),c(4,4))
  
  res <- capture.output(counts_df(data=Theoph, by=c("trt","sex"),id="Subject", style=2, ret="tbl"))
  expect_true(any(grepl("begin\\{longtable\\}",res)))
})

#----------------------------
# Test session_table function
test_that("session_table correctly gets the session information",{
  ret <- session_tbl("dfrm")
  pks <- sapply(utils::sessionInfo()$otherPkgs,function(x) paste0(x$Package," (",x$Version,")"))
  
  expect_equal(as.character(ret$value[ret$parameter=="R version"]),utils::sessionInfo()$R.version$version.string)
  expect_equal(as.character(ret$value[ret$parameter=="System"]),utils::sessionInfo()$platform)
  expect_equal(as.character(ret$value[ret$parameter=="OS"]),utils::sessionInfo()$running)
  expect_equal(as.character(ret$value[ret$parameter=="Base packages"]),paste(utils::sessionInfo()$basePkgs,collapse=", "))
  expect_equal(as.character(ret$value[ret$parameter=="Other packages"]),paste(pks,collapse=", "))
  expect_equal(as.character(ret$value[ret$parameter=="Logged in User"]),as.character(Sys.info()["user"]))
  ret2 <- capture.output(session_tbl("tbl"))
  expect_match(paste(ret2,collapse=" "),regexp=as.character(Sys.info()["user"]))
})

#-----------------------
# Test stats_df function
test_that("stats_df provides correct stats",{
  Theoph$conc[nrow(Theoph)] <- NA
  Theoph$trt                <- "NA"
  Theoph$trt[nrow(Theoph)]  <- "B"
  Theoph$sex <- ifelse(as.numeric(Theoph$Subject)<4,1,NA)
  
  ret <- stats_df(Theoph,ret="dfrm")
  
  expect_equal(as.numeric(ret$Min[ret$Variable=="Subject"]),min(as.numeric(Theoph$Subject)))
  expect_equal(as.numeric(ret$Max[ret$Variable=="Wt"]),max(as.numeric(Theoph$Wt)))
  expect_equal(as.character(ret$Categories[ret$Variable=="Dose"]),paste(unique(Theoph$Dose),collapse=" / "))
  expect_equal(as.character(ret$Categories[ret$Variable=="Time"]),paste0("More than 10 cats (",length(unique(Theoph$Time)),")"))
  expect_equal(sub(" .*","",as.character(ret$Nna[ret$Variable=="conc"])), paste(sum(is.na(Theoph$conc))))
  ret2 <- capture.output(stats_df(Theoph,ret="tbl"))
  expect_match(paste(ret2,collapse=" "),regexp="begin\\{longtable\\}")
})

#---------------------------
# Test check_nmdata function
test_that("check_nmdata correctly checks a NONMEM dataset", {
  nm   <- data.frame(ID=1,TIME=0:5,DV=c(NA,rnorm(5)),MDV=c(1,1,0,0,0,0))
  tmpf <- tempfile(fileext = ".csv")
  utils::write.csv(nm,tmpf,row.names = FALSE, na=".",quote=FALSE)
  res  <- check_nmdata(tmpf,ret="dfrm")
  tbl  <- capture.output(check_nmdata(tmpf,ret="tbl"))

  expect_true(all(res$result=="Yes"))
  expect_true(any(grepl("begin\\{longtable\\}",tbl)))

  utils::write.csv(nm[1,1,drop=FALSE],tmpf,row.names = FALSE, na=".",quote=FALSE)
  res    <- check_nmdata(tmpf,ret="dfrm")
  varin1 <- c("More than 1 line of data","More than 1 data item","Variables ID, TIME and DV present in data")
  varin2 <- "Data ordered on ID and TIME"
  expect_equal(unique(res$result[res$Check%in%varin1]),"No")
  expect_equal(unique(res$result[res$Check%in%varin2]),"-")

  res  <- check_nmdata(tmpf,ret="dfrm",type=2)
  expect_equal(nrow(res),10)
  res2 <- check_nmdata(nm[1,1,drop=FALSE],ret="dfrm",type=2)
  expect_equal(res,res2)
  
  res3 <- check_nmdata("tmpf",ret="dfrm",type=2)
  expect_equal(res3$result[1],"No")
  res4 <- check_nmdata(nm,ret="dfrm",type=1)
  expect_equal(res4$result[1],"-")
  nm$EVID <- ifelse(nm$TIME==0,1,0)
  nm$AMT  <- ifelse(nm$TIME==0,10,0)
  res5 <- check_nmdata(nm,ret="dfrm",type=2)
  expect_equal(nrow(res5),nrow(res))
})
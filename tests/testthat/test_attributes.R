
context("Test if attribute functions work as expected")

#-----------------------
# Test attr_xls function
test_that("attr_xls correctly takes attributes from excel file", {
  res  <- attr_xls(system.file("example/Attr.Template.xlsx",package = "amp.dm"))
  expect_equal(res$ID$label,"Unique subject identifier")
  expect_null(res$ID$remark)
  expect_equal(res$AMT$remark,"Original dose units set to mg")
  expect_equal(res$TIME$label,"Time (h)")
  expect_named(res$CMT$format)
  expect_equal(res$CMT$format[1],c("1"="Dosing compartment"))
  expect_equal(res$CMT$format[2],c("2"="Central compartment"))
  expect_equal(res$MDV$format[1],c("0"="Other"))
  res2 <- attr_xls(system.file("example/Attr.Template.xlsx", package = "amp.dm"),sepfor=",")
  expect_length(res2$CMT$format,1)
})

#-----------------------
# Test attr_add function
test_that("attr_add correctly assigns attributes and does proper checking", {
  xmpl   <- system.file("example/Attr.Template.xlsx",package = "amp.dm")
  attrl  <- attr_xls(xmpl)
  data   <- read.csv(system.file("example/NM.theoph.V1.csv",package = "amp.dm"), na.strings = ".")
  
  attrl2 <- attrl[5:19]
  data2  <- data[,!names(data)%in%c("ID","WEIGHT")]
  inatt  <- attrl2[names(attrl2)%in%names(data2)]
  
  expect_message(attr_add(data2,attrl),"ID.*WEIGHT")
  expect_message(attr_add(data,attrl2),"ID.*TRT")
  
  data3  <- data
  names(data3)[1] <- "ThisNameIsTooLong"
  expect_message(attr_add(data3,attrl),"> 8 characters")
  expect_message(attr_add(data,attrl),"> 24 characters")
  
  attrl3 <- attrl
  attrl3$CMT$format   <- c("1"="Dosing compartment")
  attrl3$CNTRY$format <- c(attrl3$CNTRY$format,"99"="Missing")
  expect_message(attr_add(data,attrl3),"more categories.*CMT")
  expect_message(attr_add(data,attrl3),"less categories.*CNTRY")
  
  res <- attr_add(data,attrl, verbose = FALSE)
  expect_equal(attr(res$ID,'label'),"Unique subject identifier")
  expect_equal(attr(res$TIME,'label'),"Time (h)")
  expect_equal(attr(res$AMT,'remark'),"Original dose units set to mg")
  expect_equal(attr(res$CMT,'format')[1],c("1"="Dosing compartment"))
  expect_equal(attr(res$CMT,'format')[2],c("2"="Central compartment"))
  expect_null(attr(res$TIME,'remark'))
  expect_null(attr(res$ID,'format'))
})

#-----------------------
# Test attr_factor function
test_that("attr_factor correctly sets formats and leave othe attributes in tact", {
  xmpl   <- system.file("example/Attr.Template.xlsx",package = "amp.dm")
  attrl  <- attr_xls(xmpl)
  data   <- read.csv(system.file("example/NM.theoph.V1.csv",package = "amp.dm"), na.strings = ".")
  data2  <- attr_add(data,attrl, verbose = FALSE)
  data3  <- attr_factor(data2)
  
  expect_equal(dim(data2),dim(data3))
  expect_equal(names(data2),names(data3))
  
  expect_equal(attr(data3$TIME,'label'),"Time (h)")
  expect_null(attr(data3$TIME,'remark'))
  expect_equal(attr(data3$AMT,'remark'),"Original dose units set to mg")
  expect_s3_class(data3$TRT,  "factor")
  expect_equal(sort(levels(data3$SEX)),  c("Female","Male"))
  
  attrl2 <- attrl
  attrl2$charvar <- list(format=c("a"="AA", "b"="BB"))
  data4  <- data
  data4$charvar  <- sample(letters[1:2], nrow(data4), replace = TRUE)
  data4  <- attr_add(data4,attrl2, verbose = FALSE)
  data4  <- attr_factor(data4)
  expect_s3_class(data4$charvar,  "factor")
  expect_equal(sort(levels(data4$charvar)),  c("AA","BB"))
  
  attrl3 <- attrl
  attrl3$CMT$format   <- c("1"="Dosing compartment")
  attrl3$CNTRY$format <- c(attrl3$CNTRY$format,"99"="Missing")
  data5 <- attr_add(data,attrl3, verbose = FALSE)
  expect_message(attr_factor(data5),"More categories.*CMT")
  expect_message(attr_factor(data5),"More formats.*CNTRY")
})




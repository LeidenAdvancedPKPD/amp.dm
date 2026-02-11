#------------------------
# Test plot_vars function
test_that("plot_vars, Create different kind of plots for variables)", {
  Theoph$AMT  <- ifelse(duplicated(Theoph$Subject),NA,Theoph$Dose)
  Theoph$ADDL <- ifelse(duplicated(Theoph$Subject),NA,c(1:4))
  Theoph$ADDL <- as.factor(Theoph$ADDL)

  pl <- plot_vars(Theoph)
  expect_equal(class(pl),"list")
  pl <- plot_vars(Theoph,ppp=4)
  expect_equal(length(as.list(pl)),2)

  expect_equal(names(pl$`1`[[1]]$data), c("Var1","count"))
  expect_equal(names(pl$`1`[[2]]$data), c("plvar"))
  expect_equal(nrow(pl$`1`[[2]]$data), nrow(Theoph))
})

#----------------------------
# Test flag_outliers function
test_that("flag_outliers will indicate outliers", {
  dat <- data.frame(a = 1:10, b = c(1:9,50))
  expect_equal(unique(flag_outliers(dat$a)), 0)
  expect_equal(tail(flag_outliers(dat$b),1), 1)
})

#----------------------------
# Test impute_covar function
test_that("impute_covar imputes values", {
  data1      <- data.frame(num1 = 1:10, cat1 = c(letters[1:5],rep("f",5)),id=c(1:9,9))
  data1$fct1 <- factor(data1$cat1)
  data1$num1[5] <- NA
  data1$cat1[4] <- NA
  data1$fct1[3] <- NA
  
  expect_equal(median(c(1:4,6:10)), impute_covar(data1$num1,type="median")[5])
  expect_message(impute_covar(data1$num1,type="median", verbose = TRUE))
  
  expect_equal(sd(c(1:4,6:10)), impute_covar(data1$num1,type="sd")[5])
  expect_equal(mean(c(1:4,6:9)), impute_covar(data1$num1,uniques = data1$id, type="mean")[5])
  
  expect_message(impute_covar(data1$num1,type="largest", verbose = TRUE),"Multiple")
  
  expect_equal("f", impute_covar(data1$cat1,type="largest")[4])
  expect_s3_class(impute_covar(data1$fct1,type="largest"), "factor")
})

#-----------------------
# Test num_lump function
test_that("num_lump performs correct lumping", {
  
  dfrm <- data.frame(id = 1:30, cat = c(rep(1,8),rep(2,13), rep(3,4),rep(4,5)))
  
  ret  <- num_lump(x=dfrm$cat, lumpcat=99, prop=0.15)
  expect_true(length(ret[ret==99])==4)
  ret  <- num_lump(x=dfrm$cat, lumpcat=99, prop=0.17)
  expect_true(length(ret[ret==99])==9)
  ret  <- num_lump(x=dfrm$cat, lumpcat=99, min=1) 
  expect_identical(ret,dfrm$cat)
  expect_message(num_lump(x=dfrm$cat, lumpcat=99, min=5),"still.*categories.*<.*min")
  ret  <- num_lump(x=dfrm$cat, lumpcat=99, min=6)
  expect_true(length(ret[ret==99])==9)
  ret  <- num_lump(x=dfrm$cat, lumpcat=99, prop=0.2, min=1) # either prop or min is used for condition!
  expect_true(length(ret[ret==99])==9)
  
  ret  <- num_lump(x=dfrm$cat, lumpcat=2, min=5)
  expect_true(length(ret[ret==2])==17)
  ret  <- num_lump(x=dfrm$cat, lumpcat="largest", min=5)
  expect_true(length(ret[ret==2])==17)
  ret  <- num_lump(x=dfrm$cat, lumpcat=c('3'=1,'4'=2), min=6)
  expect_true(length(ret[ret==1])==12)
  expect_true(length(ret[ret==2])==18)
  expect_message(num_lump(x=dfrm$cat, lumpcat=c('3'=1,'4'=2, '1'=2), min=6),"Circular.*assignment")
})
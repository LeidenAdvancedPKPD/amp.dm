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
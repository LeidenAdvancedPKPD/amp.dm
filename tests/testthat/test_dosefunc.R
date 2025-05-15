
context("Test the functions used to create and adapt dosing")

#--------------------------
# Test create_addl function
test_that("create_addl creates the valid number of ADDL and II records", {
  
  dts  <- c(Sys.time(),Sys.time() + (24*60*60),Sys.time() + (48*60*60),Sys.time() + (96*60*60))
  data <- data.frame(ID=1,dt=dts,DOS=10,tau=24)
  dts2 <- c(Sys.time(),Sys.time() + (12*60*60),Sys.time() + (24*60*60),Sys.time() + (34*60*60))
  data <- rbind(data.frame(ID=2,dt=dts2,DOS=100,tau=12),data)
  dts3 <- c(Sys.time(),Sys.time() + (24.5*60*60),Sys.time() + (49*60*60),Sys.time() + (73*60*60))+(6*24*60*60)
  fin  <- rbind(data,data.frame(ID=2,dt=dts3,DOS=100,tau=24),
                data.frame(ID=3,dt=Sys.time() + (2400*60*60),DOS=50,tau=24))
  fin2 <-  rbind(cbind(fin,EVID=1,DV=NA),data.frame(ID=2,dt=dts3+360,DOS=100,tau=24,DV=12,EVID=0))
  
  expect_error(create_addl(fin2))
  expect_error(create_addl(fin2, datetime="dt", id="ID", dose="DOS"))
  expect_error(create_addl(fin2, datetime="dt", id="ID", dose="DOS", tau="tauue"),"Var.*tau")
  
  res1  <- create_addl(fin, datetime="dt", id="ID", dose="DOS", tau="tau")
  res1c <- fin |> create_addl("dt", "ID", "DOS", "tau")

  expect_equal(res1,res1c)
  expect_equal(res1$ADDL[1],2)
  expect_equal(res1$ADDL[2],0)
  expect_equal(res1$ADDL[3],2)
  expect_equal(res1$ADDL[nrow(res1)],0)
  expect_equal(nrow(res1),8)
  
  dfrm <- data.frame(ID=c(1,1,2,2,2),dt=as.POSIXlt(c("2016-10-01 10:44:29","2016-10-01 16:44:29","2016-12-01 10:00:00","2016-12-02 8:00:00","2016-12-03 10:00:00"), "%Y-%m-%d %H:%M:%S",tz="GMT"),
                     dose=20,tau=c(6,12,24,24,24))
  res2 <- create_addl(dfrm, datetime="dt", id="ID", dose="dose", tau="tau")
  expect_equal(unique(res2$ADDL),0)
  
  res3 <- create_addl(fin2, datetime="dt", id="ID", dose="DOS", tau="tau", evid = "EVID")
  expect_equal(unique(res3$ADDL[!is.na(res3$ADDL)]),unique(res1$ADDL))
  expect_equal(nrow(res3[is.na(res3$ADDL),]),4)
})

#--------------------------
# Test expand_addl_ii function
test_that("expand_addl_ii puts each ADDL record correctly on a separate line", {
  dfrm  <- data.frame(ID=c(1,1,2), TIME=c(0,12,0),II=c(12,0,8),ADDL=c(8,0,2),AMT=c(10,0,30))
  dfrm2 <- expand_addl_ii(dfrm)
  expect_equal(nrow(dfrm2[dfrm2$AMT==10,]),9)
  expect_equal(dfrm2$TIME[dfrm2$ID==1 & dfrm2$AMT==10],seq(0,96,12))
  expect_equal(nrow(dfrm2[dfrm2$ID==1 & dfrm2$AMT==0,]),1)
  expect_equal(nrow(dfrm2[dfrm2$ID==2,]),3)
  expect_equal(dfrm2$TIME[dfrm2$ID==2],c(0,8,16))
   
  dfrm  <- data.frame(ID=c(1,1,2), TIME=c(0,12,0),II=c(12,2,8),ADDL=c(8,2,2),AMT=c(10,0,30))
  dfrm2 <- expand_addl_ii(dfrm)
  expect_equal(dfrm2$TIME[dfrm2$ID==1 & dfrm2$AMT==10],seq(0,96,12))
  expect_equal(dfrm2$TIME[dfrm2$ID==1 & dfrm2$AMT==0],seq(12,16,2))
  expect_equal(dfrm2$TIME[dfrm2$ID==2],seq(0,16,8))

  dfrm3      <- dfrm
  dfrm3$EVID <- c(1,0,1)
  dfrm3$DV   <- c(0,4321,0)
  dfrm4      <- expand_addl_ii(dfrm3,evid="EVID")
  expect_equal(dfrm4$TIME[dfrm4$ID==1 & dfrm4$EVID==1],seq(0,96,12))
  expect_equal(dfrm4$DV[dfrm4$ID==1 & dfrm4$EVID==0],4321)
})

#-------------------------
# Test Fill_dates function
test_that("fill_dates fills down dates correctlywithin a data frame",{
  dfrm  <- data.frame(ID=1:2,first=as.Date(c("2018-03-01","2018-03-08")),
                      last=as.Date(c("2018-03-03","2018-03-14")))
  dfrm2 <- dfrm   
  dfrm2$first[2] <- NA
  
  expect_error(fill_dates(dat))
  expect_error(fill_dates(dfrm, "first", "ID"),"Date format")
  expect_error(fill_dates(dfrm2, "first", "last"),"Missing data")
  expect_error(fill_dates(dfrm2, "firsty", "lasty"),"Var.*not present")
  
  dfr2 <- fill_dates(dfrm,"first","last")
  expect_equal(nrow(dfr2[dfr2$ID==1,]),3)
  expect_equal(nrow(dfr2[dfr2$ID==2,]),7)
  expect_equal(nrow(dfr2[dfr2$ID==2,]),7)
  expect_equal(dfr2$dat[dfr2$ID==2],seq(as.Date("2018-03-08"),as.Date("2018-03-14"),1))
  
  dfr3 <- fill_dates(dfrm,"first","last",1,2)
  expect_equal(length(unique(dfr3$dat)),nrow(dfr3)/2)
  expect_equal(unique(dfr3$datnum),1:2)
  
  dfr4 <-fill_dates(dfrm,"first","last",1,4)
  expect_equal(length(unique(dfr4$dat)),nrow(dfr4)/4)
  expect_equal(unique(dfr4$datnum),1:4)
  
  dfr5 <- fill_dates(dfrm,"first","last",2,1)
  expect_equal(nrow(dfr5[dfr5$ID==1,]),2)
  expect_equal(dfr5$dat[dfr5$ID==2],seq(as.Date("2018-03-08"),as.Date("2018-03-14"),2))
  
  dfr6 <- fill_dates(dfrm,"first","last",5,2)
  expect_equal(nrow(dfr6[dfr6$ID==1,]),2)
  expect_equal(unique(dfr6$dat[dfr6$ID==1]),as.Date("2018-03-01"))
})

#--------------------------
# Test impute_dose function
test_that("impute_dose correctly creates additional dose records",{
  
  dfrm <- data.frame(ID=rep(1:3,each=3),
                     dt=as.POSIXct(c("2016-02-14 04:44:00","2016-02-15 19:47:00","2016-02-18 19:58:00" ,
                                     "2016-04-25 19:01:00","2016-05-01 08:55:00","2016-05-08 20:07:00",
                                     "2016-03-09 21:45:00","2016-03-12 17:11:00","2016-03-14 17:10:00")),
                     AMT=c(10,10,10,20,20,20,50,50,50),II=c(rep(24,3),rep(8,3),rep(12,3)))
  
  expect_error(impute_dose(dfrm))
  expect_error(impute_dose(dfrm, id="IDZ", "dt"))
  
  check <- impute_dose(dfrm,"ID","dt")
  expect_equal(check$ADDL[check$ID==1 & check$type=="additional"],c(0,1))
  expect_equal(as.character(check$dt[check$ID==1 & check$type=="additional"])[1],"2016-02-15 04:44:00")

  dfrm2  <- dfrm
  dfrm2$II[dfrm2$ID>1] <- 48
  check2 <- impute_dose(dfrm2,"ID","dt")
  expect_equal(as.Date(check2$dt[check2$ID==2][2]),as.Date("2016-04-27"))
  
  dfrm3  <- dfrm
  dfrm3$II[2:nrow(dfrm3)] <- 48
  expect_message(impute_dose(dfrm3, "ID", "dt"),"unequal")
})


#------------------------
# Test time_calc function
test_that("time_calc, create time variables correctly for usage in NONMEM analyses",{
  dfrm <- data.frame(ID=c(rep(1:3,each=5),3),
                     dt=as.POSIXct(c("2016-02-14 04:44:00","2016-02-15 19:47:00","2016-02-18 19:58:00","2016-10-19 19:10:00",
                                     "2016-12-27 18:50:00","2016-04-25 19:01:00","2016-06-05 08:55:00","2016-09-20 20:07:00",
                                     "2016-06-09 14:09:00","2016-10-24 21:43:00","2016-03-09 21:45:00","2016-06-27 17:11:00",
                                     "2016-08-01 03:30:00","2016-12-25 07:32:00","2016-12-25 08:09:00","2016-12-25 18:02:00")),
                     AMT=c(0,10,0,20,0,0,10,0,20,0,0,10,0,20,0,0),ADDL=c(NA,2,NA,68,NA,NA,1,NA,1,NA,NA,12,NA,29,NA,NA), 
                     II=c(rep(24,5),rep(48,5),rep(24,3),rep(12,3)))
  
  expect_error(time_calc(dfrm),"Variable `datetime`")
  expect_error(time_calc(dfrm, datetime = "dt", id = "Subj"),"Variable.*not present")
  expect_error(time_calc(dfrm[,names(dfrm)!="AMT"],datetime = dt, amt=NULL),"evid is not provided .* amt variable is present")
  
  check <- time_calc(dfrm,"dt",dig=4)
  expect_equal(as.numeric(difftime(check$dt[2],check$dt[1],units="hours")),check$TIME[2])
  expect_equal(as.numeric(difftime(check$dt[10],check$dt[6],units="hours")),check$TIME[10])
  expect_equal(round(as.numeric(difftime(check$dt[3],check$dt[2],units="hours")),4),check$TAFD[3])
  expect_equal(round(as.numeric(difftime(check$dt[3],check$dt[2],units="hours")),4),check$TAFD[3])
  expect_equal(round(as.numeric(difftime(check$dt[15],check$dt[12],units="hours")),4),check$TAFD[15])
  
  check <- time_calc(dfrm, "dt", addl = "ADDL", ii = "II", dig=4)
  reftm <- check$dt[4] + (check$ADDL[4] * check$II[4]*60*60)
  expect_equal(round(as.numeric(difftime(check$dt[5],reftm,units="hours")),4),check$TALD[5])
  expect_equal(round(as.numeric(difftime(check$dt[10],check$dt[7],units="hours")),4),check$TAFD[10])
  reftm <- check$dt[14] + (check$ADDL[14] * check$II[14]*60*60)
  expect_equal(round(as.numeric(difftime(check$dt[15],reftm,units="hours"))%%12,4),check$TALD[15])
  expect_equal(round(as.numeric(difftime(check$dt[15],check$dt[14],units="hours"))%%12,4),check$TALD[15])
  
  dfrm2      <- dfrm
  dfrm2$AMT  <- 10
  dfrm2$EVID <- ifelse(is.na(dfrm2$ADDL),0,1)
  check2     <- time_calc(dfrm2, "dt", addl="ADDL", ii="II", evid = "EVID", dig=4)
  expect_equal(check$TIME,check2$TIME)
  expect_equal(check$TALD,check2$TALD)
  expect_equal(check$TAFD,check2$TAFD)
})

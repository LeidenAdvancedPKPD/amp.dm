
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
  expect_error(create_addl(fin2, datetime=dt, id=ID, dose=DOS))
  expect_error(create_addl(fin2, datetime=dt, id=ID, dose=DOS, tau=tauue),"Var.*tau")
  
  res1  <- create_addl(fin, datetime=dt, id=ID, dose=DOS, tau=tau)
  res1b <- create_addl(fin, datetime=!!as.name("dt"), id=!!as.name("ID"), dose=!!as.name("DOS"), tau=!!as.name("tau"))
  res1c <- fin |> create_addl(dt, ID, DOS, tau)

  expect_equal(res1,res1b)
  expect_equal(res1,res1c)
  expect_equal(res1$ADDL[1],2)
  expect_equal(res1$ADDL[2],0)
  expect_equal(res1$ADDL[3],2)
  expect_equal(res1$ADDL[nrow(res1)],0)
  expect_equal(nrow(res1),8)
  
  dfrm <- data.frame(ID=c(1,1,2,2,2),dt=as.POSIXlt(c("2016-10-01 10:44:29","2016-10-01 16:44:29","2016-12-01 10:00:00","2016-12-02 8:00:00","2016-12-03 10:00:00"), "%Y-%m-%d %H:%M:%S",tz="GMT"),
                     dose=20,tau=c(6,12,24,24,24))
  res2 <- create_addl(dfrm, datetime=dt, id=ID, dose=dose, tau=tau)
  expect_equal(unique(res2$ADDL),0)
  
  res3 <- create_addl(fin2, datetime=dt, id=ID, dose=DOS, tau=tau, evid = EVID)
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
  dfrm4      <- expand_addl_ii(dfrm3,evid=EVID)
  expect_equal(dfrm4$TIME[dfrm4$ID==1 & dfrm4$EVID==1],seq(0,96,12))
  expect_equal(dfrm4$DV[dfrm4$ID==1 & dfrm4$EVID==0],4321)
})

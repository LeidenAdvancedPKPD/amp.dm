#----------------------------
# Test weight_height function
test_that("weight_height calculations are correct", {
  dfrm  <- data.frame(id=1:3,wt=round(runif(3,70,100),1),ht=round(runif(3,180,210),0),lb=round(runif(3,140,240),1),SEX=c(0,1,1))
  
  expect_error(weight_height(type="dummy"),"type.*not.*available")
  expect_error(weight_height(type="bsal"),"at least wt")
  expect_error(weight_height(ht=dfrm$wt,type="bmi"),"at.*least.*wt.*and ht")
  expect_error(weight_height(ht=dfrm$wt,type="ffmj"),"at.*least.*wt,.*bmi.*and.*sex")
  expect_error(weight_height(ht=dfrm$wt,type="lbmj"),"at.*least.*wt,.*ht.*and.*sex")
  
  
  WTLB <- weight_height(wt = dfrm$wt, type = "kg-lb")
  expect_equal(dfrm$wt*2.204622622,WTLB)
  WTKG <- weight_height(wt = dfrm$lb, type = "lb-kg")
  expect_equal(dfrm$lb/2.204622622,WTKG)
  
  BMI  <- weight_height(wt = dfrm$wt, ht = dfrm$ht, type = "bmi")
  expect_equal(dfrm$wt/((dfrm$ht/100)^2),BMI)
  
  BSA   <- weight_height(wt = dfrm$wt, ht=dfrm$ht, type = "bsa")
  expect_equal(exp(-3.751)*dfrm$wt^0.515*dfrm$ht^0.422,BSA)
  BSAM  <- weight_height(wt = dfrm$wt, ht=dfrm$ht, type = "bsam")
  expect_equal(sqrt(dfrm$wt*dfrm$ht/3600),BSAM)
  BSAH  <- weight_height(wt = dfrm$wt, ht=dfrm$ht, type = "bsah")
  expect_equal(0.024265*dfrm$ht**0.3964*dfrm$wt**0.5378,BSAH)
  BSA2  <- weight_height(wt = dfrm$wt, ht=dfrm$ht, type = "bsa2")
  expect_equal(0.007184*dfrm$ht**0.725*dfrm$wt**0.425,BSA2)
  BSAL  <- weight_height(wt = dfrm$wt, type="bsal")
  expect_equal(0.1173*dfrm$wt**0.6466,BSAL)
  
  FFMJ  <- weight_height(wt = dfrm$wt, bmi = BMI, sex = dfrm$SEX, type = "ffmj")
  sexf1 <- ifelse(dfrm$SEX==1, 8780 ,6680)
  sexf2 <- ifelse(dfrm$SEX==1, 244 ,216)
  expect_equal(9270*dfrm$wt/(sexf1+(sexf2*BMI)),FFMJ)
  FFMS  <- weight_height(wt = dfrm$wt, bmi = BMI, sex = dfrm$SEX, type = "ffms")
  sexf1 <- ifelse(dfrm$SEX==1, 8.78e3, 6.68e3)
  sexf2 <- ifelse(dfrm$SEX==1,  0.70, 0.77)
  expect_equal((9270*dfrm$wt)/(sexf1*sexf2*BMI**0.28),FFMS)
  
  LBMB  <- weight_height(wt = dfrm$wt, ht = dfrm$ht, sex = dfrm$SEX, type = "lbmb")
  sexf1 <- ifelse(dfrm$SEX==1, 0.252 ,0.407)
  sexf2 <- ifelse(dfrm$SEX==1, 0.473 ,0.267)
  sexf3 <- ifelse(dfrm$SEX==1, 48.3 ,19.2)
  expect_equal(sexf1*dfrm$wt+(sexf2*dfrm$ht)-sexf3,LBMB)
  LBMJ  <- weight_height(wt = dfrm$wt, ht = dfrm$ht, sex = dfrm$SEX, type = "lbmj")
  sexf1 <- ifelse(dfrm$SEX==1, 1.07, 1.1)
  sexf2 <- ifelse(dfrm$SEX==1, 148, 128)
  expect_equal((sexf1*dfrm$wt) - sexf2 * (dfrm$wt/dfrm$ht)^2,LBMJ)
  LBMP  <- weight_height(wt = dfrm$wt, ht = dfrm$ht, type = "lbmp")
  expect_equal(3.8*0.0215*dfrm$wt**0.6469*dfrm$ht**0.7236,LBMP)
  PNW   <- weight_height(wt = dfrm$wt, bmi = BMI, sex = dfrm$SEX, type = "pnw")
  sexf1 <- ifelse(dfrm$SEX==1, 1.75, 1.57)
  sexf2 <- ifelse(dfrm$SEX==1, 0.0242, 0.0183)
  sexf3 <- ifelse(dfrm$SEX==1, 12.6, 10.5)
  expect_equal((sexf1 * dfrm$wt) - (sexf2 * dfrm$wt * BMI) - sexf3,PNW)
  
})

test_that("egfr calculation is correct", {
  dfrm <- data.frame(ID = 1:5, SCR = round(runif(5,0.6,1.4),2), SEX = c(1,0,1,1,0),
                     AGE = round(runif(5,18,50),0), RACE = c(1,2,1,2,1), HT = round(runif(5,180,210),0),
                     BUN  = round(runif(5,6,24),2), scys = round(runif(5,0.6,1),2), PREM = c(0,0,0,1,1),
                     BSA = round(runif(5,1.5,2.2),2))
  
  
  expect_error(egfr(formula="dummy"),"Formula.*not.*available")
  expect_error(egfr(formula="CKD-EPI"),"at.*least.*sex,.*scr,.*race.*and.*age")
  expect_error(egfr(formula="CKD-EPI-ignore-race"),"at.*least.*sex,.*scr.*and.*age")
  expect_error(egfr(formula="CKD-EPI-Scys"),"at.*least.*sex,.*scys.*and.*age")
  expect_error(egfr(formula="CKD-EPI-Scr-Scys"),"at.*least.*sex,.*scys,.*age,.*race.*and")
  expect_error(egfr(formula="CKD-EPI-Scr-Scys-ignore-race"),"at.*least.*sex,.*scys,.*age")
  expect_error(egfr(formula="Schwartz-original"),"at.*least.*sex,.*prem,.*age,.*ht.*scr")
  expect_error(egfr(formula="Schwartz-CKiD"),"at.*least.*sex,.*scr,.*scys,.*bun.*and.*ht")
  expect_error(egfr(formula="Schwartz-1B"),"at.*least.*ht,.*scr,.*and.*bun")
  expect_error(egfr(formula="Schwartz"),"at.*least.*ht.*and.*scr")
  
  
  EPI <- egfr(dfrm$SCR[1], dfrm$SEX[1], dfrm$AGE[1], dfrm$RACE[1], formula = "CKD-EPI")
  manEPI <- 141 * min( dfrm$SCR[1] / ifelse(dfrm$SEX[1] == 1, 0.7, 0.9), 1)^ifelse(dfrm$SEX[1] == 1, -0.329, -0.411) * 
            max( dfrm$SCR[1] / ifelse(dfrm$SEX[1] == 1, 0.7, 0.9), 1)^(-1.209) * 0.993^dfrm$AGE[1] * 
            ifelse(dfrm$SEX[1] == 1, 1.018, 1) * ifelse(dfrm$RACE[1] == 2, 1.159, 1)
  expect_equal(EPI,manEPI)
  
  
  EPI2 <- egfr(dfrm$SCR[1], dfrm$SEX[1], dfrm$AGE[1], formula = "CKD-EPI-ignore-race")
  manEPI2 <- 142 * min( dfrm$SCR[1] / ifelse(dfrm$SEX[1] == 1, 0.7, 0.9), 1)^ifelse(dfrm$SEX[1] == 1, -0.241, -0.302) * 
    max( dfrm$SCR[1] / ifelse(dfrm$SEX[1] == 1, 0.7, 0.9), 1)^(-1.200) * 0.9938^dfrm$AGE[1] * 
    ifelse(dfrm$SEX[1] == 1, 1.012, 1)
  expect_equal(EPI2,manEPI2)
  
  EPISC <- egfr(scys = dfrm$scys[1], sex = dfrm$SEX[1], age = dfrm$AGE[1],  formula = "CKD-EPI-Scys")
  manEPISC <- 133 * pmin(dfrm$scys[1] / 0.8, 1)^(-0.499) * pmax(dfrm$scys[1] / 0.8, 1)^(-1.328) * 
              0.996^dfrm$AGE[1] * ifelse( dfrm$SEX[1] == 1,0.932, 1)
  expect_equal(EPISC,manEPISC)
  
  EPISSC <- egfr(scr = dfrm$SCR[1], scys = dfrm$scys[1], sex = dfrm$SEX[1], race = dfrm$RACE[1], age = dfrm$AGE[1],  formula = "CKD-EPI-Scr-Scys")
  manEPISSC <- 135 * pmin(dfrm$SCR[1] / ifelse(dfrm$SEX[1] == 1, 0.7, 0.9), 1)^ifelse(dfrm$SEX[1] == 1, -0.248, -0.207) * 
               pmax(dfrm$SCR[1] / ifelse(dfrm$SEX[1] == 1, 0.7, 0.9), 1)^(-0.601) * 
               pmin(dfrm$scys[1] / 0.8, 1)^(-0.375) * pmax(dfrm$scys[1] / 0.8, 1)^(-0.711) * 0.995^dfrm$AGE[1]  * 
               ifelse(dfrm$SEX[1] == 1, 0.969, 1) * ifelse(dfrm$RACE[1] == 2, 1.08, 1)
  expect_equal(EPISC,manEPISC)
  
  EPISSC2 <- egfr(scr = dfrm$SCR[1], scys = dfrm$scys[1], sex = dfrm$SEX[1], age = dfrm$AGE[1],  formula = "CKD-EPI-Scr-Scys-ignore-race")
  manEPISSC2 <- 135 * pmin(dfrm$SCR[1] / ifelse(dfrm$SEX[1] == 1, 0.7, 0.9), 1)^ifelse(dfrm$SEX[1] == 1, -0.219, -0.144) * 
    pmax(dfrm$SCR[1] / ifelse(dfrm$SEX[1] == 1, 0.7, 0.9), 1)^(-0.544) * 
    pmin(dfrm$scys[1] / 0.8, 1)^(-0.323) * pmax(dfrm$scys[1] / 0.8, 1)^(-0.778) * 0.9961^dfrm$AGE[1]  * 
    ifelse(dfrm$SEX[1] == 1, 0.963, 1) 
  expect_equal(EPISSC2,manEPISSC2)
  
  EPIJP <- egfr(scr = dfrm$SCR[1], sex = dfrm$SEX[1], race = dfrm$RACE[1], age = dfrm$AGE[1],  formula = "CKD-EPI-Japan")
  manEPIJP <- 141 * pmin(dfrm$SCR[1] / ifelse(dfrm$SEX[1] == 1, 0.7, 0.9), 1)^ifelse(dfrm$SEX[1] == 1, -0.329, -0.411) * 
    pmax(dfrm$SCR[1] / ifelse(dfrm$SEX[1] == 1, 0.7, 0.9), 1)^(-1.209) * 0.993^dfrm$AGE[1] * ifelse(dfrm$SEX[1] == 1, 1.018, 1) * 
    ifelse(dfrm$RACE[1] == 2, 1.159, ifelse(dfrm$RACE[1] > 2,0.813, 1))
  expect_equal(EPIJP,manEPIJP)
  
  MDRD    <- egfr(dfrm$SCR, dfrm$SEX, dfrm$AGE, dfrm$RACE, formula = "CKD-MDRD")
  manMDRD <- 186 * dfrm$SCR**-1.154 * dfrm$AGE**-0.203 * ifelse(dfrm$SEX == 1, 0.742, 1) * ifelse(dfrm$RACE == 2, 1.212, 1)
  expect_equal(MDRD,manMDRD)
  
  MDRD2    <- egfr(dfrm$SCR, dfrm$SEX, dfrm$AGE, dfrm$RACE, formula = "CKD-MDRD2")
  manMDRD2 <- 175 * dfrm$SCR**(-1.154) * dfrm$AGE**(-0.203) * ifelse(dfrm$SEX == 1, 0.742, 1) * ifelse(dfrm$RACE == 2, 1.212, 1)
  expect_equal(MDRD2,manMDRD2)
  
  SchwartzO    <- egfr(dfrm$SCR, ht = dfrm$HT, prem = dfrm$PREM, sex = dfrm$SEX, age=dfrm$AGE, formula = "Schwartz-original")
  fact         <- ifelse(dfrm$AGE<1 & dfrm$PREM == 1, 0.33, # premature baby
                         ifelse(dfrm$AGE < 1  & dfrm$PREM == 0, 0.45, # normal baby
                                ifelse((dfrm$AGE>= 1  & dfrm$AGE <= 13) | (dfrm$AGE> 13 & dfrm$AGE< 18 & dfrm$SEX==1),0.55,
                                       ifelse(dfrm$AGE> 13 & dfrm$AGE<18 & dfrm$SEX!=1,0.7,NA))))
  ManSchwartzO <- fact *  (dfrm$HT/dfrm$SCR)
  expect_equal(SchwartzO,ManSchwartzO)
  
  Schwartzc    <- egfr(dfrm$SCR, sex = dfrm$SEX, ht = dfrm$HT, scys = dfrm$scys, bun = dfrm$BUN, formula = "Schwartz-CKiD")
  ManSchwartzc <- 39.8 * (( dfrm$HT/100)/(dfrm$SCR))**(0.456) * (1.8/(dfrm$scys))**(0.418) * (30/(dfrm$BUN))**(0.079) * 
                  ((dfrm$HT/100)/1.4)**(0.179) * ifelse(dfrm$SEX  == 1, 1, 1.076)
  expect_equal(Schwartzc,ManSchwartzc)
  
  Schwartzb    <- egfr(dfrm$SCR, ht = dfrm$HT, bun = dfrm$BUN, formula = "Schwartz-1B")
  ManSchwartzb <- 40.7 * (( dfrm$HT/100)/(dfrm$SCR))**(0.64) * (30/(dfrm$BUN))**(0.202)
  expect_equal(Schwartzb,ManSchwartzb)
  
  Schwartz    <- egfr(dfrm$SCR, ht = dfrm$HT, formula = "Schwartz")
  ManSchwartz <- 0.413 *  (dfrm$HT/dfrm$SCR)
  expect_equal(Schwartz,ManSchwartz)
  
  MAYO    <- egfr(dfrm$SCR, dfrm$SEX, dfrm$AGE, formula = "Mayo-Quadratic")
  manMAYO <- exp(1.911+5.249/dfrm$SCR-2.114/dfrm$SCR**2-0.00686*dfrm$AGE-ifelse(dfrm$SEX==1, 0.205,0))
  expect_equal(MAYO,manMAYO)
  
  MATSU    <- egfr(dfrm$SCR, age = dfrm$AGE, sex =  dfrm$SEX, formula = "Matsuo-Japan")
  manMATSU <- ifelse(dfrm$SEX  == 1, 1, 0.739) * 194 * dfrm$SCR**(-1.094) * dfrm$AGE ** (-0.287)
  expect_equal(MATSU,manMATSU)
  
  BSAcor  <- egfr(dfrm$SCR, dfrm$SEX, dfrm$AGE, dfrm$RACE, bsa = dfrm$BSA, formula = "CKD-MDRD")
  BSAcorm <- egfr(dfrm$SCR, dfrm$SEX, dfrm$AGE, dfrm$RACE, formula = "CKD-MDRD")
  BSAcorm <- (BSAcorm*dfrm$BSA)/1.73  
  expect_equal(BSAcor,BSAcor)

})


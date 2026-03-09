#------------------------------------------ egfr ------------------------------------------
#' Calculates EGFR values based on different types of formulas
#'
#' This function calculates Estimated Glomerular Filtration Rate (EGFR) values based on most commonly used formulas 
#'
#' @param scr vector with Serum creatinine values in mg/dL
#' @param sex vector with SEX values (where female is defined as a value of 1)
#' @param age vector with AGE values in years
#' @param race vector with RACE values (where caucasian is defined as 1, black as  and Japanese as > 2)
#' @param ht vector with HEIGHT values in cm
#' @param bun vector with Blood urea nitrogen in mg/dL
#' @param scys vector with Serum cystatin C in mg/L
#' @param prem vector with PREM (premature) values (where PREM is defined as value of 1)
#' @param bsa vector with BSA values in m2 provide in case correction should be applied (see details)
#' @param formula character with the formula to be used for the EGFR calculations (see details)
#' @details Currently there are  different formulas available for calculations:
#'
#'  - "CKD-EPI": EGFR according to the Chronic Kidney Disease Epidemiology (CKD-EPI) study formula ([Levey](https://pmc.ncbi.nlm.nih.gov/articles/PMC2763564/)):
#'    \deqn{ \textrm{eGFR} = 141 \cdot \min\left(\frac{\textrm{Scr}}{\kappa},1\right)^{\alpha} \cdot \max\left(\frac{\textrm{Scr}}{\kappa},1\right)^{-1.209} \cdot 0.993^{\textrm{Age}} \cdot 1.159 \textrm{ [if black]} \cdot 1.018 \textrm{ [if female]}}
#'    where \eqn{\min\left(\right)} indicates the minimum of \eqn{\frac{\textrm{Scr}}{\kappa}} or 1; \eqn{\max\left(\right)} indicates the maximum of \eqn{\frac{\textrm{Scr}}{\kappa}}or 1.
#'    scaling parameter \eqn{\kappa} is 0.9 for males and 0.7 for females and scaling parameter \eqn{\alpha} is -0.411 for males and -0.329 for females.
#'
#'  - "CKD-EPI-ignore-race": EGFR according to the Chronic Kidney Disease Epidemiology (CKD-EPI) refit without race study formula ([Delgado](https://pubmed.ncbi.nlm.nih.gov/34563581/)):
#'    \deqn{ \textrm{eGFR} = 142 \cdot \min\left(\frac{\textrm{Scr}}{\kappa},1\right)^{\alpha} \cdot
#'                                     \max\left(\frac{\textrm{Scr}}{\kappa},1\right)^{-1.200} \cdot
#'                                      0.9938^{\textrm{Age}}  \cdot 1.012 \textrm{ [if female]}
#'        }
#'    where \eqn{\min\left(\right)} indicates the minimum of \eqn{\frac{\textrm{Scr}}{\kappa}} or 1; \eqn{\max\left(\right)} indicates the maximum of \eqn{\frac{\textrm{Scr}}{\kappa}}or 1.
#'    scaling parameter \eqn{\kappa} is 0.9 for males and 0.7 for females and scaling parameter \eqn{\alpha} is -0.302 for males and -0.241 for females.
#'
#'  - "CKD-EPI-Scys", EGFR according to the Chronic Kidney Disease Epidemiology study formula ([Inker](https://pubmed.ncbi.nlm.nih.gov/22762315/)):
#'    \deqn{ \textrm{eGFR} = 133 \cdot \min\left(\frac{\textrm{Scys}}{0.8},1\right)^{-0.499} \cdot \max\left(\frac{\textrm{Scys}}{0.8},1\right)^{-1.328} \cdot 0.996^{\textrm{Age}}  \cdot 0.932 \textrm{ [if female]}}
#'    where \eqn{\min\left(\right)} indicates the minimum of \eqn{\frac{\textrm{Scys}}{0.8}} or 1; \eqn{\max\left(\right)} indicates the maximum of \eqn{\frac{\textrm{Scys}}{0.8}} or 1.
#'
#'  - "CKD-EPI-Scr-Scys", EGFR according to the Chronic Kidney Disease Epidemiology study formula ([Inker](https://pubmed.ncbi.nlm.nih.gov/22762315/)):
#'    \deqn{ \textrm{eGFR} = k \cdot l \cdot 135 \cdot \min\left(\frac{\textrm{Scr}}{\kappa},1\right)^{\alpha} \cdot \max\left(\frac{\textrm{Scr}}{\kappa},1\right)^{-0.601} \cdot\min\left(\frac{\textrm{Scys}}{0.8},1\right)^{-0.375} \cdot \max\left(\frac{\textrm{Scys}}{0.8},1\right)^{-0.711} \cdot 0.995^{\textrm{Age}} }
#'    where \eqn{\min\left(\right)} indicates the minimum of \eqn{\frac{\textrm{Scys}}{0.8}} or 1; \eqn{\max\left(\right)} indicates the maximum of \eqn{\frac{\textrm{Scys}}{0.8}} or 1,
#'    and where \eqn{\min\left(\right)} indicates the minimum of \eqn{\frac{\textrm{Scr}}{\kappa}} or 1; \eqn{\max\left(\right)} indicates the maximum of \eqn{\frac{\textrm{Scr}}{\kappa}}or 1.
#'    Scaling parameter k is 1 for males and 0.969 for female, scaling parameter l is 1 if White/Caucasian and 1.08 if Black/African American,
#'    scaling parameter \eqn{\kappa} is 0.9 for males and 0.7 for females and scaling parameter \eqn{\alpha} is -0.207 for males and -0.248 for females.
#'
#' -  "CKD-EPI-Scr-Scys-ignore-race", EGFR according to the Chronic Kidney Disease Epidemiology 2021 refit without race study formula ([Delgado](https://pubmed.ncbi.nlm.nih.gov/34563581/)):
#'    \deqn{ \textrm{eGFR} = k \cdot 135 \cdot \min\left(\frac{\textrm{Scr}}{\kappa},1\right)^{\alpha} \cdot \max\left(\frac{\textrm{Scr}}{\kappa},1\right)^{-0.544} \cdot\min\left(\frac{\textrm{Scys}}{0.8},1\right)^{-0.323} \cdot \max\left(\frac{\textrm{Scys}}{0.8},1\right)^{-0.778} \cdot 0.9961^{\textrm{Age}} }
#'    where \eqn{\min\left(\right)} indicates the minimum of \eqn{\frac{\textrm{Scys}}{0.8}} or 1; \eqn{\max\left(\right)} indicates the maximum of \eqn{\frac{\textrm{Scys}}{0.8}} or 1,
#'    and where \eqn{\min\left(\right)} indicates the minimum of \eqn{\frac{\textrm{Scr}}{\kappa}} or 1; \eqn{\max\left(\right)} indicates the maximum of \eqn{\frac{\textrm{Scr}}{\kappa}}or 1.
#'    Scaling parameter k is 1 for males and 0.963 for female, scaling parameter \eqn{\kappa} is 0.9 for males and 0.7 for females and
#'    scaling parameter \eqn{\alpha} is -0.144 for males and -0.219 for females.
#'
#'  - "CKD-EPI-Japan", EGFR in Japanese adults based on a Japanese coefficient-modified CKD-EPI equation ([Horio](https://pubmed.ncbi.nlm.nih.gov/20416999/)):
#'    \deqn{\textrm{eGFR} =  l \cdot 141 \cdot \min\left(\frac{\textrm{Scr}}{\kappa},1\right)^{\alpha} \cdot \max\left(\frac{\textrm{Scr}}{\kappa},1\right)^{-1.209} \cdot 0.993^{\textrm{Age}} \cdot 1.018 \textrm{ [if female]}}
#'    where \eqn{\min\left(\right)} indicates the minimum of \eqn{\frac{\textrm{Scr}}{\kappa}} or 1; \eqn{\max\left(\right)} indicates the maximum of \eqn{\frac{\textrm{Scr}}{\kappa}}or 1.
#'    Scaling parameter l is 1 for White/Caucasian, 1.159 for Black/African American, 0.813 for Japanese, scaling parameter \eqn{\kappa} is 0.9 for males and 0.7 for females and
#'    scaling parameter \eqn{\alpha} is -0.411 for males and -0.329 for females.
#'
#'  - "CKD-MDRD", EGFR according to the abbreviated Modification of Diet in Renal Disease study formula ([Levey](https://hero.epa.gov/hero/index.cfm/reference/details/reference_id/658418)):
#'    \deqn{\textrm{eGFR}=  186 \cdot \textrm{Scr}^{-1.154} \cdot \textrm{Age}^{-0.203} \cdot 1.212 \textrm{ [if black]} \cdot 0.742 \textrm{ [if female]}}
#'
#'  - "CKD-MDRD2", EGFR according to the re-expressed Modification of Diet in Renal Disease (MDRD) study formula ([Levey2007](https://pubmed.ncbi.nlm.nih.gov/17332152/)):
#'    \deqn{\textrm{eGFR} =   175 \cdot \textrm{Scr}^{-1.154} \cdot \textrm{Age}^{-0.203} \cdot 1.212 \textrm{ [if black]} \cdot 0.742 \textrm{ [if female]}}
#'
#'  - "Schwartz-original", EGFR in children, according to the original Schwartz formula ([Schwartz1987](https://pubmed.ncbi.nlm.nih.gov/3588043/)):
#'    \deqn{\textrm{eGFR} = k \cdot \frac{\textrm{Height}}{\textrm{Scr}}}
#'    where k = 0.33 in pre-term infants up to 1 year, k = 0.45 in full-term infants up to 1 year, k = 0.55 in children 1 year to 13 years,
#'    k = 0.55 in girls >13 and <18 years and k = 0.70 in boys >13 and <18 years.
#'
#'  - "Schwartz-CKiD", EGFR in children, according to the Chronic Kidney Disease in Children (CKiD) revised Schwartz formula ([Schwartz2012](https://pubmed.ncbi.nlm.nih.gov/22622496/)):
#'    \deqn{\textrm{eGFR}  = 39.8 \cdot \left(\frac{\textrm{Height}}{\textrm{Scr}}\right)^{0.456}  \cdot \left(\frac{1.8}{\textrm{Scys}}\right)^{0.418}  \cdot \left(\frac{30}{\textrm{BUN}}\right)^{0.079} \cdot \left(\frac{\textrm{Height}}{1.4}\right)^{0.079}   }
#'    Scaling parameter k is 1 for males and 1.076 for females.
#'
#'  - "Schwartz-1B", EGFR in children, according to the Chronic Kidney Disease in Children (CKiD) 1B Schwartz formula ([Schwartz2009](https://pmc.ncbi.nlm.nih.gov/articles/PMC2653687/)):
#'    \deqn{\textrm{eGFR}  = 40.7 \cdot \left(\frac{\textrm{Height}}{\textrm{Scr}}\right)^{0.64}   \cdot \left(\frac{30}{\textrm{BUN}}\right)^{0.202}  }
#'
#'  - "Schwartz", EGFR in children, according to the updated ('bedside') Schwartz formula ([Schwartz2009](https://pmc.ncbi.nlm.nih.gov/articles/PMC2653687/)):
#'    \deqn{\textrm{eGFR} = 0.413 \cdot \frac{\textrm{Height}}{\textrm{Scr}}}
#'    This equation is not meant for patients < 1 years of age.
#'
#'  - "Mayo-Quadratic", EGFR according to the Quadratic Mayo Clinic formula ([Rule](https://pubmed.ncbi.nlm.nih.gov/15611490/)).
#'    \deqn{\textrm{eGFR} = \exp\left(1.911 + \frac{5.249}{\textrm{Scr}} - \frac{2.114}{\textrm{Scr}^2} - 0.00686 \cdot \textrm{Age} - 0.205\textrm{ [if female]}\right)}
#'    If Scr < 0.8 mg/dL, a value of 0.8 is used in the equation.
#'
#'  - "Matsuo-Japan", EGFR in Japanese adults, according to [Matsuo](https://pubmed.ncbi.nlm.nih.gov/19339088/):
#'    \deqn{\textrm{eGFR} =  194 \cdot \textrm{Scr}^{-1.094} \cdot \textrm{Age}^{-0.287} \cdot 0.739 \textrm{ [if female]}}
#'
#'  For all of the calculation methods described above, the reported EGFR values are in the units "mL/minute/1.73m2". This means that the value is 
#'  referenced to a body surface area (BSA) value of 1.73m2. When a value is provided for BSA, the final outcome will be corrected for the BSA value
#'  and the units become "mL/minute". This is done by multiplying the eGFR (referenced to a BSA of 1.73m2) with the individual's
#'  BSA (it is the users responsibility to proved BSA values that are calculated using the appropriate formula) and divided by 1.73. 
#'  Additional information regarding this can be found in a [FDA guidance document](https://www.fda.gov/media/78573/download).
#'
#' @keywords misc
#' @export
#' @return a vector with EGFR values
#' @author Richard Hooijmaijers
#' @examples
#'
#' # dataset with dummy numbers!
#' crea <- data.frame(id=c(1,1,2),Scr=runif(3),SEX=c(1,1,0),AGE=runif(3),RACE=c(1,1,2))
#' egfr(crea$Scr,crea$SEX,crea$AGE,crea$RACE, formula="CKD-EPI")
#' # example for use in dplyr
#' crea |> dplyr::mutate(EGFR = egfr(Scr,SEX, AGE, RACE, formula="CKD-EPI"))
egfr <- function(scr=NULL, sex=NULL, age=NULL, race=NULL, ht=NULL, bun=NULL, scys=NULL, prem = NULL, bsa = NULL, formula="CKD-EPI") {
  # Perform Checks 
  avl_types <- c("CKD-EPI","CKD-EPI-ignore-race", "CKD-EPI-Scys", "CKD-EPI-Scr-Scys","CKD-EPI-Scr-Scys-ignore-race", "CKD-EPI-Japan",
                 "CKD-MDRD", "CKD-MDRD2", "Schwartz-original", "Schwartz-CKiD", "Schwartz-1B", "Schwartz",
                 "Mayo-Quadratic", "Matsuo-Japan")
  
  
  if(!(formula %in% avl_types)) cli::cli_abort("Formula not available, available options are: {.var {avl_types}}")
  if((is.null(sex) || is.null(scr) || is.null(race) || is.null(age)) && formula%in%avl_types[c(1,6,7,8)]){
    cli::cli_abort("For formula {.var {formula}} at least sex, scr, race and age should be provided")  
  }else if((is.null(sex) || is.null(scr) || is.null(age)) && formula%in%avl_types[c(2,13,14)]){
    cli::cli_abort("For formula {.var {formula}} at least sex, scr and age should be provided")  
  }else if((is.null(sex) || is.null(scys) || is.null(age)) && formula%in%avl_types[3]){
    cli::cli_abort("For formula {.var {formula}} at least sex, scys and age should be provided")  
  }else if((is.null(sex) || is.null(scys) || is.null(age) || is.null(race) || is.null(scr)) && formula%in%avl_types[4]){
    cli::cli_abort("For formula {.var {formula}} at least sex, scys, age, race and scr should be provided")  
  }else if((is.null(sex) || is.null(scys) || is.null(age) || is.null(scr)) && formula%in%avl_types[5]){
    cli::cli_abort("For formula {.var {formula}} at least sex, scys, age and scr should be provided")  
  }else if((is.null(sex) || is.null(prem) || is.null(age) || is.null(ht) || is.null(scr)) && formula%in%avl_types[9]){
    cli::cli_abort("For formula {.var {formula}} at least sex, prem, age, ht and scr should be provided")  
  }else if((is.null(sex) || is.null(scr) || is.null(scys) || is.null(bun) || is.null(ht)) && formula%in%avl_types[10]){
    cli::cli_abort("For formula {.var {formula}} at least sex, scr, scys, bun and ht should be provided")  
  }else if((is.null(ht) || is.null(scr) || is.null(bun)) && formula%in%avl_types[11]){
    cli::cli_abort("For formula {.var {formula}} at least ht, scr, and bun should be provided")  
  }else if((is.null(ht) || is.null(scr)) && formula%in%avl_types[12]){
    cli::cli_abort("For formula {.var {formula}} at least ht and scr should be provided")  
  }
  
  
  if(formula=="CKD-EPI"){
    k   <- ifelse(sex == 1, 0.7, 0.9)
    a   <- ifelse(sex == 1, -0.329, -0.411)
    sf  <- ifelse(sex == 1, 1.018, 1)
    rf  <- ifelse(race == 2, 1.159, 1)
    res <- 141 * pmin(scr / k, 1)^a * pmax(scr / k, 1)^(-1.209) * 0.993^age * sf * rf
  }else if(formula=="CKD-EPI-ignore-race"){
    k   <- ifelse(sex == 1, 0.7, 0.9)
    a   <- ifelse(sex == 1, -0.241, -0.302)
    sf  <- ifelse(sex == 1, 1.012, 1)
    res <- 142 * pmin(scr / k, 1)^a * pmax(scr / k, 1)^(-1.200) * 0.9938^age * sf
  }else if(formula=="CKD-EPI-Scys"){
    sf  <- ifelse(sex == 1,0.932, 1)
    res <- 133 * pmin(scys / 0.8, 1)^(-0.499) * pmax(scys / 0.8, 1)^(-1.328) * 0.996^age * sf
  }else if(formula=="CKD-EPI-Scr-Scys"){
    k  <- ifelse(sex == 1, 0.7, 0.9)
    a  <- ifelse(sex == 1, -0.248, -0.207)
    sf <- ifelse(sex == 1, 0.969, 1)
    rf <- ifelse(race == 2, 1.08, 1)
    res <- 135 * pmin(scr / k, 1)^a * pmax(scr / k, 1)^(-0.601) * pmin(scys / 0.8, 1)^(-0.375) * pmax(scys / 0.8, 1)^(-0.711) * 0.995^age * sf * rf
  }else if(formula=="CKD-EPI-Scr-Scys-ignore-race"){
    k  <- ifelse(sex == 1, 0.7, 0.9)
    a  <- ifelse(sex == 1, -0.219, -0.144)
    sf <- ifelse(sex == 1, 0.963, 1)
    res <- 135 * pmin(scr / k, 1)^a * pmax(scr / k, 1)^(-0.544) * pmin(scys / 0.8, 1)^(-0.323) * pmax(scys / 0.8, 1)^(-0.778) * 0.9961^age * sf
  }else if(formula=="CKD-EPI-Japan"){
    k   <- ifelse(sex == 1, 0.7, 0.9)
    a   <- ifelse(sex == 1, -0.329, -0.411)
    sf  <- ifelse(sex == 1, 1.018, 1)
    # Define race category >2   for japanese in help file
    rf  <- ifelse(race == 2, 1.159, ifelse(race > 2,0.813, 1))
    res <- 141 * pmin(scr / k, 1)^a * pmax(scr / k, 1)^(-1.209) * 0.993^age * sf * rf
  }else if(formula=="CKD-MDRD"){
    sf  <- ifelse(sex== 1, 0.742, 1)
    rf  <- ifelse(race == 2, 1.212, 1)
    res <- 186 * scr**(-1.154) * age**(-0.203) * sf * rf
  }else if(formula=="CKD-MDRD2"){
    sf  <- ifelse(sex == 1, 0.742, 1)
    rf  <- ifelse(race == 2, 1.212, 1)
    res <- 175 * scr**(-1.154) * age**(-0.203) * sf * rf
  }else if(formula=="Schwartz-original"){
    af  <- ifelse(age < 1 & prem == 1, 0.33, # premature baby
                  ifelse(age < 1  & prem == 0, 0.45, # normal baby
                         ifelse((age >= 1  & age <= 13) | (age > 13 & age < 18 & sex==1), 0.55,
                                ifelse(age > 13 & age < 18 & sex!=1, 0.7,NA))))
    res <- af * ht / scr
  }else if(formula=="Schwartz-CKiD"){
    sf  <- ifelse(sex  == 1, 1, 1.076)
    res <- 39.8 * (( ht/100)/(scr))**(0.456) * (1.8/(scys))**(0.418) * (30/(bun))**(0.079) * ((ht/100)/1.4)**(0.179) * sf
  }else if(formula=="Schwartz-1B"){
    res <- 40.7 * (( ht/100)/(scr))**(0.64) * (30/(bun))**(0.202)
  }else if(formula=="Schwartz"){
    res <- 0.413 * ht / scr
  }else if(formula=="Mayo-Quadratic"){
    sf  <- ifelse(sex == 1, 0.205, 0)
    res <- exp(1.911 + 5.249/scr - 2.114/scr**2 - 0.00686 * age - sf)
  }else if(formula == "Matsuo-Japan"){
    k   <- ifelse(sex  == 1, 1, 0.739)
    res <- k * 194 * scr**(-1.094) * age ** (-0.287)
  }
  # Perform correction of BSA when provided
  if(!is.null(bsa))   res <- (res * bsa) / 1.73
  
  return(res)
}  

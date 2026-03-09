#------------------------------------------ weight_height ------------------------------------------
#' Calculates different weight variables
#'
#' This function calculates different variables based on weight and height and
#' conversion from or to kilograms
#'
#' @param wt vector with weight values, in either kg or lb depending on the type (see details)
#' @param ht vector with height values in cm (see details)
#' @param sex vector with SEX values (Where female is defined as a value of 1)
#' @param bmi vector with BMI values (see details)
#' @param type character with the type to be used for the calculations (see details)
#' @details Currently the following types are defined within the function:
#'
#'  ##  Convert units
#'
#'   - "kg-lb" : Convert units from kg to lb using the formula \deqn{\textrm{Weight (kg)} = \textrm{Weight (lb)} \cdot 2.20462262}
#'   - "lb-kg" : Convert units from lb to kg using the formula \deqn{\textrm{Weight (lb)} = \frac{\textrm{Weight (kg)}}{2.20462262}}
#'
#'  ## Body mass index
#'
#'   - "bmi" :  Calculates body mass index (BMI) using the standard formula ([Quetelet1842](https://www.cambridge.org/core/books/treatise-on-man-and-the-development-of-his-faculties/AB13A647A6C8727C06AE5399D7422887),
#'     \deqn{\textrm{BMI} = \frac{\textrm{Weight (kg)}}{\textrm{Height (m)}^{2}}}
#'
#' ##  Body Surface Area
#'
#'   - "bsa": Body Surface Area, according to [Gehan and Georg](https://www.researchgate.net/publication/17656913_Estimation_of_Human_Body_Surface_Area_from_Height_and_Weight),  
#'     \deqn{\textrm{BSA} = \exp{-3.751} \cdot \textrm{Height (cm)}^{0.422} \cdot \textrm{Weight (kg)}^{0.515}}
#'   - "bsa2": Body Surface Area, according to [DuBois and DuBois](https://pubmed.ncbi.nlm.nih.gov/2520314/),  
#'     \deqn{\textrm{BSA} = 0.007184 \cdot \textrm{Height (cm)}^{0.725} \cdot \textrm{Weight (kg)}^{0.425}}
#'   - "bsam": Body Surface Area, according to [Mosteller](https://pubmed.ncbi.nlm.nih.gov/3657876/),  
#'     \deqn{\textrm{BSA} = \sqrt{\frac{\textrm{Weight (kg)} \cdot \textrm{Height (cm)}}{3600}}}
#'   - "bsah": Body Surface Area, according to [Haycock](https://pubmed.ncbi.nlm.nih.gov/650346/),  
#'     \deqn{\textrm{BSA} = 0.024265 \cdot \textrm{Height (cm)}^{0.3964} \cdot \textrm{Weight (kg)}^{0.5378}}
#'   - "bsal": Body Surface Area in normal-weight and obese adults up to 250 kg, according to [Livingston](https://pubmed.ncbi.nlm.nih.gov/11500314/),  
#'     \deqn{\textrm{BSA} = 0.1173 \cdot \textrm{Weight (kg)}^{0.6466}}
#'
#' ##  Fat free mass
#'
#'  - "ffmj": Fat free mass, according to [Janmahasatian](https://pubmed.ncbi.nlm.nih.gov/16176118/): 
#'    \deqn{\textrm{FFM}=\frac{9270 \cdot \textrm{Weight (kg)}}{k +\left(l \cdot  \textrm{BMI}\right)}}, where \eqn{k} is 6680 for males and 8780 for females and \eqn{l} is 216 for males and 244 for females.
#'  - "ffms": Fat free mass in Indian patients, according to [Sinha](https://pubmed.ncbi.nlm.nih.gov/32201910/): 
#'    \deqn{\textrm{FFM}=\frac{9270 \cdot \textrm{Weight (kg)}}{k \cdot  l \cdot \textrm{BMI}^{0.28}}}, where \eqn{k} is 6680 for males and 8780 for females and \eqn{l} is 0.77 for males and 0.70 for females.
#'
#' ## Lean body mass
#'
#'   - "lbmb" : Calculates lean body mass (LBM), according to [Boers](https://pubmed.ncbi.nlm.nih.gov/6496691/): 
#'      \deqn{\textrm{LBM} = k \cdot \textrm{Weight (kg)} + l \cdot \textrm{Height (cm)} - m } , where \eqn{k} is 0.407 for males and 0.252 for females, and \eqn{l} is 0.267 for males and 0.473 for females, and \eqn{m} is 19.2 for males and 48.3 for females.
#'   - "lbmj" : Calculates lean body mass (LBM), according to [James](https://onlinelibrary.wiley.com/doi/10.1111/j.1467-3010.1977.tb00966.x): 
#'      \deqn{\textrm{LBM} = k \cdot \textrm{Weight (kg)} - l \cdot \left(\frac{\textrm{Weight (kg)}}{\textrm{Height (cm)}}\right)^2}, where \eqn{k} is 1.10 for males and 1.07 for females,  and  \eqn{l} is 128 in males and 148 in females.
#'   - "lbmp" : Calculates lean body mass (LBM) for children up to 14 years, according to [Peters](https://pubmed.ncbi.nlm.nih.gov/21498495/): 
#'      \deqn{\textrm{LBM} = 3.8 \cdot 0.0215 \cdot \textrm{Weight (kg)}^{0.6469} \cdot \textrm{Height (cm)}^{0.7236}}
#'
#'  ##  Predicted Normal Weight
#'   - "pnw" : Calculates the Predicted Normal Weight for obese patient, according to [Duffull](https://pubmed.ncbi.nlm.nih.gov/15568893/): 
#'     \deqn{\textrm{PNWT} = k \cdot  \textrm{Weight (kg)} - l \cdot \textrm{Height (cm)} \cdot \textrm{BMI} - m}, where \eqn{k} is 1.57 for males and 1.75 for females, and \eqn{l} is 0.0183 for males and 0.0242 for females, and \eqn{m} is 10.5 for males and 12.6 for females.
#'
#' @keywords misc
#' @export
#' @return a vector with calculated values
#' @author Richard Hooijmaijers
#' @examples
#'
#' tmp <- data.frame(id=1,WT=runif(3,70,120),HT=runif(3,160,220))
#' weight_height(wt=tmp$WT,ht=tmp$HT,type="bmi")
#' # example for use in dplyr
#' tmp |> dplyr::mutate(BMI = weight_height(wt=WT,ht=HT,type="bmi"))
weight_height <- function(wt=NULL,ht=NULL,sex=NULL,bmi=NULL,type="bmi"){
  # Perform Checks 
  avl_types <- c("kg-lb", "lb-kg", "bmi", "bsa", "bsa2", "bsam", "bsah", "bsal", "ffmj", "ffms", "lbmb", "lbmj", "lbmp", "pnw")
  if(!(type %in% avl_types)) cli::cli_abort("Calculation type not available, available options are: {.var {avl_types}}")
  if(is.null(wt) && type%in%avl_types[c(1:2,8)]){
    cli::cli_abort("For calculation type {.var {type}} at least wt should be provided")  
  }else if((is.null(wt) || is.null(ht)) && type%in%avl_types[c(3:7,13)]){
    cli::cli_abort("For calculation type {.var {type}} at least wt and ht should be provided")  
  }else if((is.null(wt) || is.null(bmi) || is.null(sex)) && type%in%avl_types[c(9:10,14)]){
    cli::cli_abort("For calculation type {.var {type}} at least wt, bmi and sex should be provided")  
  }else if((is.null(wt) || is.null(ht) || is.null(sex)) && type%in%avl_types[11:12]){
    cli::cli_abort("For calculation type {.var {type}} at least wt, ht and sex should be provided")  
  }   
  
  # Perform Calculations
  if (type == "kg-lb") {
    res <-  wt * 2.20462262
  }else if(type=="lb-kg"){
    res <- wt/2.20462262
  }else if(type=="bmi"){
    res <- wt/(ht/100)^2 
  }else if(type=="bsa"){
    res <- exp(-3.751) * ht^0.422 * wt^0.515
  }else if(type=="bsam"){
    res <- sqrt((ht * wt) / 3600)
  }else if(type=="bsah"){
    res <- 0.024265 * ht^0.3964 * wt^0.5378
  }else if(type=="bsa2"){
    res <- 0.007184 * ht^0.725 * wt^0.425
  }else if(type=="bsal"){
    res <- 0.1173 * wt^0.6466
  }else if(type=="ffmj"){
    sf1  <- ifelse(sex==1, 8.78e3, 6.68e3)
    sf2  <- ifelse(sex==1, 244, 216)
    res  <- (9270 * wt)/(sf1 + (sf2*bmi))
  }else if(type=="ffms"){
    sf1  <- ifelse(sex==1,8.78e3, 6.68e3)
    sf2  <- ifelse(sex==1, 0.70, 0.77)
    res  <- (9270 * wt)/(sf1 *sf2*bmi**0.28)
  }else if(type=="lbmb"){
    sf1  <- ifelse(sex==1, 0.252, 0.407)
    sf2  <- ifelse(sex==1, 0.473, 0.267)
    sf3  <- ifelse(sex==1, 48.3, 19.2)
    res  <- (sf1 * wt) + (sf2 * ht)- sf3
  }else if(type=="lbmj"){
    sf1  <- ifelse(sex==1, 1.07, 1.1)
    sf2  <- ifelse(sex==1, 148, 128)
    res  <- (sf1 * wt) - sf2  * (wt/ht)^2
  }else if(type=="lbmp"){
    res <- 3.8*0.0215*wt**0.6469*ht**0.7236
  }else if(type=="pnw"){
    sf1  <- ifelse(sex==1, 1.75, 1.57)
    sf2  <- ifelse(sex==1, 0.0242, 0.0183)
    sf3  <- ifelse(sex==1, 12.6, 10.5)
    res  <- (sf1 * wt) - (sf2 * wt * bmi) - sf3
  }
  return(res)
}
# Calculates EGFR values based on different types of formulas

This function calculates Estimated Glomerular Filtration Rate (EGFR)
values based on most commonly used formulas

## Usage

``` r
egfr(
  scr = NULL,
  sex = NULL,
  age = NULL,
  race = NULL,
  ht = NULL,
  bun = NULL,
  scys = NULL,
  prem = NULL,
  bsa = NULL,
  formula = "CKD-EPI"
)
```

## Arguments

- scr:

  vector with Serum creatinine values in mg/dL

- sex:

  vector with SEX values (where female is defined as a value of 1)

- age:

  vector with AGE values in years

- race:

  vector with RACE values (where caucasian is defined as 1, black as and
  Japanese as \> 2)

- ht:

  vector with HEIGHT values in cm

- bun:

  vector with Blood urea nitrogen in mg/dL

- scys:

  vector with Serum cystatin C in mg/L

- prem:

  vector with PREM (premature) values (where PREM is defined as value of
  1)

- bsa:

  vector with BSA values in m2 provide in case correction should be
  applied (see details)

- formula:

  character with the formula to be used for the EGFR calculations (see
  details)

## Value

a vector with EGFR values

## Details

Currently there are different formulas available for calculations:

- "CKD-EPI": EGFR according to the Chronic Kidney Disease Epidemiology
  (CKD-EPI) study formula
  ([Levey](https://pmc.ncbi.nlm.nih.gov/articles/PMC2763564/)): \$\$
  \textrm{eGFR} = 141 \cdot
  \min\left(\frac{\textrm{Scr}}{\kappa},1\right)^{\alpha} \cdot
  \max\left(\frac{\textrm{Scr}}{\kappa},1\right)^{-1.209} \cdot
  0.993^{\textrm{Age}} \cdot 1.159 \textrm{ \[if black\]} \cdot 1.018
  \textrm{ \[if female\]}\$\$ where \\\min\left(\right)\\ indicates the
  minimum of \\\frac{\textrm{Scr}}{\kappa}\\ or 1; \\\max\left(\right)\\
  indicates the maximum of \\\frac{\textrm{Scr}}{\kappa}\\or 1. scaling
  parameter \\\kappa\\ is 0.9 for males and 0.7 for females and scaling
  parameter \\\alpha\\ is -0.411 for males and -0.329 for females.

- "CKD-EPI-ignore-race": EGFR according to the Chronic Kidney Disease
  Epidemiology (CKD-EPI) refit without race study formula
  ([Delgado](https://pubmed.ncbi.nlm.nih.gov/34563581/)): \$\$
  \textrm{eGFR} = 142 \cdot
  \min\left(\frac{\textrm{Scr}}{\kappa},1\right)^{\alpha} \cdot
  \max\left(\frac{\textrm{Scr}}{\kappa},1\right)^{-1.200} \cdot
  0.9938^{\textrm{Age}} \cdot 1.012 \textrm{ \[if female\]} \$\$ where
  \\\min\left(\right)\\ indicates the minimum of
  \\\frac{\textrm{Scr}}{\kappa}\\ or 1; \\\max\left(\right)\\ indicates
  the maximum of \\\frac{\textrm{Scr}}{\kappa}\\or 1. scaling parameter
  \\\kappa\\ is 0.9 for males and 0.7 for females and scaling parameter
  \\\alpha\\ is -0.302 for males and -0.241 for females.

- "CKD-EPI-Scys", EGFR according to the Chronic Kidney Disease
  Epidemiology study formula
  ([Inker](https://pubmed.ncbi.nlm.nih.gov/22762315/)): \$\$
  \textrm{eGFR} = 133 \cdot
  \min\left(\frac{\textrm{Scys}}{0.8},1\right)^{-0.499} \cdot
  \max\left(\frac{\textrm{Scys}}{0.8},1\right)^{-1.328} \cdot
  0.996^{\textrm{Age}} \cdot 0.932 \textrm{ \[if female\]}\$\$ where
  \\\min\left(\right)\\ indicates the minimum of
  \\\frac{\textrm{Scys}}{0.8}\\ or 1; \\\max\left(\right)\\ indicates
  the maximum of \\\frac{\textrm{Scys}}{0.8}\\ or 1.

- "CKD-EPI-Scr-Scys", EGFR according to the Chronic Kidney Disease
  Epidemiology study formula
  ([Inker](https://pubmed.ncbi.nlm.nih.gov/22762315/)): \$\$
  \textrm{eGFR} = k \cdot l \cdot 135 \cdot
  \min\left(\frac{\textrm{Scr}}{\kappa},1\right)^{\alpha} \cdot
  \max\left(\frac{\textrm{Scr}}{\kappa},1\right)^{-0.601}
  \cdot\min\left(\frac{\textrm{Scys}}{0.8},1\right)^{-0.375} \cdot
  \max\left(\frac{\textrm{Scys}}{0.8},1\right)^{-0.711} \cdot
  0.995^{\textrm{Age}} \$\$ where \\\min\left(\right)\\ indicates the
  minimum of \\\frac{\textrm{Scys}}{0.8}\\ or 1; \\\max\left(\right)\\
  indicates the maximum of \\\frac{\textrm{Scys}}{0.8}\\ or 1, and where
  \\\min\left(\right)\\ indicates the minimum of
  \\\frac{\textrm{Scr}}{\kappa}\\ or 1; \\\max\left(\right)\\ indicates
  the maximum of \\\frac{\textrm{Scr}}{\kappa}\\or 1. Scaling parameter
  k is 1 for males and 0.969 for female, scaling parameter l is 1 if
  White/Caucasian and 1.08 if Black/African American, scaling parameter
  \\\kappa\\ is 0.9 for males and 0.7 for females and scaling parameter
  \\\alpha\\ is -0.207 for males and -0.248 for females.

- "CKD-EPI-Scr-Scys-ignore-race", EGFR according to the Chronic Kidney
  Disease Epidemiology 2021 refit without race study formula
  ([Delgado](https://pubmed.ncbi.nlm.nih.gov/34563581/)): \$\$
  \textrm{eGFR} = k \cdot 135 \cdot
  \min\left(\frac{\textrm{Scr}}{\kappa},1\right)^{\alpha} \cdot
  \max\left(\frac{\textrm{Scr}}{\kappa},1\right)^{-0.544}
  \cdot\min\left(\frac{\textrm{Scys}}{0.8},1\right)^{-0.323} \cdot
  \max\left(\frac{\textrm{Scys}}{0.8},1\right)^{-0.778} \cdot
  0.9961^{\textrm{Age}} \$\$ where \\\min\left(\right)\\ indicates the
  minimum of \\\frac{\textrm{Scys}}{0.8}\\ or 1; \\\max\left(\right)\\
  indicates the maximum of \\\frac{\textrm{Scys}}{0.8}\\ or 1, and where
  \\\min\left(\right)\\ indicates the minimum of
  \\\frac{\textrm{Scr}}{\kappa}\\ or 1; \\\max\left(\right)\\ indicates
  the maximum of \\\frac{\textrm{Scr}}{\kappa}\\or 1. Scaling parameter
  k is 1 for males and 0.963 for female, scaling parameter \\\kappa\\ is
  0.9 for males and 0.7 for females and scaling parameter \\\alpha\\ is
  -0.144 for males and -0.219 for females.

- "CKD-EPI-Japan", EGFR in Japanese adults based on a Japanese
  coefficient-modified CKD-EPI equation
  ([Horio](https://pubmed.ncbi.nlm.nih.gov/20416999/)):
  \$\$\textrm{eGFR} = l \cdot 141 \cdot
  \min\left(\frac{\textrm{Scr}}{\kappa},1\right)^{\alpha} \cdot
  \max\left(\frac{\textrm{Scr}}{\kappa},1\right)^{-1.209} \cdot
  0.993^{\textrm{Age}} \cdot 1.018 \textrm{ \[if female\]}\$\$ where
  \\\min\left(\right)\\ indicates the minimum of
  \\\frac{\textrm{Scr}}{\kappa}\\ or 1; \\\max\left(\right)\\ indicates
  the maximum of \\\frac{\textrm{Scr}}{\kappa}\\or 1. Scaling parameter
  l is 1 for White/Caucasian, 1.159 for Black/African American, 0.813
  for Japanese, scaling parameter \\\kappa\\ is 0.9 for males and 0.7
  for females and scaling parameter \\\alpha\\ is -0.411 for males and
  -0.329 for females.

- "CKD-MDRD", EGFR according to the abbreviated Modification of Diet in
  Renal Disease study formula
  ([Levey](https://hero.epa.gov/hero/index.cfm/reference/details/reference_id/658418)):
  \$\$\textrm{eGFR}= 186 \cdot \textrm{Scr}^{-1.154} \cdot
  \textrm{Age}^{-0.203} \cdot 1.212 \textrm{ \[if black\]} \cdot 0.742
  \textrm{ \[if female\]}\$\$

- "CKD-MDRD2", EGFR according to the re-expressed Modification of Diet
  in Renal Disease (MDRD) study formula
  ([Levey2007](https://pubmed.ncbi.nlm.nih.gov/17332152/)):
  \$\$\textrm{eGFR} = 175 \cdot \textrm{Scr}^{-1.154} \cdot
  \textrm{Age}^{-0.203} \cdot 1.212 \textrm{ \[if black\]} \cdot 0.742
  \textrm{ \[if female\]}\$\$

- "Schwartz-original", EGFR in children, according to the original
  Schwartz formula
  ([Schwartz1987](https://pubmed.ncbi.nlm.nih.gov/3588043/)):
  \$\$\textrm{eGFR} = k \cdot \frac{\textrm{Height}}{\textrm{Scr}}\$\$
  where k = 0.33 in pre-term infants up to 1 year, k = 0.45 in full-term
  infants up to 1 year, k = 0.55 in children 1 year to 13 years, k =
  0.55 in girls \>13 and \<18 years and k = 0.70 in boys \>13 and \<18
  years.

- "Schwartz-CKiD", EGFR in children, according to the Chronic Kidney
  Disease in Children (CKiD) revised Schwartz formula
  ([Schwartz2012](https://pubmed.ncbi.nlm.nih.gov/22622496/)):
  \$\$\textrm{eGFR} = 39.8 \cdot
  \left(\frac{\textrm{Height}}{\textrm{Scr}}\right)^{0.456} \cdot
  \left(\frac{1.8}{\textrm{Scys}}\right)^{0.418} \cdot
  \left(\frac{30}{\textrm{BUN}}\right)^{0.079} \cdot
  \left(\frac{\textrm{Height}}{1.4}\right)^{0.079} \$\$ Scaling
  parameter k is 1 for males and 1.076 for females.

- "Schwartz-1B", EGFR in children, according to the Chronic Kidney
  Disease in Children (CKiD) 1B Schwartz formula
  ([Schwartz2009](https://pmc.ncbi.nlm.nih.gov/articles/PMC2653687/)):
  \$\$\textrm{eGFR} = 40.7 \cdot
  \left(\frac{\textrm{Height}}{\textrm{Scr}}\right)^{0.64} \cdot
  \left(\frac{30}{\textrm{BUN}}\right)^{0.202} \$\$

- "Schwartz", EGFR in children, according to the updated ('bedside')
  Schwartz formula
  ([Schwartz2009](https://pmc.ncbi.nlm.nih.gov/articles/PMC2653687/)):
  \$\$\textrm{eGFR} = 0.413 \cdot
  \frac{\textrm{Height}}{\textrm{Scr}}\$\$ This equation is not meant
  for patients \< 1 years of age.

- "Mayo-Quadratic", EGFR according to the Quadratic Mayo Clinic formula
  ([Rule](https://pubmed.ncbi.nlm.nih.gov/15611490/)). \$\$\textrm{eGFR}
  = \exp\left(1.911 + \frac{5.249}{\textrm{Scr}} -
  \frac{2.114}{\textrm{Scr}^2} - 0.00686 \cdot \textrm{Age} -
  0.205\textrm{ \[if female\]}\right)\$\$ If Scr \< 0.8 mg/dL, a value
  of 0.8 is used in the equation.

- "Matsuo-Japan", EGFR in Japanese adults, according to
  [Matsuo](https://pubmed.ncbi.nlm.nih.gov/19339088/): \$\$\textrm{eGFR}
  = 194 \cdot \textrm{Scr}^{-1.094} \cdot \textrm{Age}^{-0.287} \cdot
  0.739 \textrm{ \[if female\]}\$\$

For all of the calculation methods described above, the reported EGFR
values are in the units "mL/minute/1.73m2". This means that the value is
referenced to a body surface area (BSA) value of 1.73m2. When a value is
provided for BSA, the final outcome will be corrected for the BSA value
and the units become "mL/minute". This is done by multiplying the eGFR
(referenced to a BSA of 1.73m2) with the individual's BSA (it is the
users responsibility to proved BSA values that are calculated using the
appropriate formula) and divided by 1.73. Additional information
regarding this can be found in a [FDA guidance
document](https://www.fda.gov/media/78573/download).

## Author

Richard Hooijmaijers

## Examples

``` r
# dataset with dummy numbers!
crea <- data.frame(id=c(1,1,2),Scr=runif(3),SEX=c(1,1,0),AGE=runif(3),RACE=c(1,1,2))
egfr(crea$Scr,crea$SEX,crea$AGE,crea$RACE, formula="CKD-EPI")
#> [1] 170.8803 315.2422 229.6648
# example for use in dplyr
crea |> dplyr::mutate(EGFR = egfr(Scr,SEX, AGE, RACE, formula="CKD-EPI"))
#>   id        Scr SEX       AGE RACE     EGFR
#> 1  1 0.40353812   1 0.9755478    1 170.8803
#> 2  1 0.06366146   1 0.2898923    1 315.2422
#> 3  2 0.38870131   0 0.6783804    2 229.6648
```

# Calculates different weight variables

This function calculates different variables based on weight and height
and conversion from or to kilograms

## Usage

``` r
weight_height(wt = NULL, ht = NULL, sex = NULL, bmi = NULL, type = "bmi")
```

## Arguments

- wt:

  vector with weight values, in either kg or lb depending on the type
  (see details)

- ht:

  vector with height values in cm (see details)

- sex:

  vector with SEX values (Where female is defined as a value of 1)

- bmi:

  vector with BMI values (see details)

- type:

  character with the type to be used for the calculations (see details)

## Value

a vector with calculated values

## Details

Currently the following types are defined within the function:

### Convert units

- "kg-lb" : Convert units from kg to lb using the formula
  \$\$\textrm{Weight (kg)} = \textrm{Weight (lb)} \cdot 2.20462262\$\$

- "lb-kg" : Convert units from lb to kg using the formula
  \$\$\textrm{Weight (lb)} = \frac{\textrm{Weight (kg)}}{2.20462262}\$\$

### Body mass index

- "bmi" : Calculates body mass index (BMI) using the standard formula
  ([Quetelet1842](https://www.cambridge.org/core/books/treatise-on-man-and-the-development-of-his-faculties/AB13A647A6C8727C06AE5399D7422887),
  \$\$\textrm{BMI} = \frac{\textrm{Weight (kg)}}{\textrm{Height
  (m)}^{2}}\$\$

### Body Surface Area

- "bsa": Body Surface Area, according to [Gehan and
  Georg](https://www.researchgate.net/publication/17656913_Estimation_of_Human_Body_Surface_Area_from_Height_and_Weight),
  \$\$\textrm{BSA} = \exp{-3.751} \cdot \textrm{Height (cm)}^{0.422}
  \cdot \textrm{Weight (kg)}^{0.515}\$\$

- "bsa2": Body Surface Area, according to [DuBois and
  DuBois](https://pubmed.ncbi.nlm.nih.gov/2520314/), \$\$\textrm{BSA} =
  0.007184 \cdot \textrm{Height (cm)}^{0.725} \cdot \textrm{Weight
  (kg)}^{0.425}\$\$

- "bsam": Body Surface Area, according to
  [Mosteller](https://pubmed.ncbi.nlm.nih.gov/3657876/),
  \$\$\textrm{BSA} = \sqrt{\frac{\textrm{Weight (kg)} \cdot
  \textrm{Height (cm)}}{3600}}\$\$

- "bsah": Body Surface Area, according to
  [Haycock](https://pubmed.ncbi.nlm.nih.gov/650346/), \$\$\textrm{BSA} =
  0.024265 \cdot \textrm{Height (cm)}^{0.3964} \cdot \textrm{Weight
  (kg)}^{0.5378}\$\$

- "bsal": Body Surface Area in normal-weight and obese adults up to 250
  kg, according to
  [Livingston](https://pubmed.ncbi.nlm.nih.gov/11500314/),
  \$\$\textrm{BSA} = 0.1173 \cdot \textrm{Weight (kg)}^{0.6466}\$\$

### Fat free mass

- "ffmj": Fat free mass, according to
  [Janmahasatian](https://pubmed.ncbi.nlm.nih.gov/16176118/):
  \$\$\textrm{FFM}=\frac{9270 \cdot \textrm{Weight (kg)}}{k +\left(l
  \cdot \textrm{BMI}\right)}\$\$, where \\k\\ is 6680 for males and 8780
  for females and \\l\\ is 216 for males and 244 for females.

- "ffms": Fat free mass in Indian patients, according to
  [Sinha](https://pubmed.ncbi.nlm.nih.gov/32201910/):
  \$\$\textrm{FFM}=\frac{9270 \cdot \textrm{Weight (kg)}}{k \cdot l
  \cdot \textrm{BMI}^{0.28}}\$\$, where \\k\\ is 6680 for males and 8780
  for females and \\l\\ is 0.77 for males and 0.70 for females.

### Lean body mass

- "lbmb" : Calculates lean body mass (LBM), according to
  [Boers](https://pubmed.ncbi.nlm.nih.gov/6496691/): \$\$\textrm{LBM} =
  k \cdot \textrm{Weight (kg)} + l \cdot \textrm{Height (cm)} - m \$\$ ,
  where \\k\\ is 0.407 for males and 0.252 for females, and \\l\\ is
  0.267 for males and 0.473 for females, and \\m\\ is 19.2 for males and
  48.3 for females.

- "lbmj" : Calculates lean body mass (LBM), according to
  [James](https://onlinelibrary.wiley.com/doi/10.1111/j.1467-3010.1977.tb00966.x):
  \$\$\textrm{LBM} = k \cdot \textrm{Weight (kg)} - l \cdot
  \left(\frac{\textrm{Weight (kg)}}{\textrm{Height (cm)}}\right)^2\$\$,
  where \\k\\ is 1.10 for males and 1.07 for females, and \\l\\ is 128
  in males and 148 in females.

- "lbmp" : Calculates lean body mass (LBM) for children up to 14 years,
  according to [Peters](https://pubmed.ncbi.nlm.nih.gov/21498495/):
  \$\$\textrm{LBM} = 3.8 \cdot 0.0215 \cdot \textrm{Weight
  (kg)}^{0.6469} \cdot \textrm{Height (cm)}^{0.7236}\$\$

### Predicted Normal Weight

- "pnw" : Calculates the Predicted Normal Weight for obese patient,
  according to [Duffull](https://pubmed.ncbi.nlm.nih.gov/15568893/):
  \$\$\textrm{PNWT} = k \cdot \textrm{Weight (kg)} - l \cdot
  \textrm{Height (cm)} \cdot \textrm{BMI} - m\$\$, where \\k\\ is 1.57
  for males and 1.75 for females, and \\l\\ is 0.0183 for males and
  0.0242 for females, and \\m\\ is 10.5 for males and 12.6 for females.

## Author

Richard Hooijmaijers

## Examples

``` r
tmp <- data.frame(id=1,WT=runif(3,70,120),HT=runif(3,160,220))
weight_height(wt=tmp$WT,ht=tmp$HT,type="bmi")
#> [1] 29.12092 21.90432 20.51770
# example for use in dplyr
tmp |> dplyr::mutate(BMI = weight_height(wt=WT,ht=HT,type="bmi"))
#>   id        WT       HT      BMI
#> 1  1 117.42883 200.8098 29.12092
#> 2  1  79.01694 189.9307 21.90432
#> 3  1  80.84499 198.5008 20.51770
```

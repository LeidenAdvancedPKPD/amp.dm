# Impute missing covariates

The function will impute all NA values with either a given statistic
(e.g. median) or with the largest group

## Usage

``` r
impute_covar(var, uniques = NULL, type = "median", verbose = FALSE)
```

## Arguments

- var:

  vector with the items that should be imputed

- uniques:

  vector that defines unique records to enable calculation of stats on
  non duplicate values

- type:

  character of length one defining the type of statistics to perform for
  imputation (see details)

- verbose:

  logical indicating if additional information should be given

## Value

a vector where missing values are imputed

## Details

The function can be used to impute continuous or categorical covariates.
In case continuous covariates the type argument should be a statistic
like median or mean. In case a categorical covariate is used, the type
should be set to 'largest' in which case the category that occurs most
is used. In case multiple values occur most, the last encountered is
used.

## Author

Richard Hooijmaijers

## Examples

``` r
dfrm  <- data.frame(num1 = c(NA,110))
impute_covar(dfrm$num1,type="median")
#> [1] 110 110
```

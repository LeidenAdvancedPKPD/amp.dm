# Creates a flag for outlying values

This function creates a flag identifying the outliers in a vector

## Usage

``` r
flag_outliers(var, type = "boxstat")
```

## Arguments

- var:

  numeric vector that should be checked for outliers

- type:

  character with the type of test to perform for outliers (currently
  only the "boxstats" is available that uses the
  [boxplot](https://rdrr.io/r/graphics/boxplot.html) method)

## Value

a numeric vector the same length as `var` with either 0 (no outlier) or
1 (outlier)

## Author

Richard Hooijmaijers

## Examples

``` r
dfrm <- data.frame(a = 1:10, b = c(1:9,50))
flag_outliers(dfrm$a)
#>  [1] 0 0 0 0 0 0 0 0 0 0
flag_outliers(dfrm$b)
#>  [1] 0 0 0 0 0 0 0 0 0 1
```

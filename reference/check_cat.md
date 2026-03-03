# Create an overview of the available categories

This function reports information for the categories, mainly the
frequencies, proportions and missing values

## Usage

``` r
check_cat(x, missing = c(-999, NA), detail = 5, threshold = c(NA, NA))
```

## Arguments

- x:

  numeric vector with the categories

- missing:

  vector with the values that present missing information

- detail:

  numeric with he level of detail to print (see below for details)

- threshold:

  numeric vector with the threshold numbers and proportions (see
  details)

## Value

Nothing is returned information is printed on screen

## Details

The detail argument can be used to print certain information:

- 5: All possible information is printed

- 4: Only the table with frequencies and proportions

- 3: Only information regarding missing data

- 2: Only a warning in case number of missing is above threshold (see
  below)

- 1: A named vector with the available categories that can be used in
  [num_lump](https://leidenadvancedpkpd.github.io/amp.dm/reference/num_lump.md)
  The threshold presents the absolute number (first number) and
  proportions (second number) to check. If either one of these numbers
  is above the threshold for missing values, a warning is given. This
  can be convenient to decide whether or not a category should be used
  during analyses.

## Author

Richard Hooijmaijers

## Examples

``` r
dfrm   <- data.frame(cat1 = c(rep(1:5,10),-999), 
                     cat2 = c(rep(letters[1:5],10),-999))
check_cat(dfrm$cat1)
#> ── freq (prop) for x ─────────────────────────────────────────────────────
#> -999: 1 (2.0%)
#>    1: 10 (19.6%)
#>    2: 10 (19.6%)
#>    3: 10 (19.6%)
#>    4: 10 (19.6%)
#>    5: 10 (19.6%)
#> ── missing values x ──────────────────────────────────────────────────────
#> Total of 1 missing values resulting in 2.0%
#> ── String copy for lumping ───────────────────────────────────────────────
#> c("-999" = -999, "1" = 1, "2" = 2, "3" = 3, "4" = 4, "5" = 5)
check_cat(dfrm$cat2, detail=1)                       
#> ── String copy for lumping ───────────────────────────────────────────────
#> c("-999" = -999, "a" = a, "b" = b, "c" = c, "d" = d, "e" = e)
check_cat(dfrm$cat1,detail=2,threshold = c(NA,0.1))
```

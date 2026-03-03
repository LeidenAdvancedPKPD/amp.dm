# Perform lumping of numerical values

This function is mainly a wrapper for
[forcats::fct_lump](https://forcats.tidyverse.org/reference/fct_lump.html)
but applied on numeric variables. Furthermore there is the option to use
uniques to determine small categories for instance on individual level

## Usage

``` r
num_lump(x, lumpcat = 99, uniques = NULL, prop = NULL, min = NULL, ...)
```

## Arguments

- x:

  numeric vector with the items that should be lumped

- lumpcat:

  the category in which the lumped levels should be added (see details)

- uniques:

  vector that defines unique records to enable lumping on non duplicate
  values

- prop:

  numeric with the threshold proportions for lumping

- min:

  numeric with the min number of times a level should appear to not lump

- ...:

  additional arguments passed to
  [forcats::fct_lump_min](https://forcats.tidyverse.org/reference/fct_lump.html)
  and/or
  [forcats::fct_lump_prop](https://forcats.tidyverse.org/reference/fct_lump.html)

## Value

vector with the lumping applied

## Details

The argument lumpcat is the level in which lumped values should appear
and can be one of the following:

- numeric with the category number to set the levels to

- character specifying "largest" to select the largest category
  (selected before lumping)

- named vector to set the 'algorithm' for instance: c('5'='3', '4'='6')
  to set category 5 to 3 and 4 to 6 when these categories need lumping

## Author

Richard Hooijmaijers

## Examples

``` r
dfrm <- data.frame(id = 1:30, cat = c(rep(1,8),rep(2,13), rep(3,4),rep(4,5)))
num_lump(x=dfrm$cat, lumpcat=99, prop=0.15)
#> ! Lumping performed but there are still categories < prop (99)
#> ℹ Numbers lumped, returned 4 categories
#>  [1]  1  1  1  1  1  1  1  1  2  2  2  2  2  2  2  2  2  2  2  2  2 99 99
#> [24] 99 99  4  4  4  4  4
```

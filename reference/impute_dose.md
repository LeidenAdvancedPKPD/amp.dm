# Imputes dose records using ADDL and II by looking forward and backwards

This function imputes dose records by looking at the missing doses
between available records based on a given II value

## Usage

``` r
impute_dose(data, id, datetime, amt = "AMT", ii = "II", thr = 50, back = TRUE)
```

## Arguments

- data:

  data frame to perform the calculations on

- id:

  character identifying the id variable within the data frame

- datetime:

  character identifying the date/time variable (POSIXct) within the data
  frame

- amt:

  character identifying the AMT (amount) variable within the data frame

- ii:

  character identifying the II (Interdose Interval) variable within the
  data frame

- thr:

  numeric indicating the threshold percentage for imputation (see
  details)

- back:

  logical indicating if the time for imputed doses should be taken from
  the previous record (TRUE) or the next (FALSE)

## Value

a data frame with imputed dose records

## Details

The function fills in the doses by looking at the time difference and II
between all records. Be aware that this can result in unexpected results
in a few cases, so results should always be handled with care. The
function will determine if a dose should be imputed based on the 'thr'
value. For each dose, the function determines the percentage difference
from the previous dose based on the II value. In case the expected
difference is above the threshold value, imputation will be done.

## Author

Richard Hooijmaijers

## Examples

``` r
dfrm <- data.frame(id=c(1,1), dt=c(Sys.time(),Sys.time()+ 864120),
                   II=c(24,24),AMT=c(10,10))
impute_dose(dfrm,"id","dt")
#> ! Found unequal TAU values check before using results
#>   id                  dt II AMT       type ADDL
#> 1  1 2026-03-27 09:08:15 24  10   original   NA
#> 2  1 2026-03-28 09:08:15 24  10 additional    8
#> 3  1 2026-04-06 09:10:15 24  10   original   NA
```

# Fills down dates within a data frame that include a start and end date

This function can be used in case a start and end date is known for
dosing. This function fills down the dates so each date between start
and end is placed on a separate row. Subsequently the dataset can be
used to merge with available date information and impute missing dates.

## Usage

``` r
fill_dates(data, start, end, tau = 1, repdat = 1)
```

## Arguments

- data:

  data frame for which the dates should be filled down

- start:

  character identifying the start date (as date format) within the data
  frame

- end:

  character identifying the end date (as date format) within the data
  frame

- tau:

  integer with the tau in days (e.g. 2 for dosing every other day)

- repdat:

  integer with repeats per day (e.g. 2 in case of twice daily dosing)

## Value

a data frame with filled out dates

## Author

Richard Hooijmaijers

## Examples

``` r
dfrm <- data.frame(ID=1:2,first=as.Date(c("2016-10-01","2016-12-01"), "%Y-%m-%d"),
                   last=as.Date(c("2016-10-03","2016-12-02"), "%Y-%m-%d"))
fill_dates(dfrm, "first", "last")
#>   ID      first       last        dat datnum
#> 1  1 2016-10-01 2016-10-03 2016-10-01      1
#> 2  1 2016-10-01 2016-10-03 2016-10-02      1
#> 3  1 2016-10-01 2016-10-03 2016-10-03      1
#> 4  2 2016-12-01 2016-12-02 2016-12-01      1
#> 5  2 2016-12-01 2016-12-02 2016-12-02      1
fill_dates(dfrm, "first", "last", 2, 3)
#>   ID      first       last        dat datnum
#> 1  1 2016-10-01 2016-10-03 2016-10-01      1
#> 2  1 2016-10-01 2016-10-03 2016-10-01      2
#> 3  1 2016-10-01 2016-10-03 2016-10-01      3
#> 4  1 2016-10-01 2016-10-03 2016-10-03      1
#> 5  1 2016-10-01 2016-10-03 2016-10-03      2
#> 6  1 2016-10-01 2016-10-03 2016-10-03      3
#> 7  2 2016-12-01 2016-12-02 2016-12-01      1
#> 8  2 2016-12-01 2016-12-02 2016-12-01      2
#> 9  2 2016-12-01 2016-12-02 2016-12-01      3
```

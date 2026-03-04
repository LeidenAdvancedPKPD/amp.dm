# Create time variables for usage in NONMEM analyses

This function calculates the most important time variables based on
multiple variables in a data frame.

## Usage

``` r
time_calc(
  data,
  datetime,
  evid = NULL,
  addl = NULL,
  ii = NULL,
  amt = "AMT",
  id = "ID",
  dig = 2
)
```

## Arguments

- data:

  data frame to perform the calculations on

- datetime:

  character identifying the date/time variable (POSIXct) within the data
  frame

- evid:

  character identifying the event ID (EVID) within the data frame

- addl:

  character identifying the additional dose levels (ADDL) within the
  data frame

- ii:

  character identifying the interdose interval (II) within the data
  frame

- amt:

  character identifying the amount variable (only needed if `evid` is
  not provided)

- id:

  character identifying the ID or subject variable

- dig:

  numeric indicating with how many digits the resulting times should be
  available

## Value

a data frame with the calculated times

## Details

The function calculates the TIME, TALD (time after last dose) and TAFD
(time after first dose). The different time variables are calculated in
hours, where a POSIXct for the datetime variable is expected. The
function takes into account ADDL and II records when provided, to
correctly identify the TALD. One must be cautious however when having
ADDL/II and a complex dosing schedule (e.g. alternating dose schedules,
more than 1 dose per day, multiple compounds administration). In general
it is good practice to double check the output for multiple subjects in
case of complex designs including ADDL/II.

## Author

Richard Hooijmaijers

## Examples

``` r
dfrm <- data.frame(ID=rep(1,5), dt=Sys.time() + c(0,8e+5,1e+6,2e+6,3e+6),
                   AMT=c(NA,10,NA,0,NA), II=rep(24,5),EVID=c(0,1,0,1,0))
time_calc(dfrm,"dt","EVID")
#> # A tibble: 5 × 8
#>      ID dt                    AMT    II  EVID  TIME   TAFD   TALD
#>   <dbl> <dttm>              <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1     1 2026-03-04 08:49:30    NA    24     0    0  -222.  -222. 
#> 2     1 2026-03-13 15:02:50    10    24     1  222.   NA     NA  
#> 3     1 2026-03-15 22:36:10    NA    24     0  278.   55.6   55.6
#> 4     1 2026-03-27 12:22:50     0    24     1  556.  333.    NA  
#> 5     1 2026-04-08 02:09:30    NA    24     0  833.  611.   278. 
```

# Create ADDL data item and deletes unnecessary amount lines

This function determines if subsequent dose items are exactly the same
as the tau value. If this is the case it will count the number of times
this occur and create the applicable number of additional dose levels
and removes unnecessary rows

## Usage

``` r
create_addl(data, datetime, id, dose, tau, evid = NULL)
```

## Arguments

- data:

  data frame to perform the action on

- datetime:

  character identifying the date/time variable (POSIXct) within the data
  frame

- id:

  character identifying the subject ID within the data frame

- dose:

  character identifying the dose within the data frame (ADDL can only be
  set for equal doses)

- tau:

  character identifying the tau (or II) within the data frame

- evid:

  character identifying the event ID (EVID) within the data frame. This
  is used to distinguish observations from dosing records, e.g. 0 for
  observations

## Value

a data frame with ADDL records added

## Author

Richard Hooijmaijers

## Examples

``` r
dts  <- c(Sys.time(),Sys.time() + (24*60*60),Sys.time() + (48*60*60),Sys.time() + (96*60*60))
data <- data.frame(id=1,dt=dts,dose=10,tau=24)
create_addl(data=data, datetime="dt", id="id", dose="dose", tau="tau")
#> # A tibble: 2 × 5
#>      id dt                   dose   tau  ADDL
#>   <dbl> <dttm>              <dbl> <dbl> <dbl>
#> 1     1 2026-03-03 12:15:33    10    24     2
#> 2     1 2026-03-07 12:15:33    10    24     0

data2 <- rbind(cbind(data,evid=1),data.frame(id=1,dt=dts[4]+60,dose=10,tau=24,evid=0))
create_addl(data=data2, datetime="dt", id="id", dose="dose", tau="tau", evid="evid")
#> # A tibble: 3 × 6
#>      id dt                   dose   tau  evid  ADDL
#>   <dbl> <dttm>              <dbl> <dbl> <dbl> <dbl>
#> 1     1 2026-03-03 12:15:33    10    24     1     2
#> 2     1 2026-03-07 12:15:33    10    24     1     0
#> 3     1 2026-03-07 12:16:33    10    24     0    NA
```

# Expand rows in case ADDL and II variables are present

This function expands ADDL and II records. This is done by placing each
ADDL record on a separate line. This is convenient in case of individual
dose calculations

## Usage

``` r
expand_addl_ii(data, evid = NULL, del_iiaddl = TRUE)
```

## Arguments

- data:

  data frame to perform the expansion on

- evid:

  character identifying the event ID (EVID) within the data frame This
  is used to distinguish observations from dosing records, e.g. 0 for
  observations

- del_iiaddl:

  logical identifying if the ADDL and II variables can be deleted from
  output

## Value

a data frame with expanded dose records

## Details

The function expects that certain variables are present in the data (at
least ID, TIME, ADDL and II)

## Author

Richard Hooijmaijers

## Examples

``` r
dfrm <- data.frame(ID=c(1,1), TIME=c(0,12),II=c(12,0),ADDL=c(5,0),AMT=c(10,0),EVID=c(1,0))
expand_addl_ii(dfrm,evid="EVID")
#>   ID TIME AMT EVID
#> 1  1    0  10    1
#> 2  1   12  10    1
#> 3  1   12   0    0
#> 4  1   24  10    1
#> 5  1   36  10    1
#> 6  1   48  10    1
#> 7  1   60  10    1
```

# Create counts and frequencies within in data frame

This function calculates and reports counts and frequencies stratified
by one or more variables within a data frame

## Usage

``` r
counts_df(
  data,
  by,
  id = NULL,
  style = 1,
  ret = "tbl",
  capt = "Information multiple data frames",
  align = NULL,
  size = "\\footnotesize",
  ...
)
```

## Arguments

- data:

  data frame for which the table should be created

- by:

  character identifying by variables within the data frame for
  stratification

- id:

  character identifying the ID variable within the data frame (see
  details)

- style:

  numeric with the type of output to return (see details)

- ret:

  a character vector to define what kind of output should be returned
  (either "dfrm", "tbl", "file")

- capt:

  character with the caption of the table (not used in case data frame
  is returned)

- align:

  alignment of the table passed to
  [general_tbl](https://leidenadvancedpkpd.github.io/amp.dm/reference/general_tbl.md)
  (not used in case data frame is returned)

- size:

  character with font size as for the table
  [general_tbl](https://leidenadvancedpkpd.github.io/amp.dm/reference/general_tbl.md)

- ...:

  additional arguments passed to
  [general_tbl](https://leidenadvancedpkpd.github.io/amp.dm/reference/general_tbl.md)

## Value

a data frame, code for table or nothing in case a PDF file is created

## Details

This function generates frequency tables, by default for the number of
observation per strata. In case the id argument is used the function
will also report the number and frequencies of distinct IDs. By default
the observations and percentages are reported in separate columns
(convenient for further processing). In case style is set to a value of
2, a single column is created that holds the observations and
percentages in a formatted ways (convenient for tabulating)

## Author

Richard Hooijmaijers

## Examples

``` r
data("Theoph")
Theoph$trt <- ifelse(as.numeric(Theoph$Subject)<6,1,2)
Theoph$sex <- ifelse(as.numeric(Theoph$Subject)<4,1,0)
counts_df(data=Theoph, by=c("trt","sex"),id="Subject", ret="dfrm")
#> # A tibble: 4 × 6
#>   trt   sex    Nobs PERCobs   Nid PERCid
#>   <chr> <chr> <int>   <dbl> <int>  <dbl>
#> 1 1     0        22    16.7     2   16.7
#> 2 1     1        33    25       3   25  
#> 3 2     0        77    58.3     7   58.3
#> 4 Total Total   132   100      12  100  
counts_df(data=Theoph, by="sex",id="Subject", ret="dfrm")
#> # A tibble: 3 × 5
#>   sex    Nobs PERCobs   Nid PERCid
#>   <chr> <int>   <dbl> <int>  <dbl>
#> 1 0        99      75     9     75
#> 2 1        33      25     3     25
#> 3 Total   132     100    12    100
counts_df(data=Theoph, by=c("trt","sex"),id="Subject", style=2, ret="dfrm")
#> # A tibble: 4 × 4
#>   trt   sex   Obs        Ids      
#>   <chr> <chr> <chr>      <chr>    
#> 1 1     0     22 (16.7%) 2 (16.7%)
#> 2 1     1     33 (25%)   3 (25%)  
#> 3 2     0     77 (58.3%) 7 (58.3%)
#> 4 Total Total 132 (100%) 12 (100%)
```

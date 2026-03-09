# Retrieve log objects

Returns one or more dataframes with log information related to function
like
[filterr](https://leidenadvancedpkpd.github.io/amp.dm/reference/filterr.md),
[left_joinr](https://leidenadvancedpkpd.github.io/amp.dm/reference/left_joinr.md),
[cmnt](https://leidenadvancedpkpd.github.io/amp.dm/reference/cmnt.md),
[srce](https://leidenadvancedpkpd.github.io/amp.dm/reference/srce.md)
and
[read_data](https://leidenadvancedpkpd.github.io/amp.dm/reference/read_data.md)

## Usage

``` r
get_log()
```

## Value

a named list of dataframes

## Author

Richard Hooijmaijers

## Examples

``` r
xldat <- readxl::readxl_example("datasets.xlsx")
xlin  <- read_data(xldat, comment="read test")
#> ℹ Read in /home/runner/work/_temp/Library/readxl/extdata/datasets.xlsx which has 32 records and 11 variables
get_log()
#> $filterr_nfo
#>   datain       coding datainrows dataoutrows rowsdropped comment
#> 1 Theoph Subject == 1        132          11         121        
#> 2 Theoph Subject == 2        132          11         121        
#> 
#> $read_nfo
#>                                                         datain datainrows
#> 1 /home/runner/work/_temp/Library/readxl/extdata/datasets.xlsx         32
#>   dataincols   comment
#> 1         11 read test
#> 
```

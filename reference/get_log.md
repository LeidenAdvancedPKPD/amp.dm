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
if (FALSE) { # \dontrun{
  xldat <- readxl::readxl_example("datasets.xlsx")
  xlin  <- read_data(xldat, comment="read test")
  get_log()
} # }
```

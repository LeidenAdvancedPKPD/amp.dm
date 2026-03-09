# Checks nonmem dataset for common errors/mistakes

This function checks if there are any common errors or mistakes within a
NONMEM dataset, and reports the results back to console, table or
dataframe

## Usage

``` r
check_nmdata(
  x,
  type = 1,
  ret = "tbl",
  capt = NULL,
  align = NULL,
  size = "\\footnotesize",
  ...
)
```

## Arguments

- x:

  either a path to a CSV file or a data frame with the NONMEM data that
  should be checked

- type:

  integer with the type of checks. Currently 1 can be used for checks
  that should all pass for a valid analysis and 2 for checks that
  trigger further investigation

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

the checks are either printed, returned as dataframe or placed in a PDF

## Author

Richard Hooijmaijers

## Examples

``` r
chkf <- system.file("example/NM.theoph.V1.csv",package = "amp.dm")
check_nmdata(chkf)
#> \begingroup\footnotesize
#> \begin{longtable}{ll}
#> \caption{Result of essential data checks} \\ 
#>   \toprule Check & result \\ 
#>   \midrule\endhead CSV is readable & Yes \\ 
#>   More than 1 line of data & Yes \\ 
#>   More than 1 data item & Yes \\ 
#>   First name set (row.names set to FALSE) & Yes \\ 
#>   Variables ID, TIME and DV present in data & Yes \\ 
#>   Data ordered on ID and TIME & Yes \\ 
#>   Quotes not present around data items & Yes \\ 
#>   \hline
#> \end{longtable}
#> \endgroup
```

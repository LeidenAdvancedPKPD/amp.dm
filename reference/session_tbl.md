# Create information for R session

This function creates a latex table or data frame with information from
the R session (sessionInfo() and Sys.info())

## Usage

``` r
session_tbl(
  ret = "tbl",
  capt = "Session info",
  align = "lp{8cm}",
  size = "\\footnotesize",
  ...
)
```

## Arguments

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

This function can be used to create a table with the most important
information of a R session, the user that is running the R session and
the current date/time

## Author

Richard Hooijmaijers

## Examples

``` r
session_tbl()
#> \begingroup\footnotesize
#> \begin{longtable}{lp{8cm}}
#> \caption{Session info} \\ 
#>   \toprule parameter & value \\ 
#>   \midrule\endhead R version & R version 4.5.2 (2025-10-31) \\ 
#>   System & x86\_64-pc-linux-gnu \\ 
#>   OS & Ubuntu 24.04.3 LTS \\ 
#>   Base packages & stats, graphics, grDevices, utils, datasets, methods, base \\ 
#>   Other packages & amp.dm (0.2.0) \\ 
#>   Logged in User & runner \\ 
#>   Machine & runnervmnay03 \\ 
#>   Time & 2026-03-03 14:07:29.257093 \\ 
#>   \hline
#> \end{longtable}
#> \endgroup
```

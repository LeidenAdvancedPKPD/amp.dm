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
  incscript = FALSE,
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

- incscript:

  logical indicating if the name of the script should be included (using
  [get_script](https://leidenadvancedpkpd.github.io/amp.dm/reference/get_script.md))

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
#>   \midrule\endhead R version & R version 4.5.3 (2026-03-11) \\ 
#>   System & x86\_64-pc-linux-gnu \\ 
#>   OS & Ubuntu 24.04.4 LTS \\ 
#>   Base packages & stats, graphics, grDevices, utils, datasets, methods, base \\ 
#>   Other packages & amp.dm (0.2.1) \\ 
#>   Logged in User & runner \\ 
#>   Machine & runnervmrg6be \\ 
#>   Time & 2026-03-31 07:53:05.595347 \\ 
#>   \hline
#> \end{longtable}
#> \endgroup
```

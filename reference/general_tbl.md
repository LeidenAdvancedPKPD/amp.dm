# General table wrapper for documentation functions

This function creates a latex table

## Usage

``` r
general_tbl(
  data,
  ret = "tbl",
  capt = "General table",
  align = NULL,
  outnm = NULL,
  tabenv = "longtable",
  float = FALSE,
  hlineafter = NULL,
  addtorow = list(pos = list(-1, 0), command = c("\\toprule ",
    "\\midrule\\endhead ")),
  ...
)
```

## Arguments

- data:

  data frame for which the table should be created

- ret:

  a character vector to define what kind of output should be returned
  (either "dfrm", "tbl", "file")

- capt:

  character with the caption of the table

- align:

  alignment of the table passed to
  [R3port::ltx_list](https://rdrr.io/pkg/R3port/man/ltx_list.html) or
  [xtable::print.xtable](https://rdrr.io/pkg/xtable/man/print.xtable.html)
  (see details below)

- outnm:

  character with the name of the tex file to generate and compile, e.g.
  "define.tex" (only applicable in case file is returned)

- tabenv:

  character with the tabular environment passed to
  [xtable::print.xtable](https://rdrr.io/pkg/xtable/man/print.xtable.html)

- float:

  logical defining float passed to
  [xtable::print.xtable](https://rdrr.io/pkg/xtable/man/print.xtable.html)

- hlineafter:

  a vector indicating the rows after which a horizontal line should
  appear passed to
  [xtable::print.xtable](https://rdrr.io/pkg/xtable/man/print.xtable.html)

- addtorow:

  A list containing the position of rows and commands passed to
  [xtable::print.xtable](https://rdrr.io/pkg/xtable/man/print.xtable.html)

- ...:

  additional arguments passed to either
  [R3port::ltx_list](https://rdrr.io/pkg/R3port/man/ltx_list.html) or
  [xtable::print.xtable](https://rdrr.io/pkg/xtable/man/print.xtable.html)
  depending on what is returned

## Value

a data frame, code for table or nothing in case a PDF file is created

## Details

This function is a general function to create a xtable suitable for
documentation, or directly creates an compiles a latex file using the
`R3port` package. The align argument can be used to change the column
widths of a table to be able to fit a table on a page (e.g. in latex
wide tables can fall off a page). The way this should be used is to
provide a vector of one with a specification for each column. For
example `lp{3cm}r` can be used for left align first column, second
column of 3 cm and third column right aligned. In case align is set to
NULL a default alignment is used

## Author

Richard Hooijmaijers

## Examples

``` r
general_tbl(head(Theoph))
#> \begin{longtable}{lrrrr}
#> \caption{General table} \\ 
#>   \toprule Subject & Wt & Dose & Time & conc \\ 
#>   \midrule\endhead 1 & 79.60 & 4.02 & 0.00 & 0.74 \\ 
#>   1 & 79.60 & 4.02 & 0.25 & 2.84 \\ 
#>   1 & 79.60 & 4.02 & 0.57 & 6.57 \\ 
#>   1 & 79.60 & 4.02 & 1.12 & 10.50 \\ 
#>   1 & 79.60 & 4.02 & 2.02 & 9.66 \\ 
#>   1 & 79.60 & 4.02 & 3.82 & 8.58 \\ 
#>   \hline
#> \end{longtable}
```

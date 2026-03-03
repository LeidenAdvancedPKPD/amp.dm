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
general_tbl(Theoph)
#> \begin{longtable}{lrrrr}
#> \caption{General table} \\ 
#>   \toprule Subject & Wt & Dose & Time & conc \\ 
#>   \midrule\endhead 1 & 79.60 & 4.02 & 0.00 & 0.74 \\ 
#>   1 & 79.60 & 4.02 & 0.25 & 2.84 \\ 
#>   1 & 79.60 & 4.02 & 0.57 & 6.57 \\ 
#>   1 & 79.60 & 4.02 & 1.12 & 10.50 \\ 
#>   1 & 79.60 & 4.02 & 2.02 & 9.66 \\ 
#>   1 & 79.60 & 4.02 & 3.82 & 8.58 \\ 
#>   1 & 79.60 & 4.02 & 5.10 & 8.36 \\ 
#>   1 & 79.60 & 4.02 & 7.03 & 7.47 \\ 
#>   1 & 79.60 & 4.02 & 9.05 & 6.89 \\ 
#>   1 & 79.60 & 4.02 & 12.12 & 5.94 \\ 
#>   1 & 79.60 & 4.02 & 24.37 & 3.28 \\ 
#>   2 & 72.40 & 4.40 & 0.00 & 0.00 \\ 
#>   2 & 72.40 & 4.40 & 0.27 & 1.72 \\ 
#>   2 & 72.40 & 4.40 & 0.52 & 7.91 \\ 
#>   2 & 72.40 & 4.40 & 1.00 & 8.31 \\ 
#>   2 & 72.40 & 4.40 & 1.92 & 8.33 \\ 
#>   2 & 72.40 & 4.40 & 3.50 & 6.85 \\ 
#>   2 & 72.40 & 4.40 & 5.02 & 6.08 \\ 
#>   2 & 72.40 & 4.40 & 7.03 & 5.40 \\ 
#>   2 & 72.40 & 4.40 & 9.00 & 4.55 \\ 
#>   2 & 72.40 & 4.40 & 12.00 & 3.01 \\ 
#>   2 & 72.40 & 4.40 & 24.30 & 0.90 \\ 
#>   3 & 70.50 & 4.53 & 0.00 & 0.00 \\ 
#>   3 & 70.50 & 4.53 & 0.27 & 4.40 \\ 
#>   3 & 70.50 & 4.53 & 0.58 & 6.90 \\ 
#>   3 & 70.50 & 4.53 & 1.02 & 8.20 \\ 
#>   3 & 70.50 & 4.53 & 2.02 & 7.80 \\ 
#>   3 & 70.50 & 4.53 & 3.62 & 7.50 \\ 
#>   3 & 70.50 & 4.53 & 5.08 & 6.20 \\ 
#>   3 & 70.50 & 4.53 & 7.07 & 5.30 \\ 
#>   3 & 70.50 & 4.53 & 9.00 & 4.90 \\ 
#>   3 & 70.50 & 4.53 & 12.15 & 3.70 \\ 
#>   3 & 70.50 & 4.53 & 24.17 & 1.05 \\ 
#>   4 & 72.70 & 4.40 & 0.00 & 0.00 \\ 
#>   4 & 72.70 & 4.40 & 0.35 & 1.89 \\ 
#>   4 & 72.70 & 4.40 & 0.60 & 4.60 \\ 
#>   4 & 72.70 & 4.40 & 1.07 & 8.60 \\ 
#>   4 & 72.70 & 4.40 & 2.13 & 8.38 \\ 
#>   4 & 72.70 & 4.40 & 3.50 & 7.54 \\ 
#>   4 & 72.70 & 4.40 & 5.02 & 6.88 \\ 
#>   4 & 72.70 & 4.40 & 7.02 & 5.78 \\ 
#>   4 & 72.70 & 4.40 & 9.02 & 5.33 \\ 
#>   4 & 72.70 & 4.40 & 11.98 & 4.19 \\ 
#>   4 & 72.70 & 4.40 & 24.65 & 1.15 \\ 
#>   5 & 54.60 & 5.86 & 0.00 & 0.00 \\ 
#>   5 & 54.60 & 5.86 & 0.30 & 2.02 \\ 
#>   5 & 54.60 & 5.86 & 0.52 & 5.63 \\ 
#>   5 & 54.60 & 5.86 & 1.00 & 11.40 \\ 
#>   5 & 54.60 & 5.86 & 2.02 & 9.33 \\ 
#>   5 & 54.60 & 5.86 & 3.50 & 8.74 \\ 
#>   5 & 54.60 & 5.86 & 5.02 & 7.56 \\ 
#>   5 & 54.60 & 5.86 & 7.02 & 7.09 \\ 
#>   5 & 54.60 & 5.86 & 9.10 & 5.90 \\ 
#>   5 & 54.60 & 5.86 & 12.00 & 4.37 \\ 
#>   5 & 54.60 & 5.86 & 24.35 & 1.57 \\ 
#>   6 & 80.00 & 4.00 & 0.00 & 0.00 \\ 
#>   6 & 80.00 & 4.00 & 0.27 & 1.29 \\ 
#>   6 & 80.00 & 4.00 & 0.58 & 3.08 \\ 
#>   6 & 80.00 & 4.00 & 1.15 & 6.44 \\ 
#>   6 & 80.00 & 4.00 & 2.03 & 6.32 \\ 
#>   6 & 80.00 & 4.00 & 3.57 & 5.53 \\ 
#>   6 & 80.00 & 4.00 & 5.00 & 4.94 \\ 
#>   6 & 80.00 & 4.00 & 7.00 & 4.02 \\ 
#>   6 & 80.00 & 4.00 & 9.22 & 3.46 \\ 
#>   6 & 80.00 & 4.00 & 12.10 & 2.78 \\ 
#>   6 & 80.00 & 4.00 & 23.85 & 0.92 \\ 
#>   7 & 64.60 & 4.95 & 0.00 & 0.15 \\ 
#>   7 & 64.60 & 4.95 & 0.25 & 0.85 \\ 
#>   7 & 64.60 & 4.95 & 0.50 & 2.35 \\ 
#>   7 & 64.60 & 4.95 & 1.02 & 5.02 \\ 
#>   7 & 64.60 & 4.95 & 2.02 & 6.58 \\ 
#>   7 & 64.60 & 4.95 & 3.48 & 7.09 \\ 
#>   7 & 64.60 & 4.95 & 5.00 & 6.66 \\ 
#>   7 & 64.60 & 4.95 & 6.98 & 5.25 \\ 
#>   7 & 64.60 & 4.95 & 9.00 & 4.39 \\ 
#>   7 & 64.60 & 4.95 & 12.05 & 3.53 \\ 
#>   7 & 64.60 & 4.95 & 24.22 & 1.15 \\ 
#>   8 & 70.50 & 4.53 & 0.00 & 0.00 \\ 
#>   8 & 70.50 & 4.53 & 0.25 & 3.05 \\ 
#>   8 & 70.50 & 4.53 & 0.52 & 3.05 \\ 
#>   8 & 70.50 & 4.53 & 0.98 & 7.31 \\ 
#>   8 & 70.50 & 4.53 & 2.02 & 7.56 \\ 
#>   8 & 70.50 & 4.53 & 3.53 & 6.59 \\ 
#>   8 & 70.50 & 4.53 & 5.05 & 5.88 \\ 
#>   8 & 70.50 & 4.53 & 7.15 & 4.73 \\ 
#>   8 & 70.50 & 4.53 & 9.07 & 4.57 \\ 
#>   8 & 70.50 & 4.53 & 12.10 & 3.00 \\ 
#>   8 & 70.50 & 4.53 & 24.12 & 1.25 \\ 
#>   9 & 86.40 & 3.10 & 0.00 & 0.00 \\ 
#>   9 & 86.40 & 3.10 & 0.30 & 7.37 \\ 
#>   9 & 86.40 & 3.10 & 0.63 & 9.03 \\ 
#>   9 & 86.40 & 3.10 & 1.05 & 7.14 \\ 
#>   9 & 86.40 & 3.10 & 2.02 & 6.33 \\ 
#>   9 & 86.40 & 3.10 & 3.53 & 5.66 \\ 
#>   9 & 86.40 & 3.10 & 5.02 & 5.67 \\ 
#>   9 & 86.40 & 3.10 & 7.17 & 4.24 \\ 
#>   9 & 86.40 & 3.10 & 8.80 & 4.11 \\ 
#>   9 & 86.40 & 3.10 & 11.60 & 3.16 \\ 
#>   9 & 86.40 & 3.10 & 24.43 & 1.12 \\ 
#>   10 & 58.20 & 5.50 & 0.00 & 0.24 \\ 
#>   10 & 58.20 & 5.50 & 0.37 & 2.89 \\ 
#>   10 & 58.20 & 5.50 & 0.77 & 5.22 \\ 
#>   10 & 58.20 & 5.50 & 1.02 & 6.41 \\ 
#>   10 & 58.20 & 5.50 & 2.05 & 7.83 \\ 
#>   10 & 58.20 & 5.50 & 3.55 & 10.21 \\ 
#>   10 & 58.20 & 5.50 & 5.05 & 9.18 \\ 
#>   10 & 58.20 & 5.50 & 7.08 & 8.02 \\ 
#>   10 & 58.20 & 5.50 & 9.38 & 7.14 \\ 
#>   10 & 58.20 & 5.50 & 12.10 & 5.68 \\ 
#>   10 & 58.20 & 5.50 & 23.70 & 2.42 \\ 
#>   11 & 65.00 & 4.92 & 0.00 & 0.00 \\ 
#>   11 & 65.00 & 4.92 & 0.25 & 4.86 \\ 
#>   11 & 65.00 & 4.92 & 0.50 & 7.24 \\ 
#>   11 & 65.00 & 4.92 & 0.98 & 8.00 \\ 
#>   11 & 65.00 & 4.92 & 1.98 & 6.81 \\ 
#>   11 & 65.00 & 4.92 & 3.60 & 5.87 \\ 
#>   11 & 65.00 & 4.92 & 5.02 & 5.22 \\ 
#>   11 & 65.00 & 4.92 & 7.03 & 4.45 \\ 
#>   11 & 65.00 & 4.92 & 9.03 & 3.62 \\ 
#>   11 & 65.00 & 4.92 & 12.12 & 2.69 \\ 
#>   11 & 65.00 & 4.92 & 24.08 & 0.86 \\ 
#>   12 & 60.50 & 5.30 & 0.00 & 0.00 \\ 
#>   12 & 60.50 & 5.30 & 0.25 & 1.25 \\ 
#>   12 & 60.50 & 5.30 & 0.50 & 3.96 \\ 
#>   12 & 60.50 & 5.30 & 1.00 & 7.82 \\ 
#>   12 & 60.50 & 5.30 & 2.00 & 9.72 \\ 
#>   12 & 60.50 & 5.30 & 3.52 & 9.75 \\ 
#>   12 & 60.50 & 5.30 & 5.07 & 8.57 \\ 
#>   12 & 60.50 & 5.30 & 7.07 & 6.59 \\ 
#>   12 & 60.50 & 5.30 & 9.03 & 6.11 \\ 
#>   12 & 60.50 & 5.30 & 12.05 & 4.57 \\ 
#>   12 & 60.50 & 5.30 & 24.15 & 1.17 \\ 
#>   \hline
#> \end{longtable}
```

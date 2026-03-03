# Calculate basic statistics on data frame

This function creates a latex table or data frame with the basic
statistics of a data frame.

## Usage

``` r
stats_df(
  data,
  missingval = -999,
  ret = "tbl",
  capt = "Statistics data frame",
  align = "p{2cm}p{1cm}p{1cm}p{4cm}p{1.7cm}p{1.7cm}p{0.8cm}p{1.3cm}",
  size = "\\footnotesize",
  ...
)
```

## Arguments

- data:

  a data frame for which the overview should be created

- missingval:

  numeric with the value that indicates missing values, if NULL no
  missings will be recorded

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

either tex code for table a data frame

## Details

This function can be used to create a table with basic statistics of a
data frame. The function will list the min, max, number of NA/missing
values, number of unique categories and type of variable of all data
items within a data frame. In case a data item has less than 10 unique
categories, it will list the unique values. The main reason to use this
function is to create a structured table with statistics of a data frame
to be included in documentation.

## Author

Richard Hooijmaijers

## Examples

``` r
stats_df(Theoph)
#> \begingroup\footnotesize
#> \begin{longtable}{p{2cm}p{1cm}p{1cm}p{4cm}p{1.7cm}p{1.7cm}p{0.8cm}p{1.3cm}}
#> \caption{Statistics data frame} \\ 
#>   \toprule Variable & Min & Max & Categories & Nna & Nmiss & MaxChar & Type \\ 
#>   \midrule\endhead Subject &    1 &   12 & More than 10 cats (12) & 0 [0\%] & 0 [0\%] &   2 & ordered, factor \\ 
#>   Wt & 54.6 & 86.4 & More than 10 cats (11) & 0 [0\%] & 0 [0\%] &   4 & numeric \\ 
#>   Dose &  3.1 & 5.86 & 4.02 / 4.4 / 4.53 / 5.86 / 4 / 4.95 / 3.1 / 5.5 / 4.92 / 5.3 & 0 [0\%] & 0 [0\%] &   4 & numeric \\ 
#>   Time &    0 & 24.6 & More than 10 cats (78) & 0 [0\%] & 0 [0\%] &   5 & numeric \\ 
#>   conc &    0 & 11.4 & More than 10 cats (115) & 0 [0\%] & 0 [0\%] &   5 & numeric \\ 
#>   \hline
#> \end{longtable}
#> \endgroup
```

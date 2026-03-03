# export R data for NONMEM modeling

This function exports data for NONMEM modeling analyses including
options that are frequently necessary to adapt.

## Usage

``` r
output_data(
  x,
  csv = NULL,
  xpt = NULL,
  attr = NULL,
  verbose = TRUE,
  maxdig = 6,
  tonum = TRUE,
  firstesc = NULL,
  readonly = FALSE,
  overwrite = TRUE,
  ...
)
```

## Arguments

- x:

  data frame to be exported.

- csv:

  character with the name of the csv file to generate

- xpt:

  character with the name of the xpt file to generate

- attr:

  character with the name of the rds file to generate

- verbose:

  logical indicating if additional information should be written to the
  console

- maxdig:

  numeric with the maximum number of decimals for numeric variables to
  be in output (see details)

- tonum:

  logical indicating if all variables should be made numeric (standard
  for NONMEM input files)

- firstesc:

  character with escape character for first variable, used to exclude
  row in NONMEM

- readonly:

  logical indicating if the output csv file should be made readonly

- overwrite:

  logical indicating if (all) output should be overwritten or not

- ...:

  Arguments passed to
  [`write.csv`](https://rdrr.io/r/utils/write.table.html)

## Value

a data frame is written to disk

## Details

In case tonum is `TRUE`, all variables will be made numeric and `Inf`
values will be set to `NA` (all `NA` values will be set to a dot). The
rounding set in `maxdig` will only be done in case tonum is set to TRUE.
For xpt files, the name of the object to export is used as the name of
the dataset inside the xpt file (e.g.
`output_data(dfrm,xpt='dataset.xpt')` will result in an xpt file named
'dataset.xpt' with one dataset named 'dfrm').

## See also

[`write.csv`](https://rdrr.io/r/utils/write.table.html)

## Author

Richard Hooijmaijers

## Examples

``` r
if (FALSE) { # \dontrun{
  data(Theoph)
  out_file <- tempfile(fileext = ".csv")
  output_data(Theoph, csv = out_file, tonum = FALSE)
} # }
```

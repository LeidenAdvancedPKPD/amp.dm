# Create information for all functions that log actions

This function creates a table including information on functions that
log information such as `filterr`, `left_joinr` and `read_data`

## Usage

``` r
log_df(
  log,
  type,
  coding = FALSE,
  ret = "dfrm",
  capt = NULL,
  align = NULL,
  size = "\\footnotesize",
  ...
)
```

## Arguments

- log:

  list with logged information typically obtained with
  [get_log](https://leidenadvancedpkpd.github.io/amp.dm/reference/get_log.md)

- type:

  character with the type of info that should be taken from log (either
  "filterr_nfo","joinr_nfo" or "read_nfo")

- coding:

  logical indicating if the coding (within `filterr`) should be
  displayed

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

function creates a PDF file or returns a data frame

## Details

This function generates information for function that logs information.
It attempts to find a good alignment and caption, mainly for outputting
to a table. It is possible to set your own captions and alignment, take
into account that the alignment differs per type and in case the coding
argument is changed.

## Author

Richard Hooijmaijers

## Examples

``` r
dat1 <- filterr(Theoph,Subject==1)
#> ℹ Filter applied with 121 record(s) deleted
dat2 <- Theoph |> filterr(Subject==2)
#> ℹ Filter applied with 121 record(s) deleted
log_df(get_log(), "filterr_nfo")
#>   datain datainrows dataoutrows rowsdropped comment
#> 1 Theoph        132          11         121        
#> 2 Theoph        132          11         121        
```

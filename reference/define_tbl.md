# Create define PDF file for submission of pharmacometric data files

This function creates the define.pdf file necessary for esubmission.

## Usage

``` r
define_tbl(
  attr = NULL,
  ret = "dfrm",
  capt = "Dataset define form",
  align = "lp{3cm}lp{8cm}",
  outnm = NULL,
  orientation = "portrait",
  size = "\\footnotesize",
  src = NULL,
  ...
)
```

## Arguments

- attr:

  list with datasets attributes

- ret:

  a character vector to define what kind of output should be returned
  (either "dfrm", "tbl", "file")

- capt:

  character with the caption of the table

- align:

  alignment of the table passed to
  [general_tbl](https://leidenadvancedpkpd.github.io/amp.dm/reference/general_tbl.md)

- outnm:

  character with the name of the tex file to generate and compile (e.g.
  define.tex)

- orientation:

  character the page orientation in case a file is to be returned (can
  be either 'portrait' or 'landscape')

- size:

  character with font size as for the table
  [general_tbl](https://leidenadvancedpkpd.github.io/amp.dm/reference/general_tbl.md)

- src:

  object that holds information regarding the source (e.g.
  `get_log()$srce_nfo` ), if NULL an attempt is made to get it from the
  environment

- ...:

  additional arguments passed to
  [general_tbl](https://leidenadvancedpkpd.github.io/amp.dm/reference/general_tbl.md)

## Value

a data frame, code for table or nothing in case a PDF file is created

## Author

Richard Hooijmaijers

## Examples

``` r
if (FALSE) definePDF(attrl,outnm='define.tex') # \dontrun{}
```

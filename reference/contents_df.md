# Create information for multiple data frames

This function creates a latex table or data frame with the number of
records, subjects and variables of one or multiple data frames.

## Usage

``` r
contents_df(
  dfv,
  subject = NULL,
  ret = "tbl",
  capt = "Information multiple data frames",
  align = "lllp{8cm}",
  ...
)
```

## Arguments

- dfv:

  a character vector with data frame(s) in global environment for which
  the overview should be created

- subject:

  character string that identifies the subject variable within the data
  frame

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

- ...:

  additional arguments passed to
  [general_tbl](https://leidenadvancedpkpd.github.io/amp.dm/reference/general_tbl.md)

## Value

a data frame, code for table or nothing in case a PDF file is created

## Details

This function can be used to create a table with the most important
information of a data frame for documentation. The function will list
the the number of records, subjects and variables of each data frame
within dfv. This function is especially usable to indicate the
differences between similar data frames or an overview of all data
frames within a working environment

## Author

Richard Hooijmaijers

## Examples

``` r
data("Theoph")
Theoph2 <-  subset(Theoph,Subject==1)
contents_df(c('Theoph','Theoph2'),subject='Subject',ret='df')
#> Error in contents_df(c("Theoph", "Theoph2"), subject = "Subject", ret = "df"): Not all data frames could be found
```

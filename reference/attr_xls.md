# Reads in attributes from an external excel file

This function reads in attributes available in an excel file and creates
a structured list

## Usage

``` r
attr_xls(xls, sepfor = "\n", nosort = FALSE)
```

## Arguments

- xls:

  character with the name of the excel file containing the attributes

- sepfor:

  character of length 1 indicating what the separator for formats should
  be

- nosort:

  logical indicating if sorting of variables should be omitted
  (otherwise sorting of no. column in excel file is applied)

## Value

named list with the attributes

## Author

Richard Hooijmaijers

## Examples

``` r
if (FALSE) { # \dontrun{
  xmpl  <- system.file("example/Attr.Template.xlsx",package = "amp.dm")
  attr_xls(xmpl)
} # }
```

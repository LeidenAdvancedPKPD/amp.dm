# Extracts attributes from a data frame

This function extracts attributes available in a data frame and creates
a structured list

## Usage

``` r
attr_extract(dfrm)
```

## Arguments

- dfrm:

  data frame containing the attributes

## Value

named list with the attributes

## Author

Richard Hooijmaijers

## Examples

``` r
attrl  <- attr_xls(system.file("example/Attr.Template.xlsx",package = "amp.dm"))
nm     <- read.csv(system.file("example/NM.theoph.V1.csv",package = "amp.dm"))
nmf    <- attr_add(nm, attrl, verbose = FALSE)
attrl2 <- attr_extract(nmf)
all.equal(attrl,attrl2)
#> [1] TRUE
```

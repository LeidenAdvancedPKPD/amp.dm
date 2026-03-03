# Add attributes from a list to a dataframe

This function adds data attributes available in a list to a data frame.
Additional checks are done to verify if the attributes are in a valid
and use-able format

## Usage

``` r
attr_add(data, attrl, attrib = c("label", "format", "remark"), verbose = TRUE)
```

## Arguments

- data:

  the data frame for which the attributes should be set

- attrl:

  named list with the attributes for the dataset (see details)

- attrib:

  a vector of attributes that should be set for data (currently 'label',
  'format' and 'remark' are applicable)

- verbose:

  a logical indicating if datachecks should be printed to console

## Value

dataframe with the attributes added

## Details

This function adds attributes available in a list to a data frame. The
structure of this list should be available in a specific format. The
names items in the list are aligned with the variables in the data
frame. For each item, the content of the 'label', 'format' and 'remark'
elements will be added as attributes to the dataset. For an example of
the format of list see for instance
[attr_xls](https://leidenadvancedpkpd.github.io/amp.dm/reference/attr_xls.md).

## See also

[attr_xls](https://leidenadvancedpkpd.github.io/amp.dm/reference/attr_xls.md)

## Author

Richard Hooijmaijers

## Examples

``` r
if (FALSE) { # \dontrun{
 xmpl   <- system.file("example/Attr.Template.xlsx",package = "amp.dm")
 attrl  <- attr_xls(xmpl)
 data   <- read.csv(system.file("example/NM.theoph.V1.csv",package = "amp.dm"), na.strings = ".")
 attr_add(data2,attrl)
} # }
```

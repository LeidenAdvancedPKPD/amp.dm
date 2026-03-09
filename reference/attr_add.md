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
xmpl   <- system.file("example/Attr.Template.xlsx",package = "amp.dm")
attrl  <- attr_xls(xmpl)
data   <- read.csv(system.file("example/NM.theoph.V1.csv",package = "amp.dm"), na.strings = ".")
attr_add(data,attrl) |> str()
#> ! Labels detected with > 24 characters (possible issue for reporting): Unique subject identifier, Time after first dose (h), Concentration Theoph (ng/mL), and Flag for type of PK record
#> ✖ The following variables have more categories than defined in attribute list: TRT
#> 'data.frame':    288 obs. of  19 variables:
#>  $ STUDYID: int  1 1 1 1 1 1 1 1 1 1 ...
#>   ..- attr(*, "label")= chr "Study identifier"
#>   ..- attr(*, "unit")= chr ""
#>  $ ID     : int  1 1 1 1 1 1 1 1 1 1 ...
#>   ..- attr(*, "label")= chr "Unique subject identifier"
#>   ..- attr(*, "unit")= chr ""
#>  $ TRT    : int  2 2 2 2 2 2 2 2 2 2 ...
#>   ..- attr(*, "label")= chr "Treatment arm"
#>   ..- attr(*, "unit")= chr ""
#>   ..- attr(*, "format")= Named chr [1:2] "300 mg theoph form 1" "300 mg theoph form 2"
#>   .. ..- attr(*, "names")= chr [1:2] "1" "2"
#>  $ CMT    : int  2 1 2 2 2 2 2 2 2 2 ...
#>   ..- attr(*, "label")= chr "Compartment"
#>   ..- attr(*, "unit")= chr ""
#>   ..- attr(*, "format")= Named chr [1:2] "Dosing compartment" "Central compartment"
#>   .. ..- attr(*, "names")= chr [1:2] "1" "2"
#>  $ AMT    : int  NA 300 NA NA NA NA NA NA NA NA ...
#>   ..- attr(*, "label")= chr "Amount administered (mg)"
#>   ..- attr(*, "unit")= chr "mg"
#>   ..- attr(*, "remark")= chr "Original dose units set to mg"
#>  $ STIME  : num  0 0 0.25 0.5 1 2 3.5 5 7 9 ...
#>   ..- attr(*, "label")= chr "Scheduled time (h)"
#>   ..- attr(*, "unit")= chr "h"
#>  $ TIME   : num  0 0.5 0.77 1.08 1.65 2.53 4.07 5.5 7.5 9.72 ...
#>   ..- attr(*, "label")= chr "Time (h)"
#>   ..- attr(*, "unit")= chr "h"
#>  $ TAFD   : num  -0.5 0 0.27 0.58 1.15 2.03 3.57 5 7 9.22 ...
#>   ..- attr(*, "label")= chr "Time after first dose (h)"
#>   ..- attr(*, "unit")= chr "h"
#>  $ TALD   : num  -0.5 0 0.27 0.58 1.15 2.03 3.57 5 7 9.22 ...
#>   ..- attr(*, "label")= chr "Time after last dose (h)"
#>   ..- attr(*, "unit")= chr "h"
#>  $ DV     : num  0 NA 1.29 3.08 6.44 6.32 5.53 4.94 4.02 3.46 ...
#>   ..- attr(*, "label")= chr "Concentration Theoph (ng/mL)"
#>   ..- attr(*, "unit")= chr "ng/mL"
#>  $ EVID   : int  0 1 0 0 0 0 0 0 0 0 ...
#>   ..- attr(*, "label")= chr "Event ID"
#>   ..- attr(*, "unit")= chr ""
#>   ..- attr(*, "format")= Named chr [1:2] "Observations" "Dosing event"
#>   .. ..- attr(*, "names")= chr [1:2] "0" "1"
#>  $ MDV    : int  1 1 0 0 0 0 0 0 0 0 ...
#>   ..- attr(*, "label")= chr "missing DV"
#>   ..- attr(*, "unit")= chr ""
#>   ..- attr(*, "format")= Named chr [1:2] "Other" "Dose records and missing observations"
#>   .. ..- attr(*, "names")= chr [1:2] "0" "1"
#>  $ CNTRY  : int  3 3 3 3 3 3 3 3 3 3 ...
#>   ..- attr(*, "label")= chr "Country"
#>   ..- attr(*, "unit")= chr ""
#>   ..- attr(*, "format")= Named chr [1:4] "BEL" "FRA" "GER" "NED"
#>   .. ..- attr(*, "names")= chr [1:4] "1" "2" "3" "4"
#>  $ SEX    : int  1 1 1 1 1 1 1 1 1 1 ...
#>   ..- attr(*, "label")= chr "Gender"
#>   ..- attr(*, "unit")= chr ""
#>   ..- attr(*, "format")= Named chr [1:2] "Male" "Female"
#>   .. ..- attr(*, "names")= chr [1:2] "0" "1"
#>  $ AGE    : int  60 60 60 60 60 60 60 60 60 60 ...
#>   ..- attr(*, "label")= chr "Age (y)"
#>   ..- attr(*, "unit")= chr "y"
#>  $ WEIGHT : num  80 80 80 80 80 80 80 80 80 80 ...
#>   ..- attr(*, "label")= chr "Weight  (kg)"
#>   ..- attr(*, "unit")= chr "kg"
#>  $ HEIGHT : num  1.88 1.88 1.88 1.88 1.88 1.88 1.88 1.88 1.88 1.88 ...
#>   ..- attr(*, "label")= chr "Height  (m)"
#>   ..- attr(*, "unit")= chr "m"
#>  $ BMI    : num  22.6 22.6 22.6 22.6 22.6 ...
#>   ..- attr(*, "label")= chr "Body mass index (kg/m2)"
#>   ..- attr(*, "unit")= chr "kg/m2"
#>  $ FLAGPK : int  2 NA 3 3 3 3 3 3 3 3 ...
#>   ..- attr(*, "label")= chr "Flag for type of PK record"
#>   ..- attr(*, "unit")= chr ""
#>   ..- attr(*, "format")= Named chr [1:3] "Missing PK" "PK below LOQ" "Valid PK sample"
#>   .. ..- attr(*, "names")= chr [1:3] "1" "2" "3"
```

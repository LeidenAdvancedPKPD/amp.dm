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
xmpl   <- system.file("example/Attr.Template.xlsx",package = "amp.dm")
attrl  <- attr_xls(xmpl)
define_tbl(attrl)
#>         Data.Item                Description  Unit
#> STUDYID   STUDYID           Study identifier     -
#> ID             ID  Unique subject identifier     -
#> TRT           TRT              Treatment arm     -
#> CMT           CMT                Compartment     -
#> AMT           AMT        Amount administered    mg
#> STIME       STIME             Scheduled time     h
#> TIME         TIME                       Time     h
#> TAFD         TAFD      Time after first dose     h
#> TALD         TALD       Time after last dose     h
#> DV             DV       Concentration Theoph ng/mL
#> EVID         EVID                   Event ID     -
#> MDV           MDV                 missing DV     -
#> CNTRY       CNTRY                    Country     -
#> SEX           SEX                     Gender     -
#> AGE           AGE                        Age     y
#> WEIGHT     WEIGHT                     Weight    kg
#> HEIGHT     HEIGHT                     Height     m
#> BMI           BMI            Body mass index kg/m2
#> FLAGPK     FLAGPK Flag for type of PK record     -
#>                                                         Remark
#> STUDYID                                                      -
#> ID                                                           -
#> TRT         1 = 300 mg theoph form 1, 2 = 300 mg theoph form 2
#> CMT            1 = Dosing compartment, 2 = Central compartment
#> AMT                             Original dose units set to mg 
#> STIME                                                        -
#> TIME                                                         -
#> TAFD                                                         -
#> TALD                                                         -
#> DV                                                           -
#> EVID                        0 = Observations, 1 = Dosing event
#> MDV       0 = Other, 1 = Dose records and missing observations
#> CNTRY                       1 = BEL, 2 = FRA, 3 = GER, 4 = NED
#> SEX                                       0 = Male, 1 = Female
#> AGE                                                          -
#> WEIGHT                                                       -
#> HEIGHT                                                       -
#> BMI                                                          -
#> FLAGPK   1 = Missing PK, 2 = PK below LOQ, 3 = Valid PK sample
```

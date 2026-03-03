# Add source information to environment to present in documentation

Adds the source of variables into package environment, which can be used
in code chunks at the applicable locations and easily added to
documentation afterwards

## Usage

``` r
srce(var, source, type = "c")
```

## Arguments

- var:

  unquoted string with the variable for which the source should be
  defined

- source:

  unquoted strings with the source(s) used for var (see example)

- type:

  character with the type of variable can be either 'c' (copied) or 'd'
  (derived)

## Value

no return value, called for side effects

## Author

Richard Hooijmaijers

## Examples

``` r
  # variable AMT copied from Dose variable in Theoph data frame
  srce(AMT,Theoph.Dose)
  # variable BMI derived from WEIGHT variable in wt data frame
  # and HEIGHT variable in ht data frame
  srce(BMI,c(wt.WEIGHT,ht.HEIGHT),'d')
  get_log()$srce_nfo
#>   variable type               source
#> 1      AMT    c          Theoph.Dose
#> 2      BMI    d wt.WEIGHT, ht.HEIGHT
```

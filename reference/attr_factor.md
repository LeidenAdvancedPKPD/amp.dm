# Create factors for variables within a data frame using the format attribute

This function searches for the 'format' attribute within a data frame,
if found it applies the format to that variable. The resulting variable
will be a factor useful for plotting and reporting

## Usage

``` r
attr_factor(data, verbose = TRUE, largestfirst = FALSE)
```

## Arguments

- data:

  the data.frame for which factors should be created

- verbose:

  a logical indicating if datachecks should be printed to console

- largestfirst:

  either a logical or a character vector indicating if the largest group
  should be the first level (see details)

## Value

data frame with the formats assigned

## Details

In order to make this function work the 'format' attribute should be
present and should be available as a named vector (e.g.
`attr(data$GENDER,'format') <- c('0' = 'Male', '1' = 'Female')`). If the
attribute is found it overwrites the variable with the format applied to
it. Be aware that the original levels defined in the format could be
lost in this process. The 'largestfirst' argument could be set to a
logical which indicates if a for all variables in the dataset, the
largest group should be the first level. The argument could also be a
character vector indicating for which of the variables in the dataset,
the largest group should be the first level. In case you want to set a
specific order, this can be done directly in the the format attribute,
e.g. `attr(data$VAR,'format') <- c('2' = 'level 1', '1' = 'Level 2')`

## See also

[factor](https://rdrr.io/r/base/factor.html),
[attr_add](https://leidenadvancedpkpd.github.io/amp.dm/reference/attr_add.md),
[attr_xls](https://leidenadvancedpkpd.github.io/amp.dm/reference/attr_xls.md)

## Author

Richard Hooijmaijers

## Examples

``` r
dfrm <- data.frame(GENDER=rep(c(0,1),4),RESULT=rnorm(8))
attr(dfrm$GENDER,'format')   <- c('0' = 'Male', '1' = 'Female')
dfrm <- attr_factor(dfrm)
str(dfrm$GENDER)
#>  Factor w/ 2 levels "Male","Female": 1 2 1 2 1 2 1 2
```

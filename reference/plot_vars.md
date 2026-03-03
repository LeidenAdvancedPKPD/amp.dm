# Creates different kind of plots for variables within a dataset using ggplot2

This function creates histograms for numeric values and barcharts for
character or factor variables In case there are more then 10 unique
values it will list the first 10 unique values in a 'text' plot

## Usage

``` r
plot_vars(dfrm, vars = names(dfrm), ppp = 16, ...)
```

## Arguments

- dfrm:

  data frame that should be plotted

- vars:

  character vector with the variables for which plots should be
  generated

- ppp:

  number plots per page

- ...:

  additional arguments passed to
  [`patchwork::wrap_plots()`](https://patchwork.data-imaginist.com/reference/wrap_plots.html)
  (e.g. ncol/nrow)

## Value

a ggplot/patchwork object with all variables plotted visualized

## Author

Richard Hooijmaijers

## Examples

``` r
plot_vars(Theoph)
#> $`1`
#> `stat_bin()` using `bins = 30`. Pick better value `binwidth`.
#> `stat_bin()` using `bins = 30`. Pick better value `binwidth`.
#> `stat_bin()` using `bins = 30`. Pick better value `binwidth`.
#> `stat_bin()` using `bins = 30`. Pick better value `binwidth`.

#> 
```

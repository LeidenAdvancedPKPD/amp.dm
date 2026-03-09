# Perform a left join of two data frames with logging of results

This function is a wrapper around
[dplyr::left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html).
Additional actions are performed on the background to log the
information of the join action, and info regarding the step is printed.

## Usage

``` r
left_joinr(x, y, by = NULL, ..., comment = "", keepids = FALSE)
```

## Arguments

- x, y:

  a pair of data frames used for joining

- by:

  character vector of variables to join by

- ...:

  additional arguments passed to
  [dplyr::left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)

- comment:

  information for the reason of merging

- keepids:

  logical indicating if merge identifiers should be available in output
  data (for checking purposes)

## Value

a joined data frame

## Details

The function can be used to keep track of records that are available
after a join in the data management process. Joining of data could lead
to unexpected results, e.g. creation of cartesian product or loosing
data. Therefore it is important to know what the result of a join step
is. Every time the function is used it creates a records in in a log
file which can be used in the documentation.

## See also

[dplyr::left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)

## Author

Richard Hooijmaijers

## Examples

``` r
dose  <- data.frame(Subject = unique(Theoph$Subject),
                    dose = sample(1:3,length(unique(Theoph$Subject)),
                                  replace = TRUE))
dose2 <- dose[dose$Subject%in%1:6,]
# Preferred to explicitly list by
dat1 <- left_joinr(Theoph, dose, by="Subject")
#> ℹ Output data contains 132 records
#> ℹ Theoph contained 132 records
#> ℹ dose contained 12 records
# The base R pipe is preferred for better logging of source data
dat2 <- Theoph |> left_joinr(dose, by="Subject")
#> ℹ Output data contains 132 records
#> ℹ Theoph contained 132 records
#> ℹ dose contained 12 records
# Avoid long pipes before function for readability in log. e.g dont:
dat3 <- Theoph |> dplyr::mutate(ID=3) |> dplyr::bind_cols(X=3) |> 
  left_joinr(dose, by="Subject")
#> ℹ Output data contains 132 records
#> ℹ dplyr::bind_cols(dplyr::mutate(Theoph, ID = 3), X = 3) contained 132 records
#> ℹ dose contained 12 records
# Show what is being logged
get_log()$joinr_nfo
#>                                                  datainl datainr
#> 1                                                 Theoph    dose
#> 2 dplyr::bind_cols(dplyr::mutate(Theoph, ID = 3), X = 3)    dose
#>   datainrowsl datainrowsr dataoutrowsl dataoutrows comment
#> 1         132          12            0         132        
#> 2         132          12            0         132        
```

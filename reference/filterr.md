# Filter data with logging of results

This function is a wrapper around
[dplyr::filter](https://dplyr.tidyverse.org/reference/filter.html).
Additional actions are performed on the background to log the
information of the filter action, and info regarding the step is
printed.

## Usage

``` r
filterr(.data, ..., comment = "")
```

## Arguments

- .data:

  the data frame for which the filter should be created

- ...:

  arguments passed to
  [dplyr::filter](https://dplyr.tidyverse.org/reference/filter.html)

- comment:

  character with the reason of filtering used in log file

## Value

a filtered data frame

## Details

The function can be used to keep track of records that are omitted in
the data management process. In general one would like to keep all
records from the source database (and use flags instead to exclude data)
but in cases where this is not possible it is important to know what
records are omitted and for which reason. Every time the function is
used it creates a records in in a log file which can be used in the
documentation.

## See also

[dplyr::filter](https://dplyr.tidyverse.org/reference/filter.html)

## Author

Richard Hooijmaijers

## Examples

``` r
# For full trace-ability of source data, no pipes or 
# base R pipes are preferred 
if (FALSE) { # \dontrun{
  dat1 <- filterr(Theoph,Subject==1)
  dat2 <- Theoph |> filterr(Subject==2)
  dat3 <- Theoph %>% filterr(Subject==3)
  # Show what is being logged
  get_log()$filterr_nfo
} # }
```

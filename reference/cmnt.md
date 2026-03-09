# Add comment to environment to present in documentation

Adds a comment regarding assumptions and special attention into package
environment, which can be used in code chunks and easily printed after a
code chunk

## Usage

``` r
cmnt(string = "", bold = FALSE, verbose = TRUE)
```

## Arguments

- string:

  character of length one with the comment to add

- bold:

  logical indicating if the string should be printed in bold to
  emphasize importance

- verbose:

  logical indicating if the comment should be printed when function is
  called

## Value

no return value, called for side effects

## Author

Richard Hooijmaijers

## Examples

``` r
cmnt("Exclude time points > 12h")
#> ℹ Exclude time points > 12h
cmnt("Subject 6 deviates and is excluded in the analysis", TRUE)
#> ℹ Subject 6 deviates and is excluded in the analysis
# Markdown syntax can be used for comments:
cmnt("We can use **bold** and *italic* or `code`")
#> ℹ We can use **bold** and *italic* or `code`
# we can print the contents of the comments with
get_log()$cmnt_nfo
#>                                               string  bold
#> 1                          Exclude time points > 12h FALSE
#> 2 Subject 6 deviates and is excluded in the analysis  TRUE
#> 3         We can use **bold** and *italic* or `code` FALSE
```

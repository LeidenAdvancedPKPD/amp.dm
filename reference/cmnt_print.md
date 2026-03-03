# Function that prints the comments given by [cmnt](https://leidenadvancedpkpd.github.io/amp.dm/reference/cmnt.md)

Prints the results in markdown format to be used directly in inline
coding

## Usage

``` r
cmnt_print(clean = TRUE)
```

## Arguments

- clean:

  logical indicating if the comments should be deleted after printing
  (see details)

## Value

character string with the comments

## Details

The function returns a text string with the comments given up to the
point it was called. When clean is set to TRUE (default), the content of
the comment dataset is cleaned to overcome repetition of comments each
time it is called

## Author

Richard Hooijmaijers

## Examples

``` r
  cmnt("Comment to print")
#> ℹ Comment to print
  cmnt_print()
#> [1] "Assumptions and special attention:\n\n- Exclude time points > 12h\n- **Subject 6 deviates and is excluded in the analysis**\n- We can use **bold** and *italic* or `code`\n- Comment to print\n\n"
```

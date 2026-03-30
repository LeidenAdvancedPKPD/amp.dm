# Sets the read-only attribute for all files available within a folder

This function will change the file attributes so only read access is set

## Usage

``` r
make_readonly(x)
```

## Arguments

- x:

  character of length 1 with the path that contains files or character
  vector with filenames to be set to read-only

## Value

nothing is returned, only system commands are issued

## Details

This function will attempt to set a read-only attributes on files. This
is either done through system commands such as `attrib` for windows and
`chmod` for linux (444). With the latter take into account possible
issues with (sudo) rights on files. In case x is a directory, the
function will set readonly attribute for all files in the folder (and
recurse into all subfolders!).

## Author

Richard Hooijmaijers

## Examples

``` r
if (FALSE) { # \dontrun{
  tmpf <- tempfile(fileext = ".txt")
  cat("test",file=tmpf)
  make_readonly(tmpf)   
} # }
```

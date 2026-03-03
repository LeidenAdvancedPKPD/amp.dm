# read external data with logging of results

This function reads external data with support for file types that are
most commonly used in clinical and pre-clinical data, and provide manual
functions for less common types

## Usage

``` r
read_data(
  file,
  manfunc = NULL,
  comment = "",
  verbose = TRUE,
  ascii_check = "xls",
  ...
)
```

## Arguments

- file:

  character with the name of the file to read (see details for more
  information)

- manfunc:

  character with the manual function to use to read data (can have the
  form "package::function")

- comment:

  character with comment/information for the data that was read-in

- verbose:

  logical indicating if information regarding the data that is read is
  printed in console

- ascii_check:

  character of length one defining if the data that has been read in
  should be checked for valid ASCII characters (see details)

- ...:

  Additional arguments passed to the read data functions. This can be
  used to add arguments to for instance read.table or read_excel or for
  the function defined in manfunc

## Value

data frame containing a representation of the data in the file

## Details

The function reads in data, and uses the file extension to select the
applicable function for reading. Below is a list of extensions that are
recognized and the corresponding function that is used to read the data:

- sas7bdat:
  [haven::read_sas](https://haven.tidyverse.org/reference/read_sas.html)

- xpt:
  [haven::read_xpt](https://haven.tidyverse.org/reference/read_xpt.html)

- xls/xlsx:
  [readxl::read_excel](https://readxl.tidyverse.org/reference/read_excel.html)

- prn/par: [read.table](https://rdrr.io/r/utils/read.table.html)

- csv: [read.csv](https://rdrr.io/r/utils/read.table.html)

The prn and par file formats are basically space delimited files but
with some specifics for modeling software (e.g. prn is NONMEM input file
with header starting with '#' and par is NONMEM output file as defined
in \$TABLE). This function can be used to read any type of data by using
the manfunc argument. Any function available in R can be used here and
even user written functions (see example section). This argument has
precedence over the recognition of extensions. This means for instance
that a CSV file can also be read-in using a different function (e.g.
using `data.table::fread`). This flexibility is build in to ensure all
possible data can be read in using this single function. This is mainly
important for documentation purposes, to ensure all used data can be
logged and documented. The data can be checked for valid ASCII
characters using the "ascii_check" argument. By default this is done for
excel files with extension xls or xlsx (ascii_check="xls") other options
are "none" to never perform a check or "all" to perform a check
regardless of the way it is read in. The default is chosen as it is
likely that excel files are created manually and could therefore include
non ASCII characters, and because it puts additional overhead on
function otherwise.

## Author

Richard Hooijmaijers

## Examples

``` r
if (FALSE) { # \dontrun{

# For a known filetype you can use:
dat <- read_data(paste0(R.home(),"/doc/CRAN_mirrors.csv"))

# We can use the arguments from the underlying package that does the reading
dat <- read_data("test1.xlsx", range="A2:B3")

# In case we get a file format not directly supported by the function
# we can use the manfunc to use another function
sav <- system.file("files", "electric.sav", package = "foreign")
dat <- read_data(sav,manfunc = "foreign::read.spss")

# It is also possible to write your own function that reads data (e.g from a PDF file):
read_pdf <- function(file){
  ret     <- pdftools::pdf_data(file)[[1]]
  ret$seq <- rep(1:2,each=(nrow(ret)/2))
  ret     <- tidyr::pivot_wider(ret,names_from = seq, values_from=text,id_cols=y,names_prefix="V")
  ret     <- as.data.frame(ret[-1,names(ret)!="y"])
  ret
}
# This function can then directly be used by read_data
dat <- read_data("test1.pdf",manfunc = "read_pdf")
} # }
```

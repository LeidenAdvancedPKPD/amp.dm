<!-- badges: start -->
[![Codecov test coverage](https://codecov.io/gh/LeidenAdvancedPKPD/amp.dm/graph/badge.svg)](https://app.codecov.io/gh/LeidenAdvancedPKPD/amp.dm)
<!-- badges: end -->

# Introduction <img src="man/figures/logo.png" align="right" alt="" width="120" />

The aim of this package is to ease or **amp**lify the process of creating datasets mainly for pharmacometric analyses. 
The package contains functions to create NONMEM specific variables, perform various times calculations and 
help in creating dosing records. Finally, multiple functions are present for documentation and QC purposes.

The latest version can be installed using:

`devtools::install_github("LeidenAdvancedPKPD/amp.dm")`

The article section should get you started. Within this section there is also a PDF that 
represents a study example, and include code for the main functionality of the package. 
This [example](vignettes/example_study.qmd) can also be used as a starting point or template for new studies.

This package was initially developed as an in-house package at LAP&P. Various versions were developed, where many people within
LAP&P helped in making the package better and more robust. Without them this package wouldn't be possible!  

# Other packages

There are many packages for general data management like everything in `tidyverse` and more specific for data 
management within pharma like `pharmaverse`.

This package is more specific for pharmacometric datasets which require some specific functionality. 
Related to these type of datasets there is the [`NMdata`](https://nmautoverse.github.io/NMdata/) package.
The main difference with this package is that `NMdata` has quite some functionality for reading NONMEM results.
This package is more focused towards data creation, meta data and documentation.

The [`yspec`](https://metrumresearchgroup.github.io/yspec/) and [`yamlet`](https://cran.r-project.org/web/packages/yamlet/index.html)
packages are mainly build for handling meta data, while this package combines handles meta data differently and 
combines this in the 'documented' workflow.

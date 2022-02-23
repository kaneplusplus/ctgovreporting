
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ctgovreporting

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install the development version of ctgovreporting from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("kaneplusplus/ctgovreporting")
```

## Example

``` r
library(ctgovreporting)
library(sf)
#> Linking to GEOS 3.10.2, GDAL 3.4.1, PROJ 8.2.1; sf_use_s2() is TRUE
library(ggplot2)
data(ct_county)
ggplot(ct_county, aes()) +
  geom_sf() +
  theme_bw()
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r
## basic example code
```

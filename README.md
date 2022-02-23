
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
library(ggplot2)
data(ct_county)
ggplot(ct_county, aes()) +
  geom_sf() +
  theme_bw()
```

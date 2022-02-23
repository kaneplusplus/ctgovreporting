library(dplyr)
library(sf)

test_that("county_chloro works.", {
  data(ctpopest19)

  p <- ctpopest19 %>%
    rename(county = County) %>%
    mutate(county = gsub(" County$", "", county)) %>%
    county_chloro(fill_col = "Population")

  expect_true(inherits(p, "gg"))

  expect_error(county_chloro(ctpopest19))

})


#' @title Create a Map for Counties of CT
#'
#' @description Plot values for counties of CT
#' @param x is a data.frame or tibble with a county column and a value
#' column to plot.
#' @param fill_col the variable having the `fill` values. Default is "value".
#' @examples
#' library(dplyr)
#' library(sf)
#' data(ctpopest19)
#' ctpopest19 %>%
#'   rename(county = County) %>%
#'   mutate(county = gsub(" County$", "", county)) %>%
#'   county_chloro(fill_col = "Population")
#' @return A map of CT county plotting values in the `value` column
#' @importFrom dplyr select rename full_join
#' @importFrom ggplot2 ggplot geom_sf aes_string
#' @export
county_chloro <- function(x, fill_col = "value") {
  data(ct_county)
  ctc <- ct_county %>%
    select(geometry, NAME) %>%
    rename(county = NAME)
  jd <- full_join(ctc, x, by = "county")
  ggplot(jd, aes_string(fill = fill_col)) +
    geom_sf()
}

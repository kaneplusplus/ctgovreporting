library(sf)

ct_towns <- read_sf(file.path("shape_files", "cb_2017_09_cousub_500k.shp"))
use_data(ct_towns, overwrite = TRUE)

ct_county <- read_sf(
  file.path(
    "shape_files",
    "countyct_37800_0000_1990_s100_CENSUS_1_shp_wgs84.shp"
    )
  )
use_data(ct_county, overwrite = TRUE)

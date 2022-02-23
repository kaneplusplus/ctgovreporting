library(readr)
library(usethis)
library(dplyr)

popest19 <- read_csv("pop-est-2019.csv")

use_data(popest19, overwrite = TRUE)

ctpopest19 <- popest19 %>%
  filter(State == "Connecticut")

use_data(ctpopest19, overwrite = TRUE)

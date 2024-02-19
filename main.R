library(dplyr)

mtcars %>%
  distinct(cyl, mpg)

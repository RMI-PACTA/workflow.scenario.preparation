library(tidyverse)

mtcars %>%
  distinct(cyl, mpg)

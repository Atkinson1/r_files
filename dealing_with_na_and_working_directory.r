# if you can't find your working directory in the files tab, ...
library(tidyverse)

setwd("C:/Users/ryan/desktop/personal/r/r for data science lesson plan")
getwd()

                      # working with NAs

# na.omit()
# replace_na()
# is.na()

z <- tribble(~x, ~y,
             1, 2,
             3, 4,
             5, NA)

na.omit(z) # remove NA and its row
is.na(z) # checking for na with is.na()


          # replace_na() for vector or tibble

# replace_na() on a tibble/data.frame for some set of columns
# FORM: replace_na(z, list(x = 0, y = 0, ...))
replace_na(z, list(y = 0))

# replace_na() on a vector
z[2] <- replace_na(z$y, 0)

# replace na() across a whole data.frame/tibble
z1 <- tribble(~x, ~y,
              1, 2,
              NA, 4,
              5, NA)

            # Getting rid of all NA from dataset steps

# is.na tests for whether it's true or not that an NA exists;
z1[is.na(z1)]

# assigning 0 replaces all instances of NA that are not true
z1[is.na(z1)] <- 0 # Dealing with NA and working directory






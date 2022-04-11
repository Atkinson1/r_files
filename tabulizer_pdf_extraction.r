install.packages("tabulizer")
install.packages("rJava")
library(rJava)
library(tabulizer)
library(tidyverse)
library(janitor)

# https://www.business-science.io/code-tools/2019/09/23/tabulizer-pdf-scraping.html

# ?pluck()
# 
# 
# remotes::install_github(c("ropensci/tabulizerjars", "ropensci/tabulizer"), INSTALL_opts = "--no-multiarch")
# 

?pluck
?pull

x <- rnorm(10, 0, 1)
pluck(x, 4)

x2 <- as_tibble(x)
pluck(x2, 1, 4)


endangered_scrape <- extract_tables(file = "C:/users/ryan/desktop/endangered_species.pdf",
                                    method = "decide",
                                    output = "data.frame")

es_raw <- endangered_scrape[[1]] %>% as_tibble()
es_raw <- es_raw %>% row_to_names(1)








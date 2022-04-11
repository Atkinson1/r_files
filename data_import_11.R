https://r4ds.had.co.nz/data-import.html

#tip: use write_rds() when writing data after doing operations





challenge <- read_csv(readr_example("challenge.csv"))
# use head() & tail() functions to analyze challenge dataset
head(challenge, n = 10)
tail(challenge, n = 10)

# indicates that our issue is with the y column

# use problems to bring up the specific set of parsing issues
problems(challenge)

# to fix, take column specifications used in import, and change them
# to match what the data col should actually be parsed to

# to do so, set col_types = cols(); col_types is the argument, 
# cols() contains the col name and what function to apply to it
challenge2 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(
                         x = col_double(),
                         y = col_date()
                       )
)

head(challenge2)
sum(is.na(challenge2$y))

# parsing based on potential number of inputs; default guess is 1000
challenge3 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)






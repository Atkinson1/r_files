# https://www.geeksforgeeks.org/time-series-analysis-in-r/?ref=leftbar-rightbar

# time series analysis
library(tidyverse)
library(lubridate)


x <- c(580, 7813, 28266, 59287, 75700,
       87820, 95314, 126214, 218843, 471497,
       936851, 1508725, 2072113)

mts <- ts(x, start = decimal_date(ymd("2020-01-22")),
          frequency = 365.25 / 7)



x <- nycflights13::flights
x2 <- x %>% mutate(new_col = row_number())


flight_ts <- ts(x2$dep_delay, start = c(2013, 1), frequency = 365)

plot(flight_ts)

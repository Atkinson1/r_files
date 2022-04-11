    # Note: Context dependent expressions - only work inside contexts like summarise() and mutate()
        # n()

library(tidyverse)                  
library(nycflights13) # flights departing NYC in 2013
setwd("C:/Users/ryan/desktop/r_lesson_plan")

# Setting conditions for further operations in script
flights <- nycflights13::flights


not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))


delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

                        #################

# quick shortcut for counts:

# unique & n_distinct to analyze data outside of a summarize() function; can also be used inside of one
flights %>% count(carrier) # gives the count of flights by carrier
unique(flights$carrier) # gives list of distinct carriers
n_distinct(flights$carrier) # gives number of distinct carriers (16)

                        #################

                  # logs()

log()
log2() # ex: log2(16) = 4
log10()

# Find the "previous" (lag()) or "next" (lead()) values in a vector.
lag() # finds previous value
lead() # finds following value

x <- seq(1, 10)
lag(x)
lead(x)

# sums, products, minimums, maximums
cumsum(x) # keeps adding numbers based on value at index
cumprod(x)# multiplies numbers based on value at index

cummean(x)
cummin(x)
cummax(x)

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y) # order based on min
min_rank(desc(y)) # 

ntile(y, 2) # gives 2 quantiles 

percent_rank(y)
#> [1] 0.00 0.25 0.25   NA 0.75 1.00
cume_dist(y)
#> [1] 0.2 0.6 0.6  NA 0.8 1.0

          # statistics
z <- tribble(~x, ~y,
             1, 2,
             3, 4,
             5, 6,
             7, 8,
             9, 10)

# mean
mean(z$x)
mean(z$y)
z %>% mutate(avg = (x + y))
# median
median(z$x)

      # measures of spread

sd(z$x)
IQR(z$x) 
# median absolute deviation
mad(z$x)

      # measures of rank
min(z$x)
quantile(z$x, .1) # takes quantile of some variable (%) and gives the value at that quantile
max(z$x)

# When do the first and last flights leave each day?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

      # measures of position
first(x)
nth(x, n)
last(x)

# These work similarly to x[1], x[2], and x[length(x)] 
# but let you set a default value if that position does not exist
nth(delays, 2) # takes all values in second row
nth(delays$delay, 2) # takes second element in delays
        # equivalent to:
delays[2, 2]

delays[length(delays)] # gives n based on the length of the df, which in this case is 3 (the "n" column)
delays

# Filtering gives you all variables, with each observation in a separate row:

not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% # ranks based on year/month/day; in desc, puts top value at the top
  filter(r %in% range(r)) %>% # range() gives min and max in r, the newly created column
  select(year:day, r)

          # Counts
sum(!is.na(x)) # -- checks for those that aren't missing, adds it up
n_distinct(x) # -- gives number of unique values or instances some value appears

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

not_cancelled %>% count(dest) # takes not cancelled flights, counts up based on dest
not_cancelled %>% count(month) # counts values for the month

       # count with weight argument

not_cancelled %>% 
  count(tailnum, wt = distance)

# example of weight with df
df <- tribble(
  ~name,    ~gender,   ~runs,
  "Max",    "male",       10,
  "Sandra", "female",      1,
  "Susan",  "female",      4
)
# counts rows:
df %>% count(gender)
# counts runs:
df %>% count(gender, wt = runs) # weight is way to group based on some other variable
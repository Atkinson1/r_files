setwd("C:/users/ryan/desktop/r_lesson_plan")

library(lubridate)
library(nycflights13)
library(tidyverse)

# date-time: date plus a time; printed by tibble as <dttm>; else as POSIXct
# time: printed as <time>
# date: printed as <date>

today() # gets date
now() # gets date-time

  # 3 ways to create a date/time from:
    
# a string;
# individual date-time components
# an existing date/time object


        # 16.2.1 From Strings

# Identify order in which year, month, and day appear in your dates;
  # then, arrange "y", "m", and "d" in the same order

mdy("Jan-31st-2019") # will arrange output in year, month, date order
ymd(20170329)

  # to create date-time, use _ with "h", "m", or "s" after
mdy_h("03092018 02") # must be h, hm, or hms in that order for granularity
mdy_hm("03/09/2018 02/08") # doesn't work without quotes

mdy_hms("03/04:2016 02/08-02") 

# either forward-slash, colon, or dash will work between values

        # 16.6.2 From individual components

date_time <- flights %>% select(year, month, day, hour, minute)
date_time

# make_date() for dates
# make_datetime() for date-times

mutate(date_time, departure = make_datetime(year, month, day, hour, minute))

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}


flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt

# how mutate above is working;
# it's saying use make_datetime_100 function;
# take input from year, month, day, and dep_time;
# dep_time will be used twice, first as time %/% 100
# seconas time %% 100

head(flights$dep_time, 10) # a vector of hours/min, as 517, 533, 542, 544, etc.

517 %/% 100 # integer division; how many times a whole number can go into another
517 %% 100 # x mod y; the remainder of the division; e.g. 517/100 = 5, remainder 17

517/100 # = 5.17; where 5 is the integer, 17 is the remainder


# can plot departure times across the year:
flights_dt %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 86400) # 86400 seconds = 1 day

# can plot departure times within a single day
flights_dt %>% 
  filter(dep_time < ymd(20130102)) %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 600) # 600 s = 10 minutes

# can plot over range of days
flights_dt %>% 
  filter(dep_time > ymd(20130104) & dep_time < ymd(20130106)) %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 600) # 600 s = 10 minutes

  # when using date-times in a numeric context (like in a hist),
  # 1 means 1 second; therefore, binwidth of 86400 means one day

          # 16.2.3 From other types

# switching b/t date-time & date using as_datetime() and as_date()

as_datetime(today()) # append UTC (universal coordinated time) to date
as_date(now()) # take date-time, convert to date

          # 16.3 Get Date-time components w/ Accessor functions:

# year(); month(); 
# yday(); mday(); wday(); 
# hour(); minute(); second()

# Example:
datetime <- ymd_hms("2016/0708 12:34:56")
# using an accessor pulls a literal number associated with the function
wday(datetime) # will return 6; with Sun as 1, Friday is the 6th wday

# set label = TRUE to return abbreviated month or wday;
month(datetime, label = TRUE)
wday(datetime, label = TRUE)
# set abbr = FALSE to return full month or wday name
wday(datetime, label = TRUE, abbr = FALSE)

  # using accessor wday() to make bar chart
flights_dt %>%
  mutate(wday = wday(dep_time, label = TRUE)) %>% # create new column for weekday from dep_time
  ggplot(aes(x = wday)) +
  geom_bar()

# plotting average delay by minute
flights_dt %>% 
  mutate(minute = minute(dep_time)) %>% 
  group_by(minute) %>% # pull min from dep_time and group
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),  # give avg delay per minute
    n = n()) %>% # n() will be used for later plot
  ggplot(aes(minute, avg_delay)) +
  geom_line()
#> `summarise()` ungrouping output (override with `.groups` argument)

# creating schedule departure variable;
sched_dep <- flights_dt %>% 
  mutate(minute = minute(sched_dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n())
# plotting schedule 
ggplot(sched_dep, aes(minute, avg_delay)) +
  geom_line()

# doing same thing without setting variable and using pipe operator
flights_dt %>% 
  mutate(minute = minute(sched_dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
ggplot(., aes(minute, avg_delay)) +
  geom_line()

# plotting scheduled departures by minute/count
ggplot(sched_dep, aes(minute, n)) +
  geom_line()

          # 16.3.2 Rounding

# floor_*, round_*, ceiling_*

# floor_date() -- round down
# round_date() -- round to
# ceiling_date() -- round up

# Ex: plotting number of flight departures per week/day
    # dep_time and arr_time will be similar, as taking data
    # of flights during a week or one day

flights_dt %>% 
  count(week = floor_date(dep_time, unit = "week")) %>% # setting floor_date taken from dep_time, by the week unit
                                                        # # count() returns both the variable and the number
  ggplot(aes(week, n)) +  # plot newly created variable by the number of times it appears
  geom_line()

glimpse(flights_dt)

flights_dt %>% 
  count(week = floor_date(dep_time, unit = "day")) %>% # setting floor_date taken from dep_time, by the week unit
  ggplot(aes(week, n)) +
  geom_line()

          # 16.3.3 Setting components
  # use accessor function to set components of a date/time:
  # use update() to create/modify date-time

(datetime <- ymd_hms("2016-07-08 12:34:56"))
#> [1] "2016-07-08 12:34:56 UTC"

year(datetime) <- 2020
datetime
#> [1] "2020-07-08 12:34:56 UTC"

month(datetime) <- 01
datetime
#> [1] "2020-01-08 12:34:56 UTC"

hour(datetime) <- hour(datetime) + 1
datetime
#> [1] "2020-01-08 13:34:56 UTC"

# update() can be used to create new date-time
update(datetime, year = 2020, month = 2, mday = 3, hour = 3)

# if values are too big, will roll over
ymd("2015/02/01") %>% update(mday = 30) # adds 30 days to Feb 1st
ymd("2015/02/01") %>% update(hour = 400) # adds 400 hours

flights_dt %>% 
  mutate(dep_hour = update(dep_time, yday = 1)) %>% 
  ggplot(aes(dep_hour)) +
  geom_freqpoly(binwidth = 300)

# three important classes that represent time spans:

    # durations: exact number of seconds.
    # periods: human units like weeks and months.
    # intervals: represent a starting and ending point.

# 16.4.1 Durations

  # always returns seconds and largest divisible spanf time

dminutes(100) # returns 600s & 1.67 hours
dminutes(1000) # returns 60000s & 16.67 hours
dminutes(10000) # returns 6e+05s & 6.94 days
dminutes(100000) # returns 6e_06s & 9.92 weeks

# constructors:
  # dseconds()
  # dminutes()
  # dhours()
  # ddays()
  # dweeks()
  # dyears()

# Add and multiply durations:
    2 * dweeks(3)
    #> [1] "3628800s (~6 weeks)"
    dyears(1) + dweeks(12) + dhours(15)
    #> [1] "38869200s (~1.23 years)"

# Add and subtract durations to and from days:
tomorrow <- today() + ddays(1)
last_year <- today() - dyears(1)

      # 16.4.2 Periods -- more likely to return expected values

# Periods: time spans that work with "human" times, like days and months

# constructors:
  # seconds()
  # minutes()
  # hours()
  # days
  # months()
  # weeks()
  # years()

# Can add and multiply periods:
10 * (months(6) + days(1)) # will return 60 months and a day
days(50) + hours(25) + minutes(2)

# arrival time less than depature time
flights_dt %>% 
  filter(arr_time < dep_time) %>% # arr_time is less than dep_time
  select(arr_time, dep_time)

# why? overnight flight. to fix, add days(1) to arrival time of each overnight flight

flights_dt2 <- flights_dt %>% 
  mutate(
    overnight = arr_time < dep_time, # arr_time < dep_time
    arr_time = arr_time + days(overnight * 1), # override arr_time by adding a day to each instance where overnight is TRUE
    sched_arr_time = sched_arr_time + days(overnight * 1) # add a day to each sched_arr_time by each instance where overnight is TRUE
  )

# to see how day is added, can use this and scroll down
days(flights_dt2$overnight * 1)

    # 16.4.3 Intervals: a duration with a starting point
    # makes it precise so you can determine exactly how long it is

next_year <- today() + years(1)
(today() %--% next_year) # %--% is the interval symbol, used b/t start/end
(today() %--% next_year) / ddays(1) # duration between now and next year (365) divided by duration of days


    # Which to choose?
        # If you only care about physical time, use a duration; 
        # if you need to add human times, use a period; 
        # if you need to figure out how long a span is in human units, use an interval.

Sys.timezone()

# UTC (Coordinated Universal Time) is the standard time zone used by the scientific community 
# and roughly equivalent to its predecessor GMT (Greenwich Mean Time).

# You can change the time zone in two ways:

  # 1.) Keep the instant in time the same, and change how it's displayed. 
  # Use this when the instant is correct, but you want a more natural display.

  # 2.) Change the underlying instant in time. Use this when you have an instant 
  # that has been labelled with the incorrect time zone, and you need to fix it.

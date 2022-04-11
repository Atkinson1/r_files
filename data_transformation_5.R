library(tidyverse)                  
library(nycflights13) # flights departing NYC in 2013

setwd("C:/Users/ryan/desktop/r_lesson_plan")
getwd()



                     # Flights Data


flights <- nycflights13::flights


# to get more information on the package
flights
# https://github.com/tidyverse/nycflights13

glimpse(flights)

              # Ints, dbl, chars, logicals
      # int: integers
      # dbl: stands for doubles, or real numbers
      # chr: stands for character vectors, or strings
      # lgl stands for logical, TRUE or FALSE
              # Factors (categorical data)
      # fctr stands for factor: used for categorical variables w/ fixed values
              # Dates
      # date: stands for dates
      # dttm: stands for date-times(a date + a time)


# dplyr package -- a subpackage included in the tidyverse package
      # Verbs:

          # select() - takes your variable(s) (y)
          # filter() - takes your observation(s) (x)

          # group_by() - groups based on some condition in a variable
          # arrange() - arranges data top-down; to do down-top, use arrange(desc())

          # mutate() - create new column or override existing column
          # summarise() - gives summary output of some operation(s)


         # More than one way to filter a data set

# using verbs without a pipe
filter(flights, month == 1, day == 1) # filters for only January 1st
# using verbs with a pipe
flights %>% filter(month == 1, day == 1)

# to save that output
jan_1 <- flights %>% filter(month == 1, day == 1)


         # 5.2 Comparisons

         # < --- less than
         # <= --- less than or equal to
         # > --- greater than
         # >= --- greater than or equal to
         # == --- equivalent to
         # != --- not equivalent to
         
# think of the '=' sign as being more akin to the assignment operator; it says: "x 'is' equal to y"


# Note: floating point numbers and ==

sqrt(2)^2 == 2 # 2 == 2 should be true, but it returns false. why? b/c comps store numbers as approximations
near(sqrt(2)^2, 2) # safer way to compare vectors of floating point numbers
?near


         # Boolean operators that can be used when filter() has more than one condition
         
            # &: "and"
            # | "or"
            # !: "not"


# x %in% y. This will select every row where x is one of the values in y

### https://www.datasciencemadesimple.com/in-operator-in-r/
my_basket = data.frame(ITEM_GROUP = c("Fruit","Fruit","Fruit","Fruit","Fruit","Vegetable","Vegetable","Vegetable","Vegetable","Dairy","Dairy","Dairy","Dairy","Dairy"),
                       ITEM_NAME = c("Apple","Banana","Orange","Mango","Papaya","Carrot","Potato","Brinjal","Raddish","Milk","Curd","Cheese","Milk","Paneer"),
                       Price = c(100,80,80,90,65,70,60,70,25,60,40,35,50,60),
                       Tax = c(2,4,5,NA,2,3,NA,1,NA,4,5,NA,4,NA))
filter(my_basket, Price %in% 80)

nov_dec <- filter(flights, month %in% c(11, 12)) # var "contains" value

# De Morgan's law: !(x & y) is the same as !x | !y, 
             # and !(x | y) is the same as !x & !y


# video on De Morgan's Law https://www.youtube.com/watch?v=93CxSLi89Ok
filter(flights, !(arr_delay > 120 | dep_delay > 120)) # is functionally equivalent to
filter(flights, arr_delay <= 120 & dep_delay <= 120)


            # 5.2.4 Exercises
# 1
filter(flights, arr_delay >= 2) 
# 2
filter(flights, dest == "IAH" | dest == "HOU") # Both "IAH" and "HOU" in quotes b/c they're a string
# 3
unique(flights$carrier)
filter(flights, carrier == "UA" | carrier == "AA" | carrier == "DL")
# 4
filter(flights, month %in% c(6:8))
#5
filter(flights, arr_delay > 120 & dep_delay <= 0 ) #arr/dep_delay in minutes
#6
filter(flights, dep_delay >= 60 & arr_delay < 30)
#7
filter(flights, dep_time >= 0 & dep_time <= 600)

   # dplyr verb helper between() returns a boolean value of true or false
            # seq(1:100) %>% between(30, 40)
            # between(1:12, 7, 9)

# 2
filter(flights, between(dep_time, 0, 600))
# 3
filter(flights, is.na(dep_time))
# 4
NA^0 # because any number raised to 0 is 1
(NA | TRUE) # one or the other must be true; since one is, the answer is TRUE
(FALSE & NA) # at least one must be false with a conjunction; since it is, the answer is FALSE
NA*0 # NA beats out 0


# 5.3 Arrange rows with arrange()
   # If you provide more than one column name, 
   # each additional column will be used to break ties in the values of preceding columns
arrange(flights, month, day)
arrange(flights, month, desc(day))

arr_ex <- tribble(~x, ~y,
                  5, NA,
                  10, 6,
                  15, 4,
                  9, 8,
                  10, 5)

arrange(arr_ex, x) # arranges by x value only (b/c 10-6 comes before 10-5, that's the order that's kept)
arrange(arr_ex, x, y) # arranges by x, then y value

# Let's set our NA to 0!
arr_ex[is.na(arr_ex)] <- 0





# building a df with tibble or tribble
# tibble is used to build a df column-wise, as shown below
df <- tibble(x = c(5, 2, NA)) 
# Missing values always sorted at end
arrange(df, desc(x)) # notice the NA is at the end, while the 5 and 2 have changed places


# 5.3.1

# sched_dep_time - dep_time = dep_delay;
# sched_arr_time - arr_time = arr_delay

# 1
arrange(df, desc(is.na(x)))
#2
arrange(flights, desc(dep_delay))
# 3
arrange(flights, desc(air_time)) %>% select(year:flight, air_time)
# 4
arrange(flights, desc(distance)) %>% select(distance, everything())
arrange(flights, distance) %>% select(distance, everything())



# 5.4 Select columns with select()

# selecting particular variables
flights %>% select(year, month, arr_delay) # take these three particular
flights %>% select(dep_time:dep_delay) # take from this variable to this variable
flights %>% select(-(year:day)) # take all except for these variables from year to day

      # select helper functions

starts_with()
ends_with()
contains()
matches() # variables selected that match regular expressions
num_range(prefix, range) # num_range("x", 1:5) will print x1, x2, x3, x4, x5
rename() # renames variable and keeps all other variables

flights # print flights to show tailnum
flights %>% rename(tail_num = tailnum) # rename(new_name = old_name)

            # moving around columns with select() and everything()

# everything() -- takes everything else in the selection
select(flights, time_hour, air_time, everything()) # can move around columns



# assign z that contains column names based on an index
z <- colnames(flights[3:5])
# subset those column names to match and pull all rows
z1 <- flights[, z]


         # 5.5 mutate()
      # The key property is that the function must be vectorised: 
      # it must take a vector of values as input, 
      # return a vector with the same number of values as output.


flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time)
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60)

# If you only want to keep the new variables, use transmute():

   # arithmetic operators and aggregate functions:
         # x / sum(x): calculates the proportion of the total
         # y - mean(y): calculates the difference from the mean

   # modular arithmetic
         # %/%: integer division
         # %% remainder

5 %/% 2 # 5 goes into 2 twice
5 %% 2 # 5 goes into 2 twice, leaving 1 as the remainder

# only keep dep_time, hour, and minute with the transmute() function
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100)


   # 5.5.2 Exercises

# 1
select(flights, dep_time, sched_dep_time) %>% mutate(dt_mid = (2400 - dep_time)) %>% 
   mutate(sched_dep_mid = (2400 - sched_dep_time))

# 2
transmute(flights, air_time, arr_time - dep_time)
select(flights, air_time, arr_time, dep_time)

# 3
select(flights, dep_time, sched_dep_time, dep_delay)

# 4
df <- mutate(flights, min = min_rank(dep_delay))
df <- select(df, min, everything())
df %>% arrange(min)

         # 5.6 summarise() - It collapses a data frame to a single row; useful with group_by()

summarise(flights, delay = mean(dep_delay, na.rm = TRUE)) # na.rm = TRUE is a function argument

# summarise output gives new column based on row operation, in this case mean()
group_by(flights, year, month, day) %>% summarise(delay = mean(dep_delay, na.rm = TRUE))

         # 5.6.1 the pipe operator

# ex: exploring relationship b/t distance and avg delay
delays <- flights %>% 
   group_by(dest) %>% 
   summarise(
      count = n(), # n() only works in summarise/mutate functions
      dist = mean(distance, na.rm = TRUE), # gives average distance for each destination group
      delay = mean(arr_delay, na.rm = TRUE) # gives average delay for each destination group
   ) %>% 
   filter(count > 20, dest != "HNL")

         # 5.6.2 Missing values

         # removing na from aggregate functions
# all aggregation functions have an na.rm argument 
# which removes the missing values prior to computation:

flights %>% group_by(dest) %>% summarize(count = n()) # gives the n() where the group_by is TRUE

# using na.rm = TRUE within any aggregate function; example:
flights %>% 
   group_by(year, month, day) %>% 
   summarise(mean = mean(dep_delay, na.rm = TRUE))


      # removing cancelled flights

not_cancelled <- flights %>% 
   filter(!is.na(dep_delay), !is.na(arr_delay))
   # !is.na() says "is this missing? if it is true that it is missing, do not include it

not_cancelled %>% 
   group_by(year, month, day) %>% 
   summarise(mean = mean(dep_delay))

            # 5.6.3 Counts

# give me the count of all of these flights based on the tail number
delays <- not_cancelled %>% 
   group_by(tailnum) %>% 
   summarise(
      delay = mean(arr_delay)
   )
# map it
ggplot(data = delays, mapping = aes(x = delay)) + 
   geom_freqpoly(binwidth = 10) + # takes continuous variable like delay, then creates bins 
   xlim(-120, 200) # sets the range of the xlimit

# give me the delay of the time against some number
delays <- not_cancelled %>% 
   group_by(tailnum) %>% 
   summarise(
      delay = mean(arr_delay, na.rm = TRUE),
      n = n()
   )
# plot the delays against some n
ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
   geom_point(alpha = 1/10) +

# take those where n is greater than 25
delays %>% 
   filter(n > 25) %>% 
   ggplot(mapping = aes(x = n, y = delay)) + 
      geom_point(alpha = 1/10)

         # 5.6.4 Useful summary functions

# aggregation and subsetting
not_cancelled %>% 
   group_by(year, month, day) %>% 
   summarise(
      avg_delay1 = mean(arr_delay),
      avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
   )

# counts and proportion of logical values:
# when used with numeric functions, True becomes 1 and False becomes 0

# Q: how many flights left before 5:00 am
not_cancelled %>% group_by(year, month, day) %>% # give me year, month, and day in a group for all flights
   summarize(n_early = sum(dep_time < 500)) # give new col "n_early" where sum contains dep_time less than 500

# Q: proportion of flights delayed by more than an hour?
not_cancelled %>% group_by(year, month, day) %>% # on ith day, ...
   summarize(hour_prop = mean(arr_delay > 60)) # give me flights that were an hour late, and give me their average


               # 5.6.5 Grouping by multiple variables
# When you group by multiple variables, each summary peels off one level of the grouping.
daily <- group_by(flights, year, month, day)

per_day <- summarise(daily, flights = n()) # n() per day; starts at most narrow grouping, which is day
per_month <- summarise(per_day, flights = sum(flights)) # gives total number of flights per month
per_year  <- summarise(per_month, flights = sum(flights)) # gives total number of flights per year

               # 5.6.6 Ungrouping -- removes grouped data
daily %>% ungroup() %>% summarise(flights = n())


            # 5.7 Grouping with mutate() and filter()
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time)

# Find the worst members of each group:

# arr_delay: negative times mean early arrivals
flights_sml %>% 
   group_by(year, month, day) %>%
   filter(rank(desc(arr_delay)) < 10) # give me less than 10 of arr_delays, in descending order, based on their rank

# rank takes 2 arguments: the rank itself & how many outputs to return;
   # in this instance, filter takes ranks the arrival delay and includes only one output
flights_sml %>% group_by(year, month, day) %>% filter(rank(arr_delay) == 1)

# Find all groups bigger than a threshold: shows 332577 of 336776 were a flight a day

popular_dests <- flights %>% 
   group_by(dest) %>% # group by destination 
   filter(n() > 365) # give only those that have more than a flight a day

popular_dests

# Standardise to compute per group metrics:

popular_dests %>% # take our list of popular destinations
   filter(arr_delay > 0) %>% # give me late arriving flights
   mutate(prop_delay = arr_delay / sum(arr_delay)) %>% # give me column that gives proportion of late flights
   select(year:day, dest, arr_delay, prop_delay)


         # window functions work best in grouped mutates and filters
vignette("window-functions")








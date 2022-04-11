setwd("C:/users/ryan/desktop/r_lesson_plan")
getwd()

library(tidyverse)
library(nycflights13)

airlines # lets you look up the full carrier name from its abbreviated code
airports # gives information about each airport, identified by the faa airport code
planes # gives information about each plane, identified by its tailnum
weather # gives the weather at each NYC airport for each hour

# Mutating joins: add new variables to one data frame from matching observations in another.

# Filtering joins: filter observations from one data frame 
    # based on whether or not they match an observation in the other table.

# Set operations: treat observations as if they were set elements.


# 13.3 Keys

# two types of keys:
  
# A primary key: uniquely identifies an observation in its own table. 
# For example, planes$tailnum is a primary key because it uniquely identifies each plane in the planes table.

# A foreign key: uniquely identifies an observation in another table. 
# For example, flights$tailnum is a foreign key because it appears in 
# the flights table where it matches each flight to a unique plane


      # Verifying primary keys - count(variable) %>% filter(n > 1)

planes %>% count(tailnum) %>% filter(n > 1)

flights %>% count(time_hour) %>% filter(n > 1)

                # A surrogate key.
# If a table lacks a primary key, it’s sometimes useful to add one with mutate() and row_number(). 
# That makes it easier to match observations if you’ve done some filtering and want to check back in with the original data. 

# A primary key and the corresponding foreign key in another table form a relation. 
# Relations are typically one-to-many. 

# For example, each flight has one plane, but each plane has many flights. 
# In other data, you’ll occasionally see a 1-to-1 relationship. You can think of this as a special case of 1-to-many. 
# You can model many-to-many relations with a many-to-1 relation plus a 1-to-many relation.
# For example, in this data there’s a many-to-many relationship between airlines and airports: 
# each airline flies to many airports; each airport hosts many airlines.

# moving new column to front of column database
select(zed, new_rol, everything())


      # Exercises 13.3 
# Example to create surrogate key from row_number() function
zed <- flights %>% mutate(new_rol = row_number())

# packages for exercises
install.packages(c("Lahman", "babynames", "nasaweather", "fueleconomy"))
library(Lahman)
library(babynames)
library(nasaweather)
library(fueleconomy)

# Lahman: baseball database
Batting <- Lahman::Batting
glimpse(Batting)

Batting %>% count(playerID, yearID, stint) %>% filter(n > 1)

glimpse(babynames)
babynames %>% count(year, sex, name) %>% filter(n > 1)

glimpse(nasa)
nasa <- nasaweather::atmos
nasa %>% count(lat, long, year, month) %>% filter(n > 1)

glimpse(veh)
veh <- fueleconomy::vehicles
veh %>% count(id, year) %>% filter(n > 1) %>% nrow()

      # to check whether there can be a unique primary key; compare n_distinct values versus total number of rows
diamonds %>% n_distinct()
diamonds %>% nrow()
    # since the number of rows is greater than the number of distinct values, there cannot be some such distinct primary key value


                                    #         # join functions
                                    # 
                                    # flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)
                                    # flights2 
                                    # 
                                    #                 # left_join
                                    # 
                                    # # left_join flights by airlines with primary key "carrier"
                                    # left_join(flights2, airlines, by = "carrier")
                                    # 
                                    # # same operation with dfs switched
                                    # left_join(airlines, flights2, by = "carrier")

                  # df to work with

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

                # inner_join - strict equivalence

# inner_join: matches pairs of obs when keys are equal
inner_join(x, y, by = "key") # think intersection set

                # outer_join

# left_join: keep all obs in x (first listed df)
# right_join: keep all obs in y (second listed df)
# full_join: keep all obs in x & y

left_join(x, y) # think all of x or left side of set
right_join(x, y) # think all of y or right side of set
full_join(x, y) # think union set



                # 13.4.4 Duplicate Keys

# Example 1 -- one table has duplicate; a one-to-many relationship
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)
left_join(y, x, by = "key")

# Example 2 -- both tables have duplicates; get the Cartesian product (all possible combinations) as output
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)
left_join(x, y, by = "key")

# Defining the key columns

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)

glimpse(flights2)
glimpse(planes)

flights2 %>% left_join(planes, by = "tailnum")

      # drawing a map that includes flights to or from an airport

# to match the destination var to the faa var
airports


# matching flights destination data to the faa
unique(flights2$dest)
unique(airports$faa)

flights2 %>% 
  left_join(airports, c("dest" = "faa"))

# matching flights origin data to the faa data (contain similar inputs)
flights2 %>% 
  left_join(airports, c("origin" = "faa"))

    #  13.4.6 Exercises 

avg_dest_delays <-
  flights %>%
  group_by(dest) %>%
  # arrival delay NA's are cancelled flights
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c(dest = "faa")) # joining destination in flights to "faa" in airports


unique(flights$dest)


avg_dest_delays %>%
  ggplot(aes(lon, lat, color = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

        #  13.5 Filtering joins -- will never duplicate output like mutating joins

# Filtering joins match observations in the same way as mutating joins, 
#       but affect the observations, not the variables. 

# There are two types:
#   semi_join(x, y) keeps all observations in x that have a match in y; inverse is the anti_join
#   anti_join(x, y) drops all observations in x that have a match in y.


  # semi_join(x, y) - useful for matching filtered summary tables back to the original rows
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

# To find flights that match the list, could create own filter; easier to use semi-join
  # in example below, removing any flights not from top destination
semi_join(flights, top_dest)

# Anti-joins are useful for diagnosing join mismatches. 
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)


          ### Set Operations
# intersect: returns observations in both x & y;
# union: returns unique observations in both x & y;
# setdiff(x, y): returns observations in x, but not in y



df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)
df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

intersect(df1, df2) # 
union(df1, df2) # 
setdiff(df1, df2) # returns obs in x, but not in y
setdiff(df2, df1) # returns obs in y, but not in x




















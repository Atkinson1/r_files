setwd("C:/users/ryan/desktop/r_lesson_plan")

library(tidyverse)
vignette("pivot")


# Each dataset shows the same values of four variables country, year, population, and cases, 
# but each dataset organises the values in a different way.

table1
table2
table3
table4a
table4b

table1 %>% mutate(per_pop = cases/population*1e5) # computing cases per 100,000 with tidy table1
table1 %>% count(year, wt = cases) # says take the count for each year (3), and take those values for each year and add them up;
                                        # in other words, group by year, add up cases based on that grouping

ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), color = "grey25") + 
  geom_point(aes(colour = country))

      # moving a set of columns to create a new column with corresponding values


# pivot_longer() makes datasets longer by increasing the number of rows 
# and decreasing the number of columns.


# pivot longer example w/ population (3x3 -> 6x3)
table4b
t4b <- pivot_longer(table4b, cols = c(`1999`, `2000`), names_to = "year", values_to = "population")

table4a # original table
t4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")


# pivot_wider from table2 to get to table1 (12x4 -> 6x4)
table2
table2 %>% pivot_wider(names_from = type, values_from = count)


# To pivot:
# 1. The set of columns whose names are values, not variables. 
  # In this example, those are the columns 1999 and 2000.
# 2. The name of the variable to move the column names to. Here it is year.
# 3. The name of the variable to move the column values to. Here it's cases.


    # Joining table4a and table4b into one table
t4c <- left_join(t4a, t4b, by = "year")
t4c


stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks # original stocks dataset
stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")



# df without duplicates
people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

z <- pivot_wider(people, names_from = names, values_from = values)


# df with duplicates; create unique key
people2 <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

            #### Creating a unique key for each value by using group_by()
people2 <- people2 %>% group_by(name, names) %>% mutate(observation = row_number())
people2


# pivoting wider with newly unique rows
pivot_wider(people2, names_from = names, values_from = values)

pregnant <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12  
)

pivot_longer(pregnant, cols = c(male:female), names_to = "sex", values_to = "values")

      ################### separate/unite #################

# separate

table3
# separating one column into more than one column
    # into creates the two newly named columns; 
    # sep = defines which character to use to separate
t3a <- table3 %>% separate(rate, into = c("cases", "population"), sep = "/")
unite(t3, cases:population)

# separating column and converting to more accurate data type (in this case, from str to int)
table3 %>% separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE)

    # You can also pass a vector of integers to sep. 
    # separate() will interpret the integers as positions to split at. 
    # Positive values start at 1 on the far-left of the strings; 
    # negative value start at -1 on the far-right of the strings.

table3 %>% separate(col = "year", into = c("century", "year"), sep = 2)

# unite

# uniting columns
table5 %>% unite(new, century, year)
# removing _ when uniting columns
table5 %>% unite(new, century, year, sep = "")

# creates three rows, with second row containing 4 values;
  # when separated, 4th value in 2nd row removed
t6 <- tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))

# creates three rows; inserts NA in second row when separated into 3 columns
t7 <- tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))

### to create per 10,000; take n/(pop/10k))
table1$cases/(table1$population/10000)

?extract()

          ### 12.5 Missing Values

# Explicitly: flagged with NA
# Implicitly: not present in data

  # An explicit missing value is the presence of an absence; 
  # an implicit missing value is the absence of a presence.

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

# implicitly missing value from 2015 as NA; explicilty missing value of 2016, qr 1 as NA
stocks %>% pivot_wider(names_from = year, values_from = return)

# changing implicit NA to explicit NA, removing in pivot_longer
stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE
  )

# complete() --- will show explicit/implicit NA
stocks %>% complete(year, qtr)

# fill() --- will take previous/next value and use it for all NAs down a column; iterative

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)

treatment %>% fill(person)

    ##### Tidying who data

who <- tidyr::who
glimpse(who)

who1 <- who %>% pivot_longer(cols = new_sp_m014:newrel_f65,
                             names_to = "key",
                             values_to = "cases",
                             values_drop_na = TRUE)

# analyze var names with unique()
unique(who1$key)

# for consistency, can change strings within variable based on a pattern
who2 <- who1 %>% mutate(key = stringr::str_replace(key, "newrel1", "new_rel1"))

who3 <- separate(who2, col = key, into = c("new", "type", "sexage"))
who3

# create two new columns, separated by 1 character moving from the left to the right
who4 <- separate(who3, sexage, into = c("sex", "age"), sep = 1)
# remove iso2, iso3, and key
who4 <- who4 %>% select(-c(iso2:iso3))
who4 <- who4 %>% select(-c(key))

### 12.6.4 Exercises

# to get counts of data after 1995, grouped by sex
who4 %>%
  group_by(country, year, sex) %>%
  filter(year > 1995) %>%
  summarise(cases = sum(cases)) %>%

## using data from above with unite
who4 %>%
  group_by(country, year, sex) %>%
  filter(year > 1995) %>%
  summarise(cases = sum(cases)) %>%
  unite(country_sex, country, sex, remove = FALSE) %>%
  ggplot(aes(x = year, y = cases, group = country_sex, colour = sex)) +
  geom_line()












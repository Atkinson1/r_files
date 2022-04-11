library(tidyverse)
library(skimr)
setwd("c:/users/ryan/desktop/r_lesson_plan")




# EDA 
# 1.) What type of variation occurs within my variables?
# 2.) What type of covariation occurs between my variables?
  
# Variable: a quantity, quality, or property that you can measure.
# Value: the state of a variable when you measure it. 
# Observation: a set of measurements made under similar conditions (); one row, multiple variables.
# Tabular data: a set of values, each associated with a variable and an observation.


      # 7.3.1 Visualising distributions 

# for categorical data, use bar chart
ggplot(diamonds) +
  geom_bar(aes(x = cut))

# can get counts as well:
diamonds %>% count(cut)

      ### ### ### ### ###

# for continous data, use histogram (like a bar chart)
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5) #binwidth indicates distance b/t categories;  

# can get counts as well:
diamonds %>% 
  count(cut_width(carat, 0.5))

# smaller binwidth to hold all values
smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

# can also set range of x
ggplot(data = diamonds, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1) +
  xlim(0, 3)

# to overlay multiple histograms in the same plot; uses lines instead of bars
ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

      ### ### ### ### ### 7.3.2 Typical values


# binwidth of .01 creates 0 to 100 stores 
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

          
### ### ### ### ### 7.3.3 Unusual values

# setting ylim(0,50) removes any observations that exceed 50 on y
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  ylim(0, 50)

# setting coord_cartesian(ylim = c(0, 50)) zooms in to values b/t 0 and 50
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
    coord_cartesian(ylim = c(0, 50))


unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)


      ### 7.3.4 Exercises

# 2 Exploring distribution of price
ggplot(diamonds, aes(x = price)) +
  geom_histogram(binwidth = 100)

ggplot(diamonds, aes(x = price)) +
  geom_histogram(bins = 100)

ggplot(diamonds, aes(x = price)) +
  geom_histogram(binwidth = 10)

# setting prices under 5k to hone in on missing data
lower_price <- diamonds %>% filter(price <= 5000)

# 3 .99 carat versus 1 carat

d1 <- diamonds %>% filter(carat <= 1) %>% summarize(full_count = n())
d2 <- diamonds %>% filter(carat < 1) %>% summarize(full_count = n())
d1 - d2

# 4
  # with xlim & ylim, removes values outside of range
ggplot(diamonds, aes(x = price)) +
  geom_histogram() +
  xlim(0, 2500) +
  ylim(0, 1000)

  # with coord_cartesian, keeps values within range
ggplot(diamonds, aes(x = price)) +
  geom_histogram(binwidth = 100) +
  coord_cartesian(xlim = c(0, 5000), ylim = c(0, 1000)) 

      # 7.4 Missing values

# 1 - Drop the entire row with the strange values:
diamonds2 <- diamonds %>% filter(between(y, 3, 20)) # between(var, left, right)
diamonds2

        # ifelse function to drop values and replace data
diamonds3 <- diamonds %>% mutate(y = ifelse(y < 3 | y > 20, NA, y))


  # creating a new column based on whether data is missing from it
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)


      # 7.5 Covariation


# 7.5.1 Categorical and continuous variable

    # boxplot() - 
# A box that stretches from the 25th percentile of the distribution to the 75th percentile, 
# a distance known as the interquartile range (IQR). In the middle of the box is a line that 
# displays the median, i.e. 50th percentile, of the distribution. 

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()


  # reorder() values based on median;
      # reorder(x, index, function applied to each subset of x)

# 1

flights <- nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) 

# original ggplot
ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

# comparative boxplot
ggplot(flights, aes(x = sched_dep_time, y = cancelled)) +
  geom_boxplot() +
  coord_flip()

# 4 -- Letter Value 'Boxplots'
install.packages("lvplot")
library(lvplot)

# geom_violin -- mirrored density plot displayed in the same way as a boxplot.
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_violin() +
  coord_flip()


      # 7.5.2 Two Categorical variables

ggplot(diamonds, aes(x = cut, y = color)) +
   geom_count()

    # Compute same count with dplyr and count()
diamonds %>% count(color, cut)

# visualizing interaction with color
diamonds %>% count(color, cut) %>%
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))

# If the categorical variables are unordered, you might want to use the 
# seriation package to simultaneously reorder the rows and columns 
# in order to more clearly reveal interesting patterns. 
# For larger plots, you might want to try the d3heatmap or heatmaply packages, 
# which create interactive plots.


    # 7.5.3 Two continuous variables

# geom_point()
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))

# geom_bin2d() & geom_hex() to bin in two dimensions
ggplot(smaller) +
  geom_bin2d(aes(carat, price))

ggplot(smaller) +
  geom_hex(aes(x = carat, y = price))


# Another option is to bin one continuous variable so it acts like a categorical variable.

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.1)))

                        














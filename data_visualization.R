setwd("C:/Users/ryan/desktop/r_lesson_plan")

library(tidyverse)

# To call a specific function from a package, use:
# package::function()

mpg <- mpg
glimpse(mpg)
# displ : the car's engine size in liters
# hwy: the fuel efficiency on highway in mpg

# plotting engine size against highway fuel efficiency
ggplot(mpg) + # take dataset as base
  geom_point(aes(x = displ, y = hwy)) # add layer


# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

ggplot(mpg) +
  geom_point(aes(x = cyl, y = hwy))

# You can add a third variable with an aesthetic

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = class))

# To map an aesthetic to a variable, associate the name of the aesthetic to the name of the variable inside aes()
# scaling: assigning a unique level of the aesthetic (e.g., a color) to each unique value of the variable; includes a legend

# list of aesthetics: alpha, shape, size

# setting an aesthetic manually outside of aesthetic
# choose level that makes sense for aesthetic
  # example: size of a point in mm;
  # example: name of a color as a character string

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy), color = "red")

# combining manual and automatic aesthetic mapping
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = class), size = 2)

# aesthetic specifications
vignette("ggplot2-specs")

#### 3.5 Facets - subplots that display one subset of the data; useful with categorical data (no so much on continuous data)

      # 3 variables
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(~ drv) # have to use vars

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# to not facet on a row/column, use . as a filler

# no row, or x2
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_grid(. ~ cyl) # empty x by cyl y
# no column, or y2
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_grid(drv ~ .)

      # 4 variables
ggplot(mpg) +
geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl) # drive as x2, cyl as y2


### 3.6 Geometric objects
    # bar charts use bar geoms, 
    # line charts use line geoms, 
    # boxplots use boxplot geoms,
    # scatterplots use point geoms,


# smooth without se, linetype defined by drive
ggplot(mpg) +
  geom_smooth(aes(displ, hwy, linetype = drv), se = FALSE)

# smooth with se
ggplot(mpg) +
  geom_smooth(aes(displ, hwy, linetype = drv, color = drv))

# smooth with se and points similar color
ggplot(mpg) +
  geom_point(aes(displ, hwy, color = drv)) +
  geom_smooth(aes(displ, hwy, linetype = drv, color = drv))

# adding aesthetics to each geom layer (e.g., geom_point and geom_smooth)
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = class)) +
  geom_smooth(aes(x = displ, y = hwy))

# denoting points on base plot, then adding a layer
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()

# line of best fit for each drive type (i.e., 4, f, r)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE) # adding smooth that matches color of points

# line of best fit for the subcompact class
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

# removing the legend
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class), show.legend = FALSE) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class), show.legend = FALSE) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

### 3.6 Recreate 

# 1
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  geom_smooth(aes(x = displ, y = hwy), se = FALSE)

# 2
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  geom_smooth(aes(x = displ, y = hwy, line = drv), se = FALSE)

# 3
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = drv)) +
  geom_smooth(aes(x = displ, y = hwy, color = drv), se = FALSE)

# 4
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = drv), size = 3) +
  geom_smooth(aes(x = displ, y = hwy), se = FALSE)

# 5
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = drv), size = 2) +
  geom_smooth(aes(x = displ, y = hwy, linetype = drv), se = FALSE)

# 6
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy), color = "white", size = 5) +
  geom_point(aes(x = displ, y = hwy, color = drv), size = 2)

    # 3.7 Statistical transformations

# assigning diamonds data by calling it from the ggplot2 package
diamonds <- ggplot2::diamonds

# creating a bar chart
ggplot(diamonds) +
  geom_bar(aes(cut, fill = cut))

# statistical transformation (stat)
  # sums up n for some group (i.e., cut quality)

# default stat value for geom_bar is count
diamonds %>% count(cut)

# every geom has a default stat; every stat has a default geom

# creating a data.frame( ))(i.e., creating a tibble using tribble())
demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)
# the statistic is identity, or itself
ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

# try to do it without stat, get an error
ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq))

      # proportion stat
      ggplot(data = diamonds) + 
        geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))
      
      # count stat
      ggplot(diamonds) +
        geom_bar(aes(x = cut, y = stat(count)))

# stat_summary; summarize y at unique/binned x
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

?stat_summary

# Note:
  # geom_bar() uses stat_count() by default;
      # makes height of bar proportional to number of cases in each group
  # geom_col() uses stat_identity by default;
      #  If you want the heights of the bars to represent values in the data, use geom_col() instead.
glimpse(diamonds)

ggplot(diamonds) +
  geom_col(aes(x = cut, y = price)) # gives sum of price based on cut

ggplot(diamonds) +
  geom_bar(aes(cut)) # gives n

          # 3.8 Position adjustments

# color acts as border around bar
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, color = cut))

# color acts as fill for bar
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

# fill acts as third variable to cut(x), count(y); in other words,
# fill = clarity subdivides total count of each cut


# bars stacked automatically by position argument giving a sum n
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))
# clarity: measure of how clear diamond is; 
# low-high: (I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best))

          

      # position = "identity": gives an n for each subdivision, each layer on top of the other
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "identity")

                  # bars projected onto one another by each total clarity amount
                  ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
                    geom_bar(alpha = 1/5, position = "identity")
                  
                  # bars projected onto one another by each total clarity amount
                  ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
                    geom_bar(fill = NA, position = "identity")

      # position = "dodge": spreads out each individual subdivision, each layer next to one another
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")

      # position = "fill": stretches subdivision as % of whole (i.e., 0-100 or 0-1)
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill")

      # position = "jitter": creates artificial distance; can be used to show counts by number of intersections
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

      # position = "jitter":can be used to show counts by number of intersections
ggplot(diamonds, aes(x = cut, y = clarity, color = clarity)) +
  geom_jitter()


# 3.9 Coordinate Systems

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

# coordinate flip b/t x and y axes
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

# coord_quickmap() sets the aspect ratio correctly for maps.

?map_data ### takes data from the maps package

nz <- map_data("nz") # load in nz from maps package with map_data() function
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()


# relationship b/t barchart and coxcomb chart -- to learn about coxcomb chart: https://visual.ly/m/coxcomb-chart/
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

# coord_fixed() adjusts ratios for other types of graphs to be proportional
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()



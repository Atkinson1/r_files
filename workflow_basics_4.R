            # https://r4ds.had.co.nz/workflow-basics.html

# two ways of using a sequence of numbers
seq(1,10)
seq(1:10)

# where length.out gives division from 1:10 into number of parts given
seq(1,10, length.out = 5) # gives us 1, 3.25, 5.5, 7.75, 10

seq(0,10, length.out = 5) # gives us 0, 2.5, 5, 7.5, 10


# 4.4 Exercises

library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))


# fliter(mpg, cyl = 8)
filter(mpg, cyl == 8)

# filter(diamond, carat > 3)
filter(diamonds, carat > 3)



      # Alt + Shift + K
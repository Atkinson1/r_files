# iteration: helps you when you need to do the same thing to multiple inputs: 
# repeating the same operation on different columns, or on different datasets.

# two important iteration paradigms: 
    # imperative programming
        # contains for/while loops
    # functional programming
        # contains tools to extract duplicated code, so each for loop pattern gets its own function

library(tidyverse)


df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# computing median from a tibble

output <- vector("double", ncol(df))  # 1. output -- can also be vector("double", length(df)); vector takes two arguments, type of vector and length of vector
for (i in seq_along(df)) {            # 2. sequence -- determines what to loop over, i in seq_along(df)
  output[[i]] <- median(df[[i]])      # 3. body -- what is done
}
output


# compute mean for each column in dataframe, mtcars, with names assigned to output

mt_car_mean <- vector("double", length(mtcars))
names(mt_car_mean) <- names(mtcars)
for (i in seq_along(mtcars)) {
  mt_car_mean[[i]] <- mean(mtcars[[i]])
}
mt_car_mean

# Determine the type of each column in nycflights13::flights.
library(nycflights13)
flights <- nycflights13::flights

output <- vector("list", length(flights))
names(output) <- names(flights)
for (i in seq_along(flights)) {
  output[[i]] <- class(flights[[i]]) 
}
output

# Computer the number of unique values in each column of iris
output <- vector("integer", ncol(iris))
names(output) <- names(iris)
for (i in seq_along(iris)) {
  output[[i]] <- n_distinct(iris[[i]])
}
output

# Alice the camel has no humps
humps <- c("five", "four", "three", "two", "one", "no")
for (i in humps) {
  cat(str_c("Alice the camel has ", rep(i, 3), " humps.",
            collapse = "\n"
  ), "\n")
  if (i == "no") {
    cat("Now Alice is a horse.\n")
  } else {
    cat("So go, Alice, go.\n")
  }
  cat("\n")
}

# Ten in the bed
numbers <- c(
  "ten", "nine", "eight", "seven", "six", "five",
  "four", "three", "two", "one"
)
for (i in numbers) {
  cat(str_c("There were ", i, " in the bed\n"))
  cat("and the little one said\n")
  if (i == "one") {
    cat("I'm lonely...")
  } else {
    cat("Roll over, roll over\n")
    cat("So they all rolled over and one fell out.\n")
  }
  cat("\n")
}

# 99 bottles of beer on the wall

bottles <- function(n) {
  if (n > 1) {
    str_c(n, " bottles")
  } else if (n == 1) {
    "1 bottle"
  } else {
    "no more bottles"
  }
}

beer_bottles <- function(total_bottles) {
  # print each lyric
  for (current_bottles in seq(total_bottles, 0)) {
    # first line
    cat(str_to_sentence(str_c(bottles(current_bottles), " of beer on the wall, ", bottles(current_bottles), " of beer.\n")))   
    # second line
    if (current_bottles > 0) {
      cat(str_c(
        "Take one down and pass it around, ", bottles(current_bottles - 1),
        " of beer on the wall.\n"
      ))          
    } else {
      cat(str_c("Go to the store and buy some more, ", bottles(total_bottles), " of beer on the wall.\n"))                }
    cat("\n")
  }
}
beer_bottles(4)

                          # 21.3 For loop variations

                # 21.3.1 Modifying an existing object

# initial dataframe
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
# our function that can be called to change our dataframe
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
# a for loop that calls our function to apply to each column of the dataframe
for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}

# Typically you’ll be modifying a list or data frame with this sort of loop, so remember to use [[, not [. 
# You might have spotted that I used [[ in all my for loops: I think it’s better to use [[ even for atomic 
# vectors because it makes it clear that I want to work with a single element.

class(df[1]) # when using [], keeps object as is
class(df[[1]]) # when using [[]], removes a layer; in this case, removes tbl_df/tbl/data.frame layer and turns into numeric vector

                # 21.3.2 Looping patterns 

# 1.) looping over numeric indices
    # for (i in seq_along(df))

            # Iteration over the numeric indices is the most general form, 
            # because given the position you can extract both the name and the value

mt_car_mean <- vector("double", length(mtcars))
names(mt_car_mean) <- names(mtcars)
for (i in seq_along(mtcars)) {
  mt_car_mean[[i]] <- mean(mtcars[[i]])
}
mt_car_mean

#     mpg        cyl       disp         hp       drat         wt       qsec         vs         am       gear       carb 
# 20.090625   6.187500 230.721875 146.687500   3.596563   3.217250  17.848750   0.437500   0.406250   3.687500   2.812500 

# 2.) loop over elements:
    # for (x in df)

# 3.) loop over names:

    # for (x in names(df))

        # This gives you name, which you can use to access the value with x[[nm]]. 
        # This is useful if you want to use the name in a plot title or a file name. 
        # If you’re creating named output, make sure to name the results vector like so:

            # output <- vector("list", length(input))
            # names(output) <- names(input)

                # 21.3.3 Unknown output length

means <- c(0, 1, 2)

output <- double()
for (i in seq_along(means)) {
  n <- sample(100, 1) # resamples a number from 1:100 each iteration
  output <- c(output, rnorm(n, means[[i]])) #rnorm(n) means take the random number from the sample above, use means[[i]] to take 0, 1, 2 
}

    # a better method: save results as a list, then combine into single vector after loop is done
means <- c(0, 1, 2)

out <- vector("list", length(means))
for (i in seq_along(means)) {  
  n <- sample(100, 1)
  out[[i]] <- rnorm(n, means[[i]])
}

    # how to read above: start at one of the values in the means list; take a sample of a number b/t 1:100 once; use that number for n, with mean at ith position; repeat
        # In other words: return 0 mean with some random n, 1 mean with some random n, and 2 mean with some random n; 
        # assign to out, where out is saved as a list of the length of the means/# of iterations

str(out) # list of 3
str(unlist(out)) # flattens list, turns all outputs of list into single numeric vector
  # A stricter option is to use purrr::flatten_dbl() — it will throw an error if the input isn’t a list of doubles.

      # Patterns of long pieces of output

# 1.) Long string: save output in a character vector and then combine that vector into a single string with paste(output, collapse = "")
# 2.) Big data frame: save the output in a list, then use dplyr::bind_rows(output) to combine the output into a single data frame.

                # 21.3.4 Unknown sequence length (while loop; used for when # of iterations not known in advance)

# Common with simulations

while (condition) {
  # body
}

      ###

# Can rewrite any for loop as a while loop; can't rewrite every while loop as a for loop

for (i in seq_along(x)) {
  # body
}

# Equivalent to

i <- 1
while (i <= length(x)) {
  # body
  i <- i + 1 
}

      ###

# how many flips to get three heads in a row
flip <- function() sample(c("T", "H"), 1)

flips <- 0
nheads <- 0

while (nheads < 3) {
  if (flip() == "H") {    # flip() is our function defined above
    nheads <- nheads + 1
  } else {
    nheads <- 0
  }
  flips <- flips + 1
}
flips

        # 21.3.5 Exercises

# 1.) Write a for loop to take each csv and load into a single dataframe

  # \\ is regular escape expression in order to use a literal period; $ indicates end of string regular expression
files <- dir("C:/Users/ryan/Desktop/trial_csv", pattern = "\\.csv$", full.names = TRUE)
files

# create an empty list corresponding to length of csv files to read in
df_list <- vector("list", length(files))
# write for loop to read_csv and assign to value in df_list
for (i in seq_along(files)) {
  df_list[[i]] <- read_csv(files[[i]])
}
# bind lists into single dataframe with bind_rows()
df <- bind_rows(df_list)

df2_list <- vector("list", length(files))
names(df2_list) <- files
for (fname in files) {
  df2_list[[fname]] <- read_csv(fname)
}
df2 <- bind_rows(df2_list)
df2

  ### a reminder of how a for loop pulls the index position versus the index value at that position

x <- c(11, 12, 13)
for (i in seq_along(x)) {
  print(i)
  print(x[[i]])
}

# Write a function that prints the mean of each numeric column in a data frame, along with its name. 
# For example, show_mean(iris) would print:


















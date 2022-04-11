# functionals: allowing a function to be passed into a function

library(tidyverse)


df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# Start
output <- vector("double", length(df))
for (i in seq_along(df)) {
  output[[i]] <- mean(df[[i]])
}
output
#> [1] -0.3260369  0.1356639  0.4291403 -0.2498034

# Turn into function
col_mean <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- mean(df[[i]])
  }
  output
}
# attempt to have function do 2 things, messy
col_median <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- median(df[[i]])
  }
  output
}
col_sd <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- sd(df[[i]])
  }
  output
}

# consolidate function to take in df and function
col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[[i]] <- fun(df[[i]])
  }
  out
}

col_summary(df, median)
col_summary(df, mean)

# another function that can take in a function and an index
f <- function(x, i) {
  abs(x - mean(x)) ^ i
}
f(c(seq(1,5,2)), 3)


        # 21.4 Purrr package and the map functions; map functions only ever produce vectors (unlike (s/v/l/apply))

# Note:
  # vector: 1d array
  # matrix: 2d array
      # array: n-dimensional object
    
        # can say: an array in 1 dimension is a vector; an array in 2 dimensions is a matrix

        # matrices and arrays are vectors with dim attribute and, optionally, dimnames attached to vector

# looping over a vector with map() and map_*()
# Each function takes a vector as input, applies a function to each piece, 
# and then returns a new vector that’s the same length (and has the same names) as the input.


map_dbl(df, mean)

# Differences between map_*() and col_summary():

# 1. purrr is in C
# 2. The second argument, .f, the function to apply, can be a formula, a character vector, or an integer vector.
# 3. map_*() uses ... to pass additional arguments to .f each time it's called
map(df, mean, na.rm = TRUE)
# 4. map function preserves names
z <- list(x = 1:3, y = 4:5)
map_int(z, length)

      # 21.5.1 Shorcuts

# Ex: fitting linear model to groups within a dataset
models <- mtcars %>% split(.$cyl) %>% 
map(function(df) lm(mpg ~ wt, data = df)) # function(df) is the function within the map function; partitioned data has already been piped through


    # a one-sided formula as a shorcut
models <- mtcars %>% 
  split(.$cyl) %>% 
  map(~lm(mpg ~ wt, data = .))
# Here I’ve used . as a pronoun: it refers to the current list element (in the same way that i referred to the current index in the for loop).

    # extracting useful components/statistics - 3 methods

# 1.) using shorthand for anonymous functions
models %>% map(summary) %>% # gives summary for each .cyl
  map_dbl(~.$r.squared)

# 2.) using a string
models %>% map(summary) %>% map_dbl("r.squared")

# 3.) selecting an element by position with an integer
x <- list(list(1,2,3), list(4,5,6), list(6,7,8))
x %>% map_dbl(2) # pulls second element from each list within the list

      # 21.5.3 Exercises


# Write code that uses one of the map functions to:
   
  # 1. Compute the mean of every column in mtcars.
map_dbl(mtcars, mean)
  # 2. Determine the type of each column in nycflights13::flights.
map_chr(nycflights13::flights, typeof)
  # 3. Compute the number of unique values in each column of iris.
map_dbl(iris, n_distinct)
# or, with an anonymous function (a function not named)
map_int(iris, function(x) length(unique(x)))
  # 4. Generate 10 random normals from distributions with means of -10, 0, 10, and 100.
map(c(-10, 0, 10, 100), ~rnorm(n = 10, mean = .)) # in this case, our input is those means; we denote our mean by ., which refers to preceding input

# How can you create a single vector that for each column in a data frame indicates whether or not it’s a factor?
map_lgl(diamonds, is.factor)

# It is important to be aware that while the input of map() can be any vector, the output is always a list.

map(-2:2, rnorm, n = 5)

# Use the map() function if the function will return values of varying types or lengths.
# To return a numeric vector, use flatten_dbl() to coerce the list returned by map() to a numeric vector.
map(-2:2, rnorm, n = 5) %>%
  flatten_dbl()


# Rewrite map(x, function(df) lm(mpg ~ wt, data = df)) to eliminate the anonymous function.
x <- split(mtcars, mtcars$cyl)
map(x, function(df) lm(mpg ~ wt, data = df))
# We can eliminate the use of an anonymous function using the ~ shortcut.
map(x, ~ lm(mpg ~ wt, data = .))

          
                # 21.6 Dealing with failure

# safely() - an adverb that will always return output and, if true, any errors

safe_log <- safely(log)
str(safe_log(10)) # no errors
str(safe_log("a")) # error, b/c a isn't numeric

# safely() is designed to work with map:
x <- list(1, 10, "a")
y <- x %>% map(safely(log))
str(y) # returns yes, yes, no (for each item on the list)

# to return results/error in two different lists, use transpose
y <- y %>% transpose()
str(y)

      # possibly() - you give default value to return when there is an error

x <- list(1, 10, "a")
x %>% map_dbl(possibly(log, NA_real_)) # NA_real_ can be used to assign NA, which in this case with return NA if map doesn't work for given input

      # quietly() -- like safely, but instead of errors, gives result, output, messages, and warning
x <- list(1, -1)
x %>% map(quietly(log)) %>% str()

                #21.7 Mapping over multiple arguments --- map2() and pmap(); flatten() changes list to atomic vector

# Simulate some random normals with diff means

mu <- list(5, 10, -3)
mu %>% map(rnorm, n = 5) %>% str()
# another way of getting same result
str(map(mu, rnorm, n = 5))
# remember: can flatten out list to get atomic vector of a type
map(mu, rnorm, n = 5) %>% flatten_dbl()

# flatten() is similar to unlist(), but only removes one hierarchical layer and can define output

# map2(): iterates over two vectors in parallel
mu <- list(5, 10, -3)
sigma <- list(1, 5, 10)

map2(mu, sigma, rnorm, n = 5) %>% str() # where mu is average, sigma is standard dev; arguments that vary should come before function, in this case the rnorm function

# for instance, computes shows this: 
    # rnorm(5, 1, n = 5)
    # rnorm(10, 5, n = 5)
    # rnorm(-3, 10, n = 5)

  # Note that the arguments that vary for each call come before the function; arguments that are the same for every call come after.

# like map(), map2() is juset a wrapper around a for loop

map2 <- function(x, y, f, ...) {
  out <- vector("list", length(x))
  for (i in seq_along(x)) {
    out[[i]] <- f(x[[i]], y[[i]], ...)
  }
  out
}


# for map with more than 2 inputs, use pmap()
n <- list(1, 3, 5)
args1 <- list(n, mu, sigma)
args1 %>% pmap(rnorm) %>% str()

# without listing elements, will use positional matching when calling a function;
# instead, name the arguments
args2 <- list(mean = mu, sd = sigma, n = n)
args2 %>% pmap(rnorm) %>% str()

  # can also store arguments in a dataframe if all the same length
params <- tribble(
  ~mean, ~sd, ~n,
  5, 1, 1,
  10, 5, 3,
  -3, 10, 5
)


      # 21.7.1 Invoking different functions
f <- c("runif", "rnorm", "rpois")
param <- list(
  list(min = -1, max = 1),
  list(sd = 5),
  list(lambda = 10)
)

# takes in 3 functions, a list of lists - with each containing parameters to be used for indexed function, and number of times to iterate
invoke_map(f, param, n = 5) %>% str() 

# The first argument is a list of functions or character vector of function names. 
# The second argument is a list of lists giving the arguments that vary for each function. 
# The subsequent arguments are passed on to every function.


      # 21.8 Walk

# pwalk(): useful if having a list of plots and vector of file names; would allow saving each file to corresponding location on disk

library(ggplot2)

# to get output based on cylinder type
plots <- mtcars %>% 
  split(.$cyl) %>% # split mtcars by cyl
  map(~ggplot(., aes(mpg, wt)) + geom_point()) # map with anonymous function
# paths is created by taking plot name and combining it with .pdf
paths <- stringr::str_c(names(plots), ".pdf")

pwalk(list(paths, plots), ggsave, path = tempdir())

        # Predicate functions: return a single TRUE or FALSE

    # keep() and discard(): 
# keep elements of the input where the predicate is TRUE or FALSE respectively:
iris %>% keep(is.factor) %>% str()
iris %>% discard(is.factor) %>% str()

    # some() and every():
# determine if the predicate is true for any or for all of the elements
x <- list(1:5, letters, list(10))

x %>% every(is_vector) # is each object a vector?
x %>% some(is_character) # is some object a character?

    # detect(): finds the first element where the predicate is true;
    # detect_index(): finds the position where the predicate is true

x <- sample(10) # samples 10 numbers 10 times, without replacement
x %>% detect(~ . > 5) # which number is where it's true?
x %>% detect_index(~ . > 5) # at which position is the first instance of a number being greater than 5


    # head_while(): take elements for start of vector while a predicate is true
    # tail_while() # take elements from end of a vector while a predicate is true

x %>% head_while(~ . > 5)
x %>% tail_while(~ . > 5)

          # 21.92 Reduce and accumulate

# Wanting to reduce a list of data frames to a single data frame by joining elements together
dfs <- list(
  age = tibble(name = "John", age = 30),
  sex = tibble(name = c("John", "Mary"), sex = c("M", "F")),
  trt = tibble(name = "Mary", treatment = "A")
)

dfs %>% reduce(full_join) # joins lists and puts in NAs where data not available; in this case, age of Mary and treatment of John

# wanting to find interaction among list of vectors
vs <- list(
  c(1, 3, 5, 6, 10),
  c(1, 2, 3, 7, 8, 10),
  c(1, 2, 3, 4, 8, 9, 10)
)
vs %>% reduce(intersect)

      # reduce: takes a "binary" function (function w/ 2 primary inputs) and applies
              # it repeatedly to a list until there is only a single element left

      # accumulate: does same as reduce, but keeps all interim results
x <- sample(10)
x %>% accumulate(`+`)















































































setwd("C:/users/ryan/desktop/r_lesson_plan")

df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# note that rng[1] is the min, rng[2] is the max

normalization <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

# There are three key steps to creating a new function:

# 1.) You need to pick a name for the function. 
  # Here I’ve used rescale01 because this function rescales a vector to lie between 0 and 1.
 
# 2.) You list the inputs, or arguments, to the function inside function. 
  # Here we have just one argument. If we had more the call would look like function(x, y, z).
 
# 3.) You place the code you have developed in body of the function, a { block that immediately follows function(...).
  
normalization(c(1:10, Inf))


# Test Questions:
  # 4

values <- c(1, 2, 3, 4, 5)

variance <- function(x) {
  x <- sum(((x - mean(x))^ 2))/(length(x)-1)
}

(variance(values))
var(values)

skewness_func <- function(x) {
  x <- (sum(((x - mean(x))^3))/(length(x)-2))/(var(x)^(3/2))
}

(skewness_func(values))
library(e1071) 
(skewness(values))

####

# percentage of value in all values
part <- function(x) {
  x / sum(x, na.rm = TRUE)
}

#### 

values2 <- c(NA, 2, 2, 5, NA)
values3 <- c(3, NA, 5, 3, NA)

na_checker <- function(x, y) {
  sum(is.na(x) & is.na(y))
}

na_checker(values2, values3)

na_check <- function(x, y) {
  x <- is.na(x)
  y <- is.na(y)
  sum(x & y)
}

na_check(values2, values3)



    # coefficient of variation: sd/mean

# The coefficient of variation (CV) is a statistical measure of the relative dispersion of data points in a data series around the mean. 
# In finance, the coefficient of variation allows investors to determine how much volatility, or risk, 
# is assumed in comparison to the amount of return expected from investments.

coef_variation <- function(x, na.rm = FALSE) {
  sd(x, na.rm = na.rm) / mean(x, na.rm = na.rm)
}  

coef_variation(1:5)

      # snake_case
      # camel_Case


# Use ctrl + shift + R to create labels


# matches prefix to string
str_pref_match <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}

str_pref_match(c("banana", "bandana", "bully"), "ban")


# removes last element
rm_last_elmt <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)]
}

rm_last_elmt(c('word', 'apple', 'bear'))

# repeat y for the length of x input 
dup_from_length <- function(x, y) {
  rep(y, length.out = length(x))
}

# repeat sequence of 5 twice for 10 values of x; 
# replace those 10 values with the number 15
dup_from_length(rep(seq(5), 2), 15)


            # Conditional execution of loops      
?`if`

if (condition) {
  expression
} else {
  expression
}


# The goal of this function is to return a logical vector describing whether or not each element of a vector is named.
has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}
# if checks when there is a missing value, returns false for the instances when it is false
# else says if it's not missing (NA) and not empty, return the value



# Example, this df has one named column and one unnamed column
df_trial <- tribble(~apple, ~"",
        1, 2,
        3, 4)
# Test out the function
has_name(df_trial)

# You can use || (or) and && (and) to combine multiple logical expressions. These operators are “short-circuiting”: 
# as soon as || sees the first TRUE it returns TRUE without computing anything else. As soon as && sees the first FALSE it returns FALSE. 
# You should never use | or & in an if statement: these are vectorised operations that apply to multiple values 
# (that’s why you use them in filter()). If you do have a logical vector, you can use any() or all() to collapse it to a single value.


              # a function with an if statement

# if_else trial function

trial_if_el <- function(x) {
  for (i in seq_along(x)) {
    if (x[i] > 60) {
      print("greater than 60")
    } else {
      print("not greater")
    }
  }
}

trial_if_el(values)
trial_if_el(as_vector(vec))

df_trial2 <- tribble(~col1, ~col2,
                     65, 20,
                     16, 88)

# to go over entire df, convert to vector
trial_if_el(as_vector(df_trial2))
# can also choose to iterate over particular column
trial_if_el(as_vector(df_trial2[2]))

#####

    # Multiple Conditions

if (this) {
  # expression
} else if (that) {
  # do something else
} else {
  # print/return
}


      # useful function helpers: switch() and cut()

switch()

math_func <- function(x, y, op) {
  switch(op,
         plus = x + y,
         minus = x - y,
         times = x * y,
         divide = x / y,
         stop("Unknown op!"))
}

math_func(25, 3.2, "plus") # evaluating based on name
math_func(25, 3.2, 1) # evaluating based on position

      # ifelse(); 

            # if
            # else if
            # else
      

      # Difference between if and ifelse

ifelse(df_trial2 > 20, "sweet", "not sweet")
if ((df_trial2) > 20) print("sweet")

# if : a length-one logical vector that is not NA
# ifelse(): will take logical vector greater than length-one




# Exercises
  # 19.4.4

library(lubridate)

greet <- function(time = lubridate::now()) {
  hr <- lubridate::hour(time)
  # I don't know what to do about times after midnight,
  # are they evening or morning?
  if (hr < 12) {
    print("good morning")
  } else if (hr < 17) {
    print("good afternoon")
  } else {
    print("good evening")
  }
}

# fizzbuzz

fizzbuzz <- function(x) {
  if (!(x %% 3) && !(x %% 5)) {
    "fizzbuzz"
  } else if (!(x %% 3)) {
    "fizz"
  } else if (!(x %% 5)) {
    "buzz"
  } else {
    # ensure that the function returns a character vector
    as.character(x)
  }
}

fizzbuzzy <- function(y) {
  if ((y %% 3 == 0) && (y %% 5 == 0)) {
    print("fizzbuzz")
  } else if (y %% 3 == 0) {
    print("fizz")
  } else if (y %% 5 == 0) {
    print("buzz")
  } else {
    print("N/A")
  }
}


## When you call a function, you typically omit the names of the data arguments, because they are used so commonly. 
## If you override the default value of a detail argument, you should use the full name:

# Good
mean(1:10, na.rm = TRUE)


# handful of very common, very short names. It’s worth memorising these:

        # x, y, z: vectors.
        # w: a vector of weights.
        # df: a data frame.
        # i, j: numeric indices (typically rows and columns).
        # n: length, or number of rows.
        # p: number of columns.



      # Making constraints explicit / checking values

# 19.5.2

# This is a lot of extra work for little additional gain. 
# A useful compromise is the built-in stopifnot(): 
#   it checks that each argument is TRUE, and produces a generic error message if not.

wt_mean <- function(x, w, na.rm = FALSE) {
  stopifnot(is.logical(na.rm), length(na.rm) == 1)
  stopifnot(length(x) == length(w))
  
  if (na.rm) {
    miss <- is.na(x) | is.na(w)
    x <- x[!miss]
    w <- w[!miss]
  }
  sum(w * x) / sum(w)
}
wt_mean(1:6, 6:1, na.rm = "foo")
#> Error in wt_mean(1:6, 6:1, na.rm = "foo"): is.logical(na.rm) is not TRUE

# Note that when using stopifnot() you assert what should be true rather than checking for what might be wrong.


      # 19.6.2 Writing pipeable functions
show_missings <- function(df) {
  n <- sum(is.na(df))
  cat("Missing values: ", n, "\n", sep = "")
  
  invisible(df)
}


library(tidyverse)
mtcars %>% 
  show_missings() %>% 
  mutate(mpg = ifelse(mpg < 20, NA, mpg)) %>% 
  show_missings() 
#> Missing values: 0
#> Missing values: 18



































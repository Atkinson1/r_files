# Two types of vectors:
  # atomic vector (which include logical, character, and numeric (of which there are integers and double); also complex and raw)
  # list

# Two key properties of a vector: its type and length
letters
typeof(letters)
length(letters)

length(list("a", "b", 1:10))

# Augmented vectors: vectors that contain arbitrary additional metadata in the form of attributes

# There are three important types of augmented vector:
    # Factors are built on top of integer vectors.
    # Dates and date-times are built on top of numeric vectors.
    # Data frames and tibbles are built on top of lists.

# Four main types of atomic vectors:

      # integer
      # double
      # logical
      # character

  # to make a number an integer, place L after the number
  # double: approximation, means use near()

# dbl, as floating point, will turn approximation
sqrt(2)^2 == 2

# near takes an x and y argument
near(sqrt(2)^2, 2)

# Integers have one special value: NA, 
# Doubles have four: NA, NaN, Inf and -Inf. 
  # All three special values NaN, Inf and -Inf can arise during division:

      # Use is.finite(), is.infinite(), and is.nan(); where NaN means not a number
c(-1,0,1)/0
# -Inf, NaN, Inf

# function to convert from double to integer
dbl_to_int <- function(x) {
  x <- as.integer(x)
}

# example of changing col_types by explicitly listing string abbreviation for the function
x <- read_csv("C:/users/ryan/desktop/exampleForCleaning.csv", col_types = list("d", "f", "c", "d", "d"))

# Explicit vs implicit coercion

  # Explicit coercion: using a function like as.logical(), as.integer(), as.double(), as.character()
  # Implicit coercion: When a vector is used in a context when a type of vector was expected

# sample(#size of the sample/sequence of integers in sample, # number of samples taken, #replace = FALSE is default)
  
x <- sample(20, 100, replace = TRUE)
y <- x > 10 # take all values from sample greater than 10
sum(y) # how many values greater than 10?
mean(y) # what proportion are greater than 10?

sample(20, 10) # take 10 samples without replacement from a list of 20 numbers containing 1:20

      # Atomic vectors:  cannot have a mix of different types
      # Lists: can have a mix of different types

# use is_* functions to test what is the type of vector

            # Scalars and recycling rules

# runif is random uniform distribution; takes values b/t 0 and 1
runif(10)
runif(10) > .5 # will return a list of TRUE/FALSE

# sample() -- vector and a scalar
sample(10) + 100

# adding vectors of diff lengths
1:10 + 1:2 # will recycle shorter vector, unless longer is not an integer multiple of the length of shorter vector

# recycling with anything other than a scalar requires a vector

  # recycles 1:2 twice
tibble(x = 1:4, y = rep(1:2, 2))
  # recycles 1:2, in order/each twice in a row
tibble(x = 1:4, y = rep(1:2, each = 2))

      # Naming vectors (most useful for subsetting)

# Named at creation with c()
c(x = 1, y = 2, z = 4)

# Named after with purrr:set_names():
set_names(1:3, c("a", "b", "c"))

      # Subsetting

# Using [] with a vector; called like x[a]
# Four types of things that you can subset a vector with:

#1: A numeric vector containing only integers. The integers must either be all positive, all negative, or zero
x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)] # pulling from index of x
x[c(1, 1, 5, 5, 5, 2)] # pulling from index
x[c(-1, -3, -5)] # dropping elements from values at index

#2: Subsetting w/ a logical vector keeps all values corresponding to a TRUE value; most often used w/ comparison functions
x <- c(10, 3, NA, 5, 8, 1, NA)
x[!is.na(x)] # subsets all non-missing values
x[x %% 2 == 0] # subsets all values divisible by 2 with no remainder

#3 If you have a named vector, can subset with character vector:
x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")]

#4 empty subset, returning all values; useful for matrices
x[]
z <- matrix(c(1,5,2,4), 2, 2)
# (1, 2)
# (5, 4)


z[1,] #returns first row, which contains 1 & 2
z[,-1] # returns second column/removes the first column

# [[]] only ever extracts a single element and always drops names
    # useful with lists; useful when making it clear that one single item is being extracted like in a for loop

# example:
z[[2]] # returns 5
z[[3]] # returns 2


      # 20.4.6

z <- c(1, 5, 2, 7, 44, 3, 7, 1)

# which() returns index position where comparison/relationship is TRUE
which(z > 3) # would return 2, 4, 5, and 7
which(letters == "R") # would return 18, where R is located by index position in the alphabet


# Create functions that take a vector as input and returns:


# The last value. Should you use [ or [[?

# The elements at even numbered positions.
z[c(seq(2, length(z), 2))]                              
# Every element except the last value.
                                       
# Only even numbers (and no missing values).
z[z %% 2 == 0]                                       


                  ### 20.5 Recursive vectors (Lists)

# to create, use list()
list_1 <- list(c(1, 2, 3))
list_1

# str(); focuses on structure, not contents
str(list_1)

# named list
list_named <- list(a = 1, b = 2, c = 3)
str(list_named)

# list with mixed objects
list_mixed <- list("a", 1L, 1.5, TRUE)
str(list_mixed)

# list of lists
list_of_lists <- list(list(1, 2), list(3, 4))
str(list_of_lists)


            # 20.5.2 Subsetting

list_sub <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))
str(list_sub)

# [] extracts a sub-list. The results will always be a list.
str(list_sub[2])

# ex2: list_sub[1] will return the numbers 1, 2, 3; those will still be of a list type

# [[]] extracts a single component from a list; and removes a level of hierarchy from the list

  # ex: takes second indexed value, removes a level to give char string "a string"
str(list_sub[[2]])
  # ex: takes fourth indexed value, doesn't remove layer; means there's a list of one that contains a list of 2
str(list_sub[4])


v1 <- unlist(list_sub[4]) # keeps name, like d1 & d2 to denote -1 & -5 
v2 <- unlist(list_sub[[4]]) # removes list layer, then unlists

# Can use [[]] in conjunction with "" to extract by name

list_sub[["b"]] # will return "a string" with a level removed
list_sub["b"] # will return "a string", but still remains a list


# $: extracting named elements of a list
list_sub$c

# removing a single layer of a list
list_sub[[4]]
# removes first list layer, then second list layer to extract first element
list_sub[[4]][[1]]


    # 20.6 Attributes

# Attributes: arbitrary additional metadata. Can be thought of as named list of vectors that can be attached to any object.
# Use attr() to get individual attributes; get all attributes with attributes()

x <- 1:10
# returns null
attr(x, "greeting")
# returns greeting that was assigned to the value
attr(x, "greeting") <- "Hi!"
attr(x, "farewell") <- "Goodbye!" 

attributes(x)


    # Three fundamental attributes for R

# 1. Names: used to name the elements of a vector
# 2. Dimensions: make a vector behave like a matrix/array
# 3. Class: used to implement the S3 object oriented system

  # Class: describe how generic functions work.
  # generic function example

# method takes the shape of Date Method and mean generic(); mean.Date()
# use ftype() to figure out whether a function is S3 method or generic

as.Date
install.packages("pryr")
library(pryr)

ftype(as.Date)

# Given a class, the job of an S3 generic is to call the right S3 method. 
# You can recognise S3 methods by their names, which look like generic.class(). 
# For example, the Date method for the mean() generic is called mean.Date(), and the factor method for print() is called print.factor().
# This is the reason that most modern style guides discourage the use of . in function names: it makes them look like S3 methods.


# The call to “UseMethod” means that this is a generic function, and it will call a specific method, a function, based on the class of the first argument. 
# (All methods are functions; not all functions are methods). You can list all the methods for a generic with methods():
methods("as.Date")



        # Augmented vectors: vectors with additional attributes, including class

# Examples of augmented vectors:
  # factors: are built on top of integers, and have a levels attribute
  # dates: numeric vectors that represent the number of days since 1 January 1970.
  # date-times: numeric vectors with class POSIXct that represent the number of seconds since 1 January 1970.
      # “POSIXct” stands for “Portable Operating System Interface”, calendar time
      # POSIXct’s are always easier to work with, so if you find you have a POSIXlt, you should always convert it to a regular data time lubridate::as_date_time()
  # tibbles: augmented lists; have names (column) and row.names attributes



























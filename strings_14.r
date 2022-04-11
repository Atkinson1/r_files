library(tidyverse)

string1 <- "This is a string"
# String: characters within quotes


# str_c: joins two or more vectors element-wise into a single character vector (vector that contains characters, with size indicating "")
x <- str_c(letters, LETTERS, sep = ":", collapse = ", ")
# sep refers to between each element; 
# collapse: how vectors joined; collapse refers to process after each element-wise vector iteration
x


        # escape backslash: used prior to single quote, double quote, backslash, period, or any other literal


# use \ before a single or double quote to include the literal version of it
double_quote <- "\""
# to see raw content of the string, use writeLines()
writeLines(double_quote) # will return "
z <- c("\"", "\\") 
writeLines(z)
# "
# \

        # Special characters:
  # "\n"          new line
  # "\t"          new tab

  # for help, use ?'"'

?'"'

      # storing multiple strings in a character vector
v <- c("one", "two", "three")
str_length(v)


      ## str_c() is vectorized; automatically recycles shorter vectors to the same length as the longest

str_c("prefix-", c("a", "b", "c"), "-suffix")

      # collapse: collapse a vector of strings into a single string

y <- str_c(letters, LETTERS, collapse = ", ")

      # 14.2.3 Subsetting strings - str_sub()

# str_sub() can be used on character vector with one string or multiple strings

x <- c("Apple", "Banana", "Pear is part of a string", "Pear")
str_sub(x, 1, 3) # extract parts of strings
  # Takes start and end arguments that give the (inclusive) portion of the substring

# to count backward, change numerics to -
str_sub(x, -3, -1)

# can use assignment form of str_sub() to modify strings
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
# start at the first, end at the first, lower the character for each string

str_subset(x, "Pe") # extracts whole string that matches a pattern

i <- c("3", "four")
str_c("apple", i)


--
  
# 14.3
###
  #

library(tidyverse)

test <- c("apple", "orange", "banana")
string_len <- str_length(test)


m <- ceiling(string_len/2)
str_sub(test, m, m) # where m means start, and end

# collapse function
transla <- str_c(c("a", "b", "c"), collapse = ", ")
# two character vectors
transla <- str_c(c("a", "b", "c"))
transla2 <- str_c(c("d", "e", "f"))
# combine character vectors into a character vector
transla3 <- str_c(transla, transla2, sep = ":", collapse = " ")
transla3
# combine each into a vector of strings
transla4 <- str_c(transla, transla2, sep="")
## str_trim(): removes whitespace from start/end of string
white_space_ex <- c(" app fsl eee")
white_space_ex %>% str_trim(side = c("both"))


      # 14.3 Matching patterns with regular expressions

# using str_view & str_view_all(): 
  # can take regex and return degree of match

x <- c("apple", "banana", "pear")
str_view(x, "an")

# . matches any character (except a newline)

str_view(x, ".a.") # return pattern that matches some char, a, then some char

    # to create regex of ., need to escape 
# matching an actual period and not the special character,
period <- "\\."
writeLines(period)

str_view(c("abc", "a.c", "bef"), "a\\.c") # this pulls a literal period

# to match a literal \, need to write \\\\

str_view_all(c(" skdf\\jwoe.askdlfjow"), "\\\\") # will pull single backslash

# In this book, I'll write regular expression as \. 
# and strings that represent the regular expression as "\\.".

    # to get a special character within a string "", need to use escape
    # \ is used as an escape character in a regular expression

test <- "thsa sit sm\nome sdkfj\n"
str_view_all(test, "\\n")

# a regular expression needs an escape before a special character
# to escape that special character in the regex, need an escape char
# to get the literal match


      # 14.3.2 Anchors
# starts with: ^
str_view_all(c("apple", "banana", "pear"), "^a")
# ends with: $
str_view_all(c("apple", "banana", "pear"), "a$")
# to force match with complete string, anchor with ^ and $
str_view_all(c("applesauce", "apple pie", "apple"), "^apple$")

# match a boundary around a word with \b -- matched with string as \\b
str_view_all(c("summary", "summation", "sum"), "\\bsum\\b")

# example of removing text whitespace after removing special character
str_replace_all("this is an example \n of a string", "\\n", "") %>% str_replace_all(., "  ", " ")


    # 14.3.3 Character classes and alternatives

# to convert a string to a character vector, use str_split
splitting_string <- str_split("This is a string /n trial based ^ on () trying to match", " ", simplify = TRUE)
# concatenating strings to a character vector
collapsing_string <- str_c(c("apple", "banana", "orange"), collapse = " ")

  ###

# Look for a literal character that normally has special meaning in a regex
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c") # will pull out period

str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c") # will pull out star

# This works for most (but not all) regex metacharacters: $ . | ? * + ( ) [ {. 
# Unfortunately, a few characters have special meaning even inside a character class 
# and must be handled with backslash escapes: ] \ ^ and -.


    # alternation: choose between patterns; either an e, an a, or both
str_view(c("grey", "gray"), "gr(e|a)y")
  # precedence for | is low, so abc|xyz matches abc, xyz, or both

#  [abc]: matches a, b, or c.
# [^abc]: matches anything except a, b, or c.

str_view_all("this is a \ string", "\\\\")

# split each sentence by a boundary; boundary could be characters, line_breas, sentences, or words
str_split(sentences, boundary("word"))
                
                      # tricks & reminders
                # creating a string that has parentheses within the string
                strings_with <- " this is a series of words \"well\"    " 
                # using a regular expression to find where those parenthesis within the string are
                str_view_all(strings_with, "\"")
                
                fruit <- c("apple", "banana", "orange", "pear")
                
                str_sub(fruit, -2, -1) # pulls from position
                str_subset(fruit, "an") # pulls string with exact match
                str_extract(fruit, "an") # pulls part of string with match, or returns NA
                str_count(fruit, "an") # returns instances of pattern in each string
                str_length(fruit) # returns number of chars per string
                
                # Example of changing a string character to uppercase
                str_replace(fruit, str_sub(fruit, 3, 3), str_to_upper(str_sub(fruit, 3, 3)))
                
                    ### using detect with a dataframe to filter rows
                
                library(dslabs)
                murders <- dslabs::murders
                murders_A <- murders %>% filter(str_detect(state, "A"))
                
                  # filtering multiple states
                states_of_interest <- c("Texas", "California", "Oklahoma")
                states_of_interest <- str_c(states_of_interest, collapse = "|")
                murders %>% filter(str_detect(state, states_of_interest))
                
                # To find all but that pattern
                murders %>% filter(str_detect(state, states_of_interest, negate = TRUE))
                
                # to change string to lower, and insert _ into blank space between words
                z <- murders %>% mutate(region = str_to_lower(murders$region)) %>%
                  mutate(region = str_replace_all(region, " ", "_"))

                                
str_view_all("$^$", "\\$\\^\\$")
    # 14.3.2.1 Exercises
# 1 matches words starting with y
str_subset(stringr::words, "^y")
# 3 matches words containing three characters
str_subset(stringr::words, "^...$")
# 4 matches words containing at least 7 or more characters
str_subset(stringr::words, "^.......$*")
str_subset(stringr::words, "^.......$?")
str_subset(stringr::words, ".......")


    # 14.3.4 Repetition
# ?: 0 or 1
# *: 0 or more
# +: 1 or more

# You can also specify the number of matches precisely:
   
# {n}: exactly n
# {n,}: n or more
# {,m}: at most m
# {n,m}: between n and m

# By default these matches are "greedy": they will match the longest string possible;
  # i.e., for {n,m}, will match m if available
# You can make them "lazy", matching the shortest string possible by putting a ? after them. 
# This is an advanced feature of regular expressions, but it's useful to know that it exists:

    #  14.3.5 Grouping and backreferences 

# () acts as a "capturing group", which can be repeated with 
# "backreferences" like \1, \2 (written in as characters as \\1, \\2)
# whatever in the parenthesis is repeated

# example; \\1 means refer back to the na and repeat it

fruit <- c("banana", "coconut", "cucumber")
str_view(fruit, "(..)\\1", match = TRUE)
str_view(fruit, "(na)\\1", match = TRUE)
  # for match: If TRUE, shows only strings that match the pattern. 
# If FALSE, shows only the strings that don't match the pattern.


          # 14.4.1 Detect matches, use sum/mean
library(tidyverse)
setwd("C:/users/ryan/desktop/r_lesson_plan")

sum(str_detect(stringr::words, "^t"))
mean(str_detect(stringr::words, "^t"))

# can use str_detect with logical conditions
  # ex: return all words that don't contain vowels
!str_detect(stringr::words, "[aeiou]")

    # str_subset == using str_detect with logical subsetting
str_subset(stringr::words, "x$")
words[str_detect(words, "x$")]

    # when using df, using filter with string detect

df <- tibble(word = stringr::words,
             i = seq_along(word))
df %>% filter(str_detect(word, "x$"))

      # str_count(): tells how many matches in a string
x <- c("apple", "banana", "pear")
str_count(x, "a")
      # str_count() and mutate
df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

      ### note: matches never overlap
str_count("abababa", "aba") # will return 2


              # 14.4.2 Extract Matches

# Trying to find all sentences that contian a color
colors <- c("red", "orange", "yellow", "green", "blue", "indigo", "violet")
colors <- str_c(colors, collapse = "|")
str_w_color <- str_subset(stringr::sentences, colors) # pull out entire sentence containing match
word_w_color <- str_extract_all(str_w_color, colors) # returns list of colors


              # 14.4.3 Grouped matches
 
# Uses of parentheses: clarifying precedence; with backreferences for matching;
  # extracting parts of a complex match

# Ex: we want to extract nouns from the sentences; in this case, noun follows from article

noun <- "(a|the) ([^ ]+)" # do not have an empty space at least once or more after an article
has_noun <- sentences %>% str_subset(noun) # returns sentences that have a match to the pattern above
has_noun %>% str_extract(noun) # extracts based on the pattern
has_noun %>% str_match(noun) # returns the match and each individual component

              # 14.4.4 Replacing matches

x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-") # replaces first instance of a pattern
str_replace_all(x, "[aeiou]", "-") # replaces all instances of a pattern

# str_replace_all() can be used with a named vector to perform multiple replacements
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "3" = "three"))

# using str_replace to alter position of word within a string
sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5)

              # 14.4.5 Splitting w/ str_split()

sentences %>% head(5) %>% str_split(" ") # will return a list
  # three ways to return a vector
"a|b|c|d" %>% str_split("\\|") %>% .[[1]] # will return a vector
"a|b|c|d" %>% str_split("\\|") %>% as_vector() # will return a vector
"a|b|c|d" %>% str_split("\\|") %>% unlist() # will return a vector


sentences %>% head(5) %>% str_split(" ", simplify = TRUE) # will return matrix

# can also split up by character, line, sentence, and word boundary()s
x <- "This is a sentence. This is another sentence."

# splitting by something other than a regular expression; a boundary.
str_view_all(x, boundary("word"))

            # 14.4.6 Find matches

# str_locate() and str_locate_all() give you the starting and ending positions of each match. 
# These are particularly useful when none of the other functions does exactly what you want. 
# You can use str_locate() to find the matching pattern, str_sub() to extract and/or modify them.

            # 14.5 Other types of pattern

# can use literal regex wrapper to set further conditions to match for
bananas <- c("banana", "BANANA", "BaNaNa")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))

# comments = TRUE allows to use comments to explain complex regex more understandable
phone <- regex("
  \\(?     # optional opening parens
  (\\d{3}) # area code
  [) -]?   # optional closing parens, space, or dash
  (\\d{3}) # another three numbers
  [ -]?    # optional space or dash
  (\\d{3}) # three more numbers
  ", comments = TRUE)

str_match("514-791-8141", phone)
#>      [,1]          [,2]  [,3]  [,4] 
#> [1,] "514-791-814" "514" "791" "814"


  # NOTE: you can use boundary() with all other str_* functions


































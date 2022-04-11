class(iris)
as_tibble(iris) %>% class()

?tibble()
?tribble()

# Creating a tribble (row-wise tibble, then unnesting list column created)
tribble(~x, ~y,
        1:4, 5:8) %>% unnest(cols = c(x, y))

# creating a tibble
tibble(x = 1:10, y = x *2, z = y * 2, phi = x*y*z, psi = seq(1, 20, 2))

# tibble recycles numbers
tibble(x = 1:5, y = 3, z = round(pi^x))

# to refer to non-syntactic names or odd characters, use backticks ``

?runif()

# 1e3 is scientific notation; 3 refers to your 0s
tibble(c = 1:1e3)

# printing more of a tibble than its top 10s
nycflights13::flights %>% print(n = 15, width = Inf)

# subsetting:
df <- tibble(x = runif(5),
             y = rnorm(5))
# subsetting with [[]]; [[col]][[row]]
df[[1]][[2]] 

# with [[]]; [[col]]
df[[1]] 

# subsetting with []; [col]
df[1]

# subsetting with []; [row, col]
df[1, 2]

# extract by name
df$x
df[["x"]]

# to extract particular values in a pipe, need to use . before $ or [[]]
df %>% .$y
df %>% .[[2]] %>% .[[3]]


annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

# renaming columns
rename(annoying, one = `1`, two = `2`)



    # tibble::enframe()

# converts vectors
enframe(1:3)
# or lists to one- or two-column data frames
enframe(list(one = 1, two = 2:3, three = 4:6))










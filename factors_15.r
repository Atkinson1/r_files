library(tidyverse)
setwd("C:/users/ryan/desktop/r_lesson_plan")

# To create a factor, must start by creating a list of the valid levels:

month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")


      # two ways to match levels to input

# Note: month_data has factor in diff order than order of levels

# match the levels list to the input of values w/ a dataframe
month_data <- tibble(month = c("Jan", "Mar", "Dec", "Jun"))
month_data2 <- factor(month_data$month, levels = month_levels)

# match the levels list to the input of values
month_data_val <- c("Jan", "Mar", "Dec", "Jun")
month_data3 <- factor(month_data_val, month_levels)


      # ordering factors to match appearance in the data

# 1.)
f2 <- factor(month_data_val, levels = unique(month_levels)) 
f2
             
# 2.) to order the factors after the fact, use fct_inorder()
f3 <- month_data$month %>% factor() %>% fct_inorder()



        ##########################

gss_cat <- forcats::gss_cat

# to get counts, use fct_count or count
fct_count(gss_cat$relig)
gss_cat %>% count(relig)

# using geom_bar() to show counts;

ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

  # Modifying factor order

# ex1: summary of averages for age, tv hours, and counts
relig_summary <- gss_cat %>% group_by(relig) %>% 
  summarise(age = mean(age, na.rm = TRUE),
            tvhours = mean(tvhours, na.rm = TRUE),
            )

ggplot(relig_summary, aes(tvhours, relig)) + geom_point()

# reordering with fct_reorder()
ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) + # reorder y based on x/some var
  geom_point()

        # When coloring a line graph, use fct_reorder2()
      # fct_reorder2 reorders factor by y values associated w/ largest x values

by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  count(age, marital) %>%
  group_by(age) %>%
  mutate(prop = n / sum(n)) # proportion column created 

ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) + # first argument is factor, then x, then y
  geom_line() +
  labs(colour = "marital")

        # bar chart; 
    # use fct_infreq: lists factors by number of observations with each level (largest first)
    # fct_rev: reverses order of factors

gss_cat %>% mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()


      # https://r4ds.had.co.nz/factors.html
# Other useful factor functions:

# fct_recode()
# fct_collapse()
# fct_lump()



gss_cat %>% count(partyid)
#> # A tibble: 10 x 2
#>   partyid                n
#>   <fct>              <int>
#> 1 No answer            154
#> 2 Don't know             1
#> 3 Other party          393
#> 4 Strong republican   2314
#> 5 Not str republican  3032
#> 6 Ind,near rep        1791
#> # … with 4 more rows

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)
#> # A tibble: 10 x 2
#>   partyid                   n
#>   <fct>                 <int>
#> 1 No answer               154
#> 2 Don't know                1
#> 3 Other party             393
#> 4 Republican, strong     2314
#> 5 Republican, weak       3032
#> 6 Independent, near rep  1791
#> # … with 4 more rows


gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
  )) %>%
  count(partyid)
#> # A tibble: 8 x 2
#>   partyid                   n
#>   <fct>                 <int>
#> 1 Other                   548
#> 2 Republican, strong     2314
#> 3 Republican, weak       3032
#> 4 Independent, near rep  1791
#> 5 Independent            4119
#> 6 Independent, near dem  2499
#> # … with 2 more rows

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)
#> # A tibble: 4 x 2
#>   partyid     n
#>   <fct>   <int>
#> 1 other     548
#> 2 rep      5346
#> 3 ind      8409
#> 4 dem      7180

gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)
#> # A tibble: 2 x 2
#>   relig          n
#>   <fct>      <int>
#> 1 Protestant 10846
#> 2 Other      10637























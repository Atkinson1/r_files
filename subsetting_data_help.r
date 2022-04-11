### subsetting and changing data

df_trial <- tribble(~apple, ~"banana",
                    1, 2,
                    3, 4)

df_trial[df_trial > 3] <- 0
df_trial




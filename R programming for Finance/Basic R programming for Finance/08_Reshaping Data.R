library(tidyverse)

# Spread
table2 %>%
  spread(key=type, value=count)

# Gather
table4a %>%
  gather("1999", "2000", key = "year", value = "cases")

# Separate
table3 %>%
  separate(rate,
           into = c("cases", "population"),
           sep="/")

# Unite
table5 %>%
  unite(col = "year", 
        "century", "year", 
        sep="/")






















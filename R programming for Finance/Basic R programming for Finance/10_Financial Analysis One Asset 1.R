library(tidyverse)
library(tidyquant)

#------------------------------------------------------------------------------#

# Get data
PTT.tb <- tq_get("PTT.BK", 
                 get = "stock.prices", 
                 from = "2010-01-01")

# Calculate RSI
PTT.RSI.tb <- PTT.tb %>% tq_mutate(
  select=adjusted,
  mutate_fun=RSI
) %>% tq_mutate(
  select=rsi,
  mutate_fun=EMA,
  n=9
)  

# Plot line graph
PTT.RSI.tb %>% ggplot() +
  geom_line(mapping=aes(x=date, y=rsi)) +
  geom_line(mapping=aes(x=date, y=EMA), color="red")


#------------------------------------------------------------------------------#

# Basic FinancialAnalysis: Single Assets

# Get SCC data
SCC <-tq_get("SCC.BK", 
             get = "stock.prices",
             from = "2010-01-01") %>%
  na.omit() %>%
  tq_transmute(select = adjusted,
               mutate_fun= periodReturn,
               period = "monthly",
               col_rename= "Ra"
  )

# Get SET data
SET.Ret <- tq_get("^SET.BK",
                  get = "stock.prices",
                  from = "2010-01-01") %>%
  na.omit() %>%
  tq_transmute(select = adjusted,
               mutate_fun= periodReturn,
               period = "monthly",
               col_rename= "Rm"
  )

# Join datasets
Return.Data <-
  SCC %>% inner_join(SET.Ret, by = "date")


# Analysis with CAPM
Return.CAPM <-
  Return.Data %>% 
  tq_performance(Ra = Ra,
                 Rb= Rm,
                 performance_fun= table.CAPM)

tq_performance_fun_options()

#---------------------------------------#

# or get data

return_data <- tq_get(c("SCC.BK","^SET.BK"),
                      get = "stock.prices",
                      from = "2010-01-01") %>%
  na.omit() %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted,
               mutate_fun= periodReturn,
               period = "monthly",
               col_rename= "Return") %>%# change column name
  spread(key=symbol, value=Return)

# return_data$SET <- return_data[["^SET.BK"]] # Change col name of ^SET.BK

# https://www.geeksforgeeks.org/change-column-name-of-a-given-dataframe-in-r/#:~:text=Column%20names%20are%20addressed%20by%20unique%20names.%20colnames,name%20of%20the%20column%20in%20the%20data%20frame.
# Change col names
colnames(return_data) <- c("date", "SET", "SCC")


# Create CAPM table
SCC.CAPM <- return_data %>% tq_performance(
  Ra = SCC,
  Rb = SET,
  performance_fun = table.CAPM)

tq_performance_fun_options()

return_data %>% tq_performance(
  Ra = SCC,
  Rb = SET,
  performance_fun = CAPM.beta)

#------------------------------------------------------------------------------#

# Get Multiple stocks data
stock.names<-c("PTT.BK", 
               "SCC.BK", 
               "CPF.BK", 
               "KBANK.BK",
               "BBL",
               "WHA.BK",
               "CPALL")

return_data <- tq_get(stock.names, 
                      get = "stock.prices",
                      from = "2010-01-01") %>%
  na.omit() %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted,
               mutate_fun= periodReturn,
               period = "monthly",
               col_rename= "Return")


# Get SET data
benchmark_data <- tq_get("^SET.BK",
                         get = "stock.prices",
                         from = "2010-01-01") %>%
  na.omit() %>%
  tq_transmute(select = close,
               mutate_fun= periodReturn,
               period = "monthly",
               col_rename= "Benchmark")


# Join datasets
data_table <- return_data %>% 
  inner_join(benchmark_data,
             by = "date") %>%
  na.omit()

CAPM_table <- data_table %>% 
  tq_performance(Ra = Return,
                 Rb = Benchmark,
                 performance_fun = table.CAPM) %>%
  select(symbol, Beta)

Return_table <- data_table %>%
  summarize(mean_return = mean(Return))

summary_table <- Return_table %>%
  inner_join(CAPM_table, by = "symbol")

ggplot(data=summary_table) +
  geom_point(mapping=aes(x=Beta, y=mean_return))


#------------------------------------------------------------------------------#



















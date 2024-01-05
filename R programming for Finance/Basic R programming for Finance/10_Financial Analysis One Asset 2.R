library(tidyverse)
library(tidyquant)

#------------------------------------------------------------------------------#

# Basic FinancialAnalysis: Single Assets

# Get SCC data
SCC <-tq_get("SCC.BK", 
             from = "2012-01-01", 
             to = "2017-12-31") %>%
  na.omit() %>%
  tq_transmute(select = adjusted,
               mutate_fun= periodReturn,
               period = "monthly",
               col_rename= "Ra")

SET.Ret <- tq_get("^SET.BK", 
                  from = "2012-01-01", 
                  to = "2017-12-31") %>%
  na.omit() %>%
  tq_transmute(select = close,
               mutate_fun= periodReturn,
               period = "monthly",
               col_rename= "Rm")

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

#------------------------------------------------------------------------------#

# Basic FinancialAnalysis: Multiple Assets

stock.names<-c("PTT.BK", "SCC.BK", "CPF.BK", "KBANK.BK")

stock.data <- tq_get(stock.names, 
                     from = "2012-01-01", 
                     to = "2017-12-31") %>%
  na.omit() %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted,
               mutate_fun= periodReturn,
  #            period = "monthly",
               period = "daily",
               col_rename= "Stock.Ret")


#get SET data
SET.Ret <- tq_get("^SET.BK", 
                  from = "2012-01-01", 
                  to = "2017-12-31") %>%
  na.omit() %>%
  tq_transmute(select = close,
               mutate_fun= periodReturn,
               #period = "monthly",
               period = "daily",
               col_rename= "Rm")


# Join datasets
Return.Data <- stock.data %>% 
  inner_join(SET.Ret,
             by = "date")

# Analysis with CAPM
Return.CAPM <- Return.Data %>% 
  tq_performance(Ra = Ra,
                 Rb = Rm,
                 performance_fun = table.CAPM)

write.csv(Return.CAPM, "/Users/Admin/Documents/Project_R/InClass/capm.csv")

#------------------------------------------------------------------------------#





































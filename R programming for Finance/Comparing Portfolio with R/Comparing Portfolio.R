##### Library Packages #####
library(tidyverse) # for data manipulation
library(tidyquant) # for financial data

#-----------------------------------------------------------------------------#

# Set date
date_from = "2016-01-01"
date_to = "2022-11-30"

#-----------------------------------------------------------------------------#

## Set stocks symbol what interests

# Portfolio 1 : Get Blue chip 7 stocks and Defensive stock 3 stocks
stocks_symbol_1 <- c("PTTEP.BK", "BH.BK", "BANPU.BK", "KTB.BK", 
                     "MINT.BK", "BDMS.BK", "AOT.BK",
                     "AP.BK", "BCT.BK", "QH.BK") %>% sort()
# Portfolio 2 : Get Growth stock 7 stocks and Defensive stock 3 stocks
stocks_symbol_2 <- c("M.BK", "CPF.BK", "CPALL.BK", "SPRC.BK", 
                     "STEC.BK", "CK.BK", "AMATA.BK",
                     "RATCH.BK", "SCC.BK", "SPALI.BK") %>% sort()

#-----------------------------------------------------------------------------#

# Get stocks return portfolio 1
stocks_return_1 <- stocks_symbol_1 %>%
  tq_get(from = date_from,
         to = date_to) %>%
  na.omit() %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "daily",
               col_rename = "stock_return")

# Get stocks return portfolio 2
stocks_return_2 <- stocks_symbol_2 %>%
  tq_get(from = date_from,
         to = date_to) %>%
  na.omit() %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "daily",
               col_rename = "stock_return")

# Get SET Index data
set_index_return <- tq_get("^SET.BK",
                           from = date_from,
                           to = date_to) %>% 
  na.omit() %>%
  tq_transmute(select = adjusted, 
               mutate_fun = periodReturn,
               period = "daily",
               col_rename = "set_return")

#-----------------------------------------------------------------------------#

# Portfolio 1 : ดูภาพรวมของข้อมูล retu่rn
stock_stat_1 <- stocks_return_1 %>%
  tq_performance(Ra = stock_return,
                 performance_fun = table.Stats)
stock_stat_1

# Portfolio 2 : ดูภาพรวมของข้อมูล retu่rn
stock_stat_2 <- stocks_return_2 %>%
  tq_performance(Ra = stock_return,
                 performance_fun = table.Stats)
stock_stat_2

# SET index : ดูภาพรวมของข้อมูล retu่rn
set_index_stat <- set_index_return %>%
  tq_performance(Ra = set_return,
                 performance_fun = table.Stats)
set_index_stat

#-----------------------------------------------------------------------------#

# Get Return of Portfolio 1
portfolio_return_1 <- stocks_return_1 %>% 
  tq_portfolio(assets_col = symbol,
               returns_col = stock_return,
               weights = NULL,
               col_rename = "port_return")

# Get Return of Portfolio 2
portfolio_return_2 <- stocks_return_2 %>% 
  tq_portfolio(assets_col = symbol,
               returns_col = stock_return,
               weights = NULL,
               col_rename = "port_return")

#-----------------------------------------------------------------------------#

# Joining Portfolio 1 with set for CAPM model
port_set_return_1 <- portfolio_return_1 %>% 
  inner_join(set_index_return,
             by = "date")


# Joining Portfolio 2 with set for CAPM model
port_set_return_2 <- portfolio_return_2 %>% 
  inner_join(set_index_return,
             by = "date")

#-----------------------------------------------------------------------------#


# Stock in Porfolio 1 : Analysis with CAPM and get stock beta
capm_1 <- port_set_return_1 %>% 
  tq_performance(Ra = port_return,
                 Rb = set_return,
                 performance_fun = table.CAPM) %>%
  mutate(Portfolio = "Portfolio_1") %>%
  select(Portfolio, Beta, InformationRatio, TrackingError, TreynorRatio, Correlation)


# Stock in Portfolio 2 : Analysis with CAPM and get stock beta
capm_2 <- port_set_return_2 %>% 
  tq_performance(Ra = port_return,
                 Rb = set_return,
                 performance_fun = table.CAPM) %>%
  mutate(Portfolio = "Portfolio_2") %>%
  select(Portfolio, Beta, TreynorRatio, TrackingError, InformationRatio, Correlation)

#-----------------------------------------------------------------------------#

# Stock in Porfolio 1 : Analysis with Sharpe Ratio
sharpe_ratio_1 <- port_set_return_1 %>% 
  tq_performance(Ra = port_return,
                 performance_fun = table.AnnualizedReturns) %>%
  mutate(Portfolio = "Portfolio_1")


# Stock in Portfolio 2 : Analysis with Sharpe Ratio
sharpe_ratio_2 <- port_set_return_2 %>% 
  tq_performance(Ra = port_return,
                 performance_fun = table.AnnualizedReturns) %>%
  mutate(Portfolio = "Portfolio_2")

#-----------------------------------------------------------------------------#

# Stock in Porfolio 1 : Analysis with Jensen model
jensen_alpha_1 <- port_set_return_1 %>% 
  tq_performance(Ra = port_return,
                 Rb = set_return,
                 performance_fun = CAPM.jensenAlpha) %>%
  mutate(Portfolio = "Portfolio_1")


# Stock in Portfolio 2 : Analysis with Jensen model
jensen_alpha_2 <- port_set_return_2 %>% 
  tq_performance(Ra = port_return,
                 Rb = set_return,
                 performance_fun = CAPM.jensenAlpha) %>%
  mutate(Portfolio = "Portfolio_2")

#-----------------------------------------------------------------------------#

# Joining all portfolio ratio
all_ratio_1 <- capm_1 %>%
  inner_join(sharpe_ratio_1, by="Portfolio") %>%
  inner_join(jensen_alpha_1, by="Portfolio")
  
all_ratio_2 <- capm_2 %>%
  inner_join(sharpe_ratio_2, by="Portfolio") %>%
  inner_join(jensen_alpha_2, by="Portfolio")

all_ratio <- bind_rows(all_ratio_1, all_ratio_2)

#-----------------------------------------------------------------------------#

# Calculate portfolio 1 cumulative growth
port_growth_1 <- stocks_return_1 %>%
  tq_portfolio(assets_col= symbol,
               returns_col= stock_return,
               weights = NULL,
               col_rename= "port.growth",
               wealth.index= TRUE)

# Calculate portfolio 2 cumulative growth
port_growth_2 <- stocks_return_2 %>%
  tq_portfolio(assets_col= symbol,
               returns_col= stock_return,
               weights = NULL,
               col_rename= "port.growth",
               wealth.index= TRUE)

# Calculate SET cumulative growth
set_growth <- set_index_return %>% 
  mutate(symbol="SET") %>%
  tq_portfolio(assets_col= symbol,
               returns_col= set_return,
               col_rename= "benchmark.growth",
               wealth.index= TRUE)

#-----------------------------------------------------------------------------#

# plot cumulative set return
port_cul_graph <- ggplot() +
  geom_line(
    data=port_growth_1,
    mapping=aes(x=date, y=port.growth),
    color="blue") +
  geom_line(
    data=port_growth_2,
    mapping=aes(x=date, y=port.growth),
    color="green") + 
  geom_line(
    data=set_growth,
    mapping=aes(x=date, y=benchmark.growth),
    color="orange") + 
  labs(x = "Date",
       y = "Portfolio Cumulative Growth",
       title = "Comparing Portfolio 1, Portfolio 2, SET Cumulative Growth")
port_cul_graph

#-----------------------------------------------------------------------------#





























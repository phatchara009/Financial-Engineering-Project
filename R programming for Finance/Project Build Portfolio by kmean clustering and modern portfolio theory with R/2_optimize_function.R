#############################################################################################################
##### Optimization portfolio ##########################################################################################
#############################################################################################################

library(tidyverse) # data manipulation
library(tidyquant) # for finance data
library(plotly) # To create interactive charts
library(timetk) # To manipulate the data series

#-----------------------------------------------------------------------------#

# Set working directory
path = "C:\\Users\\Admin\\Documents\\Project_R/"

# Set date
date_from = "2016-01-01"
date_to = "2021-12-31"

# Create name of stock in SET50 (exclude AWC.BK, BRGRIM.BK, CRC.BK, GULF.BK, 
# ,OSP.BK, SCGP.BK, SCB.BK, TIDLOR.BK and OR.BK) 
# summary 41 symbols
symbols_set50 <- c("ADVANC.BK", "AOT.BK", "BANPU.BK", "BBL.BK", "BDMS.BK",
                   "BEM.BK", "BH.BK", "BLA.BK", "BTS.BK", "CBG.BK", 
                   "CPALL.BK", "CPF.BK", "CPN.BK", "DTAC.BK", "EA.BK",
                   "EGCO.BK", "GLOBAL.BK", "GPSC.BK", "HMPRO.BK", "INTUCH.BK",
                   "IRPC.BK", "IVL.BK", "JMART.BK", "JMT.BK", "KBANK.BK", 
                   "KCE.BK", "KTB.BK", "KTC.BK", "LH.BK", "MINT.BK", 
                   "MTC.BK", "PTT.BK", "PTTEP.BK", "PTTGC.BK", "SAWAD.BK", 
                   "SCC.BK",  "TISCO.BK", "TOP.BK", "TRUE.BK", "TTB.BK", 
                   "TU.BK")

#-----------------------------------------------------------------------------#

# Function for get Maximum Sharpe Ratios of each stock in each cluster (Risk free rate = 0%)
symbol_optimize_func <- function() {
  
  # Get Sharpe Ratio
  stocks_sharpe_ratio <- tq_get(symbols_set50,
                                from = date_from,
                                to = date_to) %>% 
    na.omit() %>%
    group_by(symbol) %>%
    tq_transmute(select = adjusted, 
                 mutate_fun = periodReturn,
                 period = "daily",
                 col_rename = "stock_ret") %>% 
    tq_performance(Ra = stock_ret,
                   performance_fun = SharpeRatio.annualized) %>%
    rename("sharpe_ratio" = "AnnualizedSharpeRatio(Rf=0%)") %>%
    left_join(read_csv(paste0(path, "data/all_cluster.csv")), 
              by = "symbol")
  
  # Set number of cluster
  k = max(read_csv(paste0(path,"data/all_cluster.csv"))$km.cluster) %>% 
    as.numeric()
  
  # create empty dataframes
  symbol_max_sr_each_cluster <- data.frame(symbol = character(),
                                           sharpe_ratio = integer())
  # loop for get maximum Sharpe ratio of each cluster and append to empty tibble
  for (i in 1:k) {
    x <- stocks_sharpe_ratio %>% 
      filter(km.cluster==i)
    x <- stocks_sharpe_ratio %>% 
      filter(sharpe_ratio==max(x$sharpe_ratio)) %>%
      select(symbol, sharpe_ratio)
    symbol_max_sr_each_cluster <- bind_rows(symbol_max_sr_each_cluster, x)
  }
  
  # return symbol_max_sr_each_cluster
  return(symbol_max_sr_each_cluster)
}

# Get symbol of portfolio for optimization
portfolio_optimization <- symbol_optimize_func() %>% as.data.frame()
portfolio_optimization %>% write_csv(paste0(path, "data/portfolio_optimization.csv"))
symbol_for_optimization <- portfolio_optimization[["symbol"]]

#-----------------------------------------------------------------------------#

# create function for optimization portfolio
optimize_function <- function(symbol,
                              num_loop) {
  
  #-----------------------------------------------------------------------------#
  
  # Storing return of stock
  stock_daily_returns <- symbol %>%
    tq_get(from = date_from,
           to = date_to) %>%
    group_by(symbol) %>%
    tq_transmute(select = adjusted,
                 mutate_fun = periodReturn,
                 period = "daily",
                 col_rename = "stock_ret")
  
  #-----------------------------------------------------------------------------#
  
  # Calculating geometric mean return of each stocks
  geometric_mean_ret <- stock_daily_returns %>%
    tq_performance(Ra = stock_ret, 
                   performance_fun = Return.annualized,
                   scale = 252)
  
  # Calculating covariance matrix of each stocks
  cov_matrix <- stock_daily_returns %>%
    spread(symbol, value = stock_ret) %>%
    select(!(date)) %>% 
    cov() * 252
  
  #-----------------------------------------------------------------------------#
  
  # Define number of loop
  num_port <- num_loop
  
  # Creating a matrix to store the weights
  all_wts <- matrix(nrow = num_port,
                    ncol = length(symbol))
  
  # Creating an empty vector to store
  # Portfolio returns
  port_returns <- vector("numeric", length = num_port)
  
  # Creating an empty vector to store
  # Portfolio Standard deviations
  port_risk <- vector("numeric", length = num_port)
  
  # Creating an empty vector to store
  # Portfolio Sharpe Ratios
  sharpe_ratio <- vector("numeric", length = num_port)
  
  #-----------------------------------------------------------------------------#
  
  # Loop storing weight, return, standard deviation and Sharpe ratio
  for (i in seq_along(port_returns)) {
    
    # random weight and adjusted sum weight = 1
    wts <- runif(length(symbol))
    wts <- wts/sum(wts)
    # Storing weight in the matrix
    all_wts[i,] <- wts
    
    # Calculating portfolio annualized return
    port_ret <- sum(wts * geometric_mean_ret$AnnualizedReturn)
    # Storing portfolio annualized returns
    port_returns[i] <- port_ret
    
    # Calculating portfolio risk (standard deviation)
    port_sd <- sqrt(t(wts) %*% (cov_matrix  %*% wts))
    # Storing portfolio risks (standard deviation)
    port_risk[i] <- port_sd
    
    # Calculating portfolio Sharpe ratio
    port_sr <- port_ret / port_sd
    # Storing portfolio Sharpe ratio (Assuming 0% Risk free rate)
    sharpe_ratio[i] <- port_sr
  }
  
  #-----------------------------------------------------------------------------#
  
  # Create portfolio values to store returns, risks and Sharpe ratios
  portfolio_values <- tibble(Return = port_returns,
                             Risk = port_risk,
                             SharpeRatio = sharpe_ratio)
  
  # Rename columns all weights by symbol
  all_wts <- tk_tbl(all_wts)
  colnames(all_wts) <- symbol
  
  # Combing all the values together
  portfolio_values <- tk_tbl(cbind(all_wts, portfolio_values))
  
  #-----------------------------------------------------------------------------#
  
  # Create min_var to store minimum variance
  min_var <- portfolio_values[which.min(portfolio_values$Risk),]
  # Create max_sr to store maximum Sharpe ratio
  max_sr <- portfolio_values[which.max(portfolio_values$SharpeRatio),]
  
  #-----------------------------------------------------------------------------#
  
  # Storing bar plot weight of minimum variance
  barplot_wts_min_var <- min_var %>%
    gather(-(Return:SharpeRatio), 
           key = Asset,
           value = Weights) %>%
    mutate(Asset = as.factor(Asset)) %>%
    ggplot(aes(x = fct_reorder(Asset,Weights), 
               y = Weights, fill = Asset)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    labs(x = "Assets", 
         y = "Weights", 
         title = "Bar plot : Minimum Variance Portfolio Weights") +
    scale_y_continuous(labels = scales::percent) 
  
  # Storing bar plot weight of maximum Sharpe ratio  
  barplot_wts_max_sr <- max_sr %>%
    gather(-(Return:SharpeRatio),
           key = Asset,
           value = Weights) %>%
    mutate(Asset = as.factor(Asset)) %>%
    ggplot(aes(x = fct_reorder(Asset,Weights), 
               y = Weights, fill = Asset)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    labs(x = "Assets", 
         y = "Weights", 
         title = "Bar plot : Maximum Sharpe Ratio Portfolio Weights") +
    scale_y_continuous(labels = scales::percent) 
  
  # Storing graph Efficient frontier
  eff_frontier <- portfolio_values %>%
    ggplot(aes(x = Risk, y = Return, color = SharpeRatio)) +
    geom_point() +
    theme_classic() +
    scale_y_continuous(labels = scales::percent) +
    scale_x_continuous(labels = scales::percent) +
    labs(x = "Annualized Risk",
         y = "Annualized Returns",
         title = "Efficient Frontier") +
    geom_point(aes(x = Risk,
                   y = Return), data = min_var, color = "brown1") +
    geom_point(aes(x = Risk,
                   y = Return), data = max_sr, color = "red")
  
  #-----------------------------------------------------------------------------#
  
  # Storing and return result
  result <- list(
    portfolio_values = portfolio_values,
    min_var = min_var,
    max_sr = max_sr,
    barplot_wts_min_var = barplot_wts_min_var,
    barplot_wts_max_sr = barplot_wts_max_sr,
    eff_frontier = eff_frontier
  )
  return(result)
}

#-----------------------------------------------------------------------------#

# Get list of optimal portfolio 
# : Storing : 
# Portfolio 100000 portfolios
# Portfolio : Minimum variance
# Portfolio : Maximum Sharpe ratio
# bar plot for plot weight of Portfolio Maximum Sharpe ratio
# bar plot for plot weight of Portfolio Minimum variance
# Efficient frontier graph
optimal_portfolio <- 
  optimize_function(symbol = symbol_for_optimization,
                    num_loop = 100000)

#-----------------------------------------------------------------------------#

## Save table and graph by loop
# export portfolio values of each portfolio to .csv
port_val <- optimal_portfolio$portfolio_values
port_val %>%
  write_csv(paste0(path, "data/optimize_portfolio_values.csv"))

# export min varaince of each portfolio to .csv
min_var <- optimal_portfolio$min_var
min_var %>%
  write_csv(paste0(path, "data/optimize_portfolio_min_var.csv"))

# export max sharpe ratio of each portfolio to .csv
max_sr <- optimal_portfolio$max_sr
max_sr %>%
  write_csv(paste0(path, "data/optimize_portfolio_max_sr.csv"))

# plot and export bar plot of min variance weight to .png
bar_min_var <- optimal_portfolio$barplot_wts_min_var
png(file = paste0(path, "graph/barplot_wts_min_var.png"))
plot(bar_min_var)
dev.off()

# plot and export bar plot of max sharpe ratio weight to .png
bar_max_sr <- optimal_portfolio$barplot_wts_max_sr
png(file = paste0(path, "graph/barplot_wts_max_sr.png"))
plot(bar_max_sr)
dev.off()

# plot and export graph efficient frontier to .png
eff_frontier <- optimal_portfolio$eff_frontier
png(file = paste0(path, "graph/efficient_frontier.png"))
plot(eff_frontier)
dev.off()

#-----------------------------------------------------------------------------#

# Plot graph by "Plotly" package
ggplotly(bar_min_var)
ggplotly(bar_max_sr)
ggplotly(eff_frontier)

#-----------------------------------------------------------------------------#
#############################################################################################################
##### Calculated portfolio growth ###########################################################################
#############################################################################################################

library(tidyverse) # data manipulation
library(tidyquant) # for finance data

# Set working directory
path = "C:\\Users\\Admin\\Documents\\Project_R/"

# Set date
date_from = "2016-01-01"
date_to = "2021-12-31"

#--------------------------------------------------------------------------------------#

# Read optimize_portfolio_max_sr.csv
max_sr <- read_csv(paste0(path, "data/optimize_portfolio_max_sr.csv"))
max_sr

# Read optimize_portfolio_min_var.csv
min_var <- read_csv(paste0(path, "data/optimize_portfolio_min_var.csv"))
min_var

# Get symbol portfolio
portfolio_symbol <- read_csv(paste0(path, "data/portfolio_optimization.csv"))[["symbol"]]

#--------------------------------------------------------------------------------------#

# Create function for plot portfolio growth graph what compare with SET index
port_growth_func <- function(port_symbol,
                             port_wts = NULL) {

  #--------------------------------------------------------------------------------------#
  
  # Get portfolio growth
  portfolio_growth <- port_symbol %>% 
    tq_get(from = date_from,
           to = date_to) %>%
    na.omit() %>%
    group_by(symbol) %>%
    tq_transmute(select = adjusted,
                 mutate_fun= periodReturn,
                 period = "daily",
                 col_rename = "stock_return") %>%
    tq_portfolio(assets_col = symbol, 
                 returns_col = stock_return,
                 weights = port_wts,
                 col_rename= "port_growth",
                 wealth.index= TRUE)
  
  #--------------------------------------------------------------------------------------#
  
  # Get benchmark growth
  benchmark_growth <- tq_get("^SET.BK",
                             from = date_from,
                             to = date_to) %>%
    na.omit() %>%
    tq_transmute(select = adjusted,
                 mutate_fun= periodReturn,
                 period = "daily",
                 col_rename= "set_return") %>%
    mutate(symbol="SET.BK") %>%
    tq_portfolio(assets_col= symbol,
                 returns_col= set_return,
                 col_rename= "set_growth",
                 wealth.index= TRUE) 
  
  #--------------------------------------------------------------------------------------#
  
  # Plot comparison graph between portfolio and SET index
  port_graph <- ggplot() +
    geom_line(
      data=portfolio_growth,
      mapping=aes(x=date, y=port_growth),
      color="blue") +
    geom_line(
      data=benchmark_growth,
      mapping=aes(x=date, y=set_growth),
      color="red") + 
    theme_bw() 
  
  return(port_graph)
}

#--------------------------------------------------------------------------------------#

# Create function for get optimal weight
get_opti_wts_func <- function(data) {
  opti_wts_port <- data %>%
    select(-Return, -Risk, -SharpeRatio)
  opti_wts_port <- data.frame(r1=names(opti_wts_port), 
                              t(opti_wts_port), 
                              row.names = NULL)
  colnames(opti_wts_port) <- c("symbol", "weights")
  return(opti_wts_port)
}

# Get optimal weight of maximum Sharpe ratio portfolio 
opti_wts_max_sr <- get_opti_wts_func(data = max_sr)
opti_wts_max_sr
# Get optimal weight of minimum variance portfolio
opti_wts_min_var <- get_opti_wts_func(data = min_var)
opti_wts_min_var 

#--------------------------------------------------------------------------------------#

# Use Maximum Sharpe Ratio weights
# Create graph from optimal weight maximum Sharpe ratio portfolio
opti_wts_max_sr_graph <- port_growth_func(port_symbol = portfolio_symbol, 
                                          port_wts = opti_wts_max_sr)
png(file=paste0(path,"graph/portgrowth_optimal_weight_max_sr_graph.png"))
plot(opti_wts_max_sr_graph + 
       labs(x = "Date",
            y = "Return",
            title = "Portfolio growth return : Optimal weight from maximum Sharpe ratio"))
dev.off()

# Use Minimum variance weights
# Create graph from optimal weight minimum variance portfolio
opti_wts_min_var_graph <- port_growth_func(port_symbol = portfolio_symbol, 
                                           port_wts = opti_wts_min_var)
png(file=paste0(path,"graph/portgrowth_optimal_weight_min_var_graph.png"))
plot(opti_wts_min_var_graph + 
       labs(x = "Date",
            y = "Return",
            title = "Portfolio growth return : Optimal weight from minimum variance"))
dev.off()

# Use eqully-weighted
# Create graph from equally weight portfolio
eq_wts_graph <- port_growth_func(port_symbol = portfolio_symbol)
png(file=paste0(path,"graph/portgrowth_equally_weight_graph.png"))
plot(eq_wts_max_sr_graph + 
       labs(x = "Date",
            y = "Return",
            title = "Portfolio growth return : Equally weight"))
dev.off()

#--------------------------------------------------------------------------------------#

#############################################################################################################
#############################################################################################################
#############################################################################################################
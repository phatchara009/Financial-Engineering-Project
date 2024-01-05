library(tidyverse)
library(tidyquant)

my_portfolio_analysis <- function(
    stock.names=c("SCC.BK"),
    port.weights=c(1.0),
    from="2010-01-01") {
  
  # table of portfolio weights
  port.wts <- tibble(
    symbols = stock.names,
    weights = port.weights)
  
  # table of stock returns
  stock.data <- tq_get(stock.names, 
                       from = from) %>% 
    na.omit() %>%group_by(symbol) %>%
    tq_transmute(select = adjusted,
                 mutate_fun= periodReturn,
                 period = "monthly",
                 col_rename = "Stock.Ret")
  
  port.ret <- stock.data %>%
    tq_portfolio(assets_col = symbol,
                 returns_col = Stock.Ret,
                 weights = port.wts)
  
  # Get SET data
  benchmark_data <- tq_get("^SET.BK",
                           from = from) %>%
    na.omit() %>%
    tq_transmute(select = adjusted,
                 mutate_fun= periodReturn,
                 period = "monthly",
                 col_rename= "Benchmark")
  
  # Add benchmark to port.ret table
  port.ret <- port.ret %>%
    inner_join(benchmark_data, by = "date")
  
  # Get beta of portfolio
  port.performance <- port.ret %>% 
    tq_performance(Ra = portfolio.returns,
                   Rb = Benchmark,
                   performance_fun= table.CAPM)
  
  # Calculate portfolio cumulative growth
  port.growth <- stock.data %>%
    tq_portfolio(assets_col= symbol,
                 returns_col= Stock.Ret,
                 weights = port.wts,
                 col_rename= "port.growth",
                 wealth.index= TRUE)
  
  # add column to SET data
  benchmark_data <- benchmark_data %>%
    mutate(symbol="SET")
  
  # Calculate cumulative return of SET
  benchmark.growth <- benchmark_data %>%
    tq_portfolio(assets_col= symbol,
                 returns_col= Benchmark,
                 col_rename= "benchmark.growth",
                 wealth.index= TRUE)
  
  # plot cumulative set return
  port.graph <- ggplot() +
    geom_line(
      data=port.growth,
      mapping=aes(x=date, y=port.growth),
      color="blue") +
    geom_line(
      data=benchmark.growth,
      mapping=aes(x=date, y=benchmark.growth),
      color="red")
  
  result <- list(
    port.table=port.performance,
    port.graph=port.graph
  )
  
  return(result)
}


# Use our function
result <- my_portfolio_analysis(
  stock.names = c("SCC.BK", "PTT.BK"),
  port.weights = c(0.25, 0.75),
  from="2012-01-01")

result["port.graph"]
result["port.table"]
result































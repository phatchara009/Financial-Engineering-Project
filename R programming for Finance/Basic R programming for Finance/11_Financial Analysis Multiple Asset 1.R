library(tidyverse)
library(tidyquant)

#--------------------------------------------------------------------------------------#

# vector of stock names to use
stock.names <- c(
  "PTT.BK",
  "SCC.BK",
  "CPF.BK",
  "KBANK.BK"
)

# table of portfolio weights
port.wts <- tibble(
  symbols = stock.names,
  weights = c(0.25, 0.25, 0.25, 0.25) # ควรรวมกันแล้วเท่ากับ 1
)
# ถ้ารวมกันไม่เท่ากับ 1 ตัวโค้ดจะ normalize ด้วยตัวเอง

#--------------------------------------------------------------------------------------#

# table of stock returns
stock.data <- tq_get(stock.names, 
                     from = "2012-01-01") %>% 
  na.omit() %>%group_by(symbol) %>%
  tq_transmute(select = adjusted,
               mutate_fun= periodReturn,
               period = "monthly",
               col_rename = "Stock.Ret")


port.ret <- stock.data %>%
  tq_portfolio(assets_col = symbol, # กำหนด col ชื่อสินทรัพย์
               returns_col = Stock.Ret, # กำหนด col ที่เป็น return ของแต่ละสินทรัพย์
               weights = port.wts) # กำหนด weight หรือน้ำหนักของแต่ละหุ้น


# Get SET data
benchmark_data <- tq_get("^SET.BK",
                         from = "2012-01-01") %>%
  na.omit() %>%
  tq_transmute(select = adjusted,
               mutate_fun= periodReturn,
               period = "monthly",
               col_rename= "Benchmark")

#--------------------------------------------------------------------------------------#

# Add benchmark to port.ret table
port.ret <- port.ret %>%
  inner_join(benchmark_data, by = "date")

# Get beta of portfolio
port.performance <- port.ret %>% 
  tq_performance(Ra = portfolio.returns,
                 Rb = Benchmark,
                 performance_fun= table.CAPM)
# r square ในผลลัพธ์มาจาก regression ระหว่าง Ra Rb

#--------------------------------------------------------------------------------------#

# Calculate portfolio cumulative growth
# เช่น เราลงทุนววันนี้ 1 บาท 1บาทนั้นเติบโตยังไง
# ถ้าไปดูจาก port.ret จะมี col ที่ชื่อ portfolio.returns
# มันก็คือการเอา ret นั้นมาคำนวณอัตราผลตอบแทนเรื่อยๆ
# เช่น 1+(0.0663*1บาท) = 1.0663
# ละของเดือนต่อไปก็ได้ ret อีก 0.0678 ละคูณของเดือนต่อไปเรื่อยๆ
port.growth <- stock.data %>%
  tq_portfolio(assets_col= symbol,
               returns_col= Stock.Ret,
               weights = port.wts,
               col_rename= "port.growth",
               wealth.index= TRUE) # ต้องการให้คำนวณ wealth index ไม่ใช่อัตราผลตอบแทน

# plot การเคลื่อนไหวของการเติบโตของหุ้น 4 ตัวนั้น หรือก็คือทั้ง port นั่นเอง
# plot cumulative return
ggplot(data=port.growth) +
  geom_line(mapping=aes(x=date, y=port.growth))

#--------------------------------------------------------------------------------------#

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
ggplot() +
  geom_line(
    data=port.growth,
    mapping=aes(x=date, y=port.growth),
    color="blue") +
  geom_line(
    data=benchmark.growth,
    mapping=aes(x=date, y=benchmark.growth),
    color="red")
 
#--------------------------------------------------------------------------------------#






























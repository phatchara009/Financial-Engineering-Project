library(tidyverse)
library(tidyquant)


#------------------------------------------------------------------------------#

## tq_get()

PTT.tb <- tq_get("PTT.BK", get = "stock.prices", from = "2017-01-01")

# PTT, SCC
stock_names <- c("PTT.BK", "SCC.BK")

two_stocks.tb <- 
  tq_get(stock_names, 
         get = "stock.prices", 
         from = "2017-01-01")

# PTT, SCC, CPF
three_stocks.tb <- c("PTT.BK", "SCC.BK", "CPF.BK") %>% 
  tq_get(get = "stock.prices", 
         from = "2017-01-01")

# PTT, SCC, CPF, KBANK
PSCK <-c("PTT.BK", "SCC.BK", "CPF.BK", "KBANK.BK")

PSCK.tb <-
  PSCK %>% 
  tq_get(get = "stock.prices", 
         from = "2010-01-01")

PSCK.tb <- 
  PSCK.tb %>% 
  na.omit()

#------------------------------------------------------------------------------#

# tq_transmute()

SCC <- tq_get(
  "SCC.BK",
  get="stock.prices",
  from="2017-06-01")

# แปลงเป็นข้อมูลรายสัปดาห์
SCC %>% 
  tq_transmute(
    select = adjusted, 
    mutate_fun = to.period,
    period = "week") #*****

SCC %>% 
  tq_transmute(
    select = adjusted, 
    mutate_fun = to.period,
    period = "month") #*****

SCC %>% 
  tq_transmute(
    select = adjusted, 
    mutate_fun = to.period,
    period = "year") #*****

# ใส่ to ไปเลย mutate_fun = to.xxxxxx
# ไม่แนะนำ เพราะจะทำให้ข้อมูล data เป็นแค่ year month ทำให้ใช้ยาก
# แนะนำใช้ to.period ดีกว่า
SCC %>% 
  tq_transmute(
    select = adjusted, 
    mutate_fun = to.monthly)

# using periodReturn with tq_transmute
SCC %>% 
  tq_transmute(
    select = adjusted, 
    mutate_fun = periodReturn,
    period = "daily")

SCC %>% 
  tq_transmute(
    select = adjusted, 
    mutate_fun = periodReturn,
    period = "weekly")

SCC %>% 
  tq_transmute(
    select = adjusted, 
    mutate_fun = periodReturn,
    period = "monthly")

SCC %>% 
  tq_transmute(
    select = adjusted, 
    mutate_fun = periodReturn,
    period = "yearly")

# using tq_transmute with more than one stock 

temp.tb <- PSCK.tb %>% 
  group_by(symbol) %>%
  tq_transmute(
    select = adjusted, 
    mutate_fun = periodReturn,
    period = "monthly")


#------------------------------------------------------------------------------#

# tq_mutate
SCC %>%
  tq_mutate(
    select=close,
    mutate_fun=SMA,
    n=100
  ) %>%
  ggplot() + 
  geom_line(mapping=aes(x=date, y=close)) +
  geom_line(mapping=aes(x=date, y=SMA), color="#000000") 
# รหัสสี
# 00 สองตัวแรกเป็นสีแดง
# 00 ตัว 3 4 เป็นสีเหลือง
# 00 ตัว 5 6 เป็นสีน้ำเงิน

# tq_mutate with more than one stock
PSCK.tb %>%
  group_by(symbol) %>%
  tq_mutate(
    select=close,
    mutate_fun=SMA,
    n=100
  ) %>%
  ggplot() + 
  geom_line(mapping=aes(x=date, y=close)) +
  geom_line(mapping=aes(x=date, y=SMA), color="#000000") +
  facet_wrap(~symbol, scales="free", nrow=2) 
# facet_wrap
# scales="free" ทำให้กราฟที่ facet ออกมา แกน y เป็นของตัวมันองทั้งหมด


# Available mutate_fun functions
tq_transmute_fun_options()


PSCK.tb %>%
  group_by(symbol) %>%
  tq_transmute(
    select=adjusted,
    mutate_fun=periodReturn,
    period="monthly"
  ) %>%
  summarise(mean=mean(monthly.returns))

PSCK.tb %>%
  group_by(symbol) %>%
  tq_transmute(
    select=adjusted,
    mutate_fun=apply.monthly, # เอาข้อมูลของแต่ละเดือนมาคำนวณค่าเฉลี่ยรายเดือนแต่ละเดือน
    FUN=mean
  )


PSCK.tb %>%
  group_by(symbol) %>%
  tq_transmute(
    select=adjusted,
    mutate_fun=apply.monthly, 
    FUN = min
  )

help(period.apply)

PSCK.tb %>%
  group_by(symbol) %>%
  tq_transmute(
    select=adjusted,
    mutate_fun=apply.monthly, 
    FUN = sd
  )

#------------------------------------------------------------------------------#
library(tidyverse)
library(nycflights13)

airlines.tb<-airlines
airports.tb<-airports
planes.tb<-planes
weather.tb<-weather
flights.tb<-flights


x <-tribble(~key, ~val_x, 1, "x1", 2, "x2", 3, "x3")
y <-tribble(~key, ~val_y, 1, "y1", 2, "y2", 4, "y3")

#------------------------------------------------------------------------------#

# inner join
# ไม่เก็บตัวที่ keyไม่ซ้ำกันไว้เลย
x %>% inner_join(y, by="key")
# or ใช้อันนี้ก็ต่อเมื่อ ชื่อ key คนละชื่อกัน  (by=c( ชื่อcol x = ชื่อcol y ))
x %>% inner_join(y, by=c("key" = "key"))

#------------------------------------------------------------------------------#

## Outer join

# ที่อธิบายเป็นกรณีเจอ key ที่ไม่เหมือนกันระะหว่างสองตาราง

# left join เก็บข้อมูลเฉพาะตารางด้านซ้าย
x %>%
  left_join( y , by = "key")

# Right join เก็บข้อมูลเฉพาะตารางด้านขวา
x %>%
  right_join( y , by = "key")

# Full join เก็บข้อมูลทั้งคู่เอาไว้
x %>%
  full_join( y , by = "key")


#------------------------------------------------#
# ถ้าkey ของข้อมูลนั้นไม่ได้จำเพาะสำหรับแต่ล่ะแถว  
# เราจะเรียกข้อมูลที่มี key แบบนี้ว่าข้อมูลที่มี duplicate keys
#------------------------------------------------#

#------------------------------------------------------------------------------#

# ตาราง x มี Duplicate key

x <- tribble(~key, ~val_x, 1, "x1", 2, "x2", 2, "x3", 1, "x4")
y <- tribble(~key, ~val_y, 1, "y1", 2, "y2")

# left join  ใช้เยอะสุด
x %>% left_join(y, by="key")

# Right join
x %>% right_join(y, by="key")

#------------------------------------------------------------------------------#

# ตาราง x และ y มี Duplicate key ทั้งคู่
# ปกติมักจะไม่ทำกรณีนี้ เพราะอาจจะ มีอะไรผิดพลาด
# การ join ก็จะเละเทะ

x <-tribble(~key, ~val_x, 1, "x1", 2, "x2", 2, "x3", 3, "x4")
y <-tribble(~key, ~val_y, 1, "y1", 2, "y2", 2, "y3", 3, "y4")

x %>% left_join( y , by = "key")

#------------------------------------------------------------------------------#

# การเลือก key
# 1. by = NULL ให้ function เลือกข้อมูลที่เหมือนกันในสองตารางเอง (หา key ของแต่ละตารางเอง)
# ทำแบบนี้ไม่ดีเท่าไหร่ เพราะเราไม่ได้กำหนดตัว join 
flights.tb %>% left_join(weather.tb)

# 2. by = “ชื่อ column” โดยชื่อ column จะต้องเหมือนกันทั้งสองตาราง
flights.tb %>% left_join(weather.tb, by = "tailnum")

# 3. by = c(“ชื่อ column ในตารางแรก” = “ชื่อ column ในตารางสอง”)
flights.tb %>% left_join(airports.tb, by = c("dest" = "faa"))

#------------------------------------------------------------------------------#

## Filtering joinเป็นการกรองข้อมูลที่มีอยู่ในตารางหนึ่ง ด้วยข้อมูลอีกตารางหนึ่ง

# 1. semi_join(x, y) : เก็บข้อมูลใน x ที่มีอยู่ใน y
# ใช้บ่อยในข้อมูลการเงิน เช่น ข้อมูลอนุกรมเวลา
# เวลาเราเก็บข้อมูลเวลาของหุ้น และ risk free
# ข้อมูลสองอันนี้จะต้อง join ด้วยวันที่ ทำให้ข้อมูลหุ้นและ rf ต้องวันที่เดียวกัน
# เราก็ join โดยที่เราก็จะเน้นข้อมูลของตารางหุ้น โดยจะตัดวันที่ที่ไม่ตรงกับหุ้นของ rf ทิ้ง
top_dest<-flights %>%
  count(dest, sort = TRUE) %>%
  head(10)

flights %>% semi_join(top_dest)

top_dest_flights <- flights %>% semi_join(top_dest, by="dest")

# 2. anti_join(x, y) : ทิ้งข้อมูลใน x ที่มีอยู่ใน y (ตัดอันที่มีข้อมูลทั้งสองตารางออก)


#------------------------------------------------------------------------------#

## Assignment

# 1. Calculate Age
planes.tb %>% 
  mutate(age=2013-year) %>%
  select("tailnum", "age") %>%
  right_join(flights.tb, by = "tailnum") %>%
  select("tailnum", "age", "arr_delay") %>%
  ggplot() + geom_point(mapping=aes(x=age, y=arr_delay))


# 2. 
flights.tb %>%
  select(year:day, dep_time, origin, dep_delay) %>%
  mutate(hour=dep_time %/% 100) %>%
  select(year:day, hour, origin, dep_time, dep_delay) %>%
  left_join(weather.tb, by=c("year", "month", "day", "hour", "origin") %>%
  ggplot() + 
    geom_point(mapping=aes(x=dep_delay, y=temp), alpha=0.1) # alpha คือความบางของจุด
  
# 3.
tailnum_more_than_100 <- flights.tb %>%
  select(flight, tailnum) %>%
  group_by(tailnum) %>%
  count() %>%
  filter(n>100) %>%
  arrange(desc(n)) %>%
  filter(n>300)

flights.tb %>%
  left_join(tailnum_more_than_100, by="tailnum") %>%
  semi_join(tailnum_more_than_100, by="tailnum") %>%
  select(carrier, flight, tailnum, n)

#------------------------------------------------------------------------------#




















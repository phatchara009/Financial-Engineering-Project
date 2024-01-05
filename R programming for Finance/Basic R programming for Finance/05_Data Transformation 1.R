library(tidyverse)

mpg.tbl <- mpg
str(mpg.tbl)

test.df <- data.frame(x=c(1,2,3), y=c("a", "b", "c"))

test.tb <- as_tibble(test.df)
str(test.tb)

# ดึงข้อมูล
# tb_name[row, col]
mpg.tbl[8, 4]

mpg.tbl[4:8, 4] # ดึงหลาย row
mpg.tbl[4, 4:6] # ดึงหลาย col

# ดึงทุก row
mpg.tbl[1:234, 4:6] 
mpg.tbl[,4:6]  # ทำแบบนี้ดีกว่าแค่ไม่ใส่ index ของแถวก็ทำได้แล้ว

# ดึงทุก col
mpg.tbl[4:8,]

# ดึง col ด้วย col name
mpg.tbl[4:8, "model"]
mpg.tbl[4:8, c("model", "cty")] # ดึงหลาย col ด้วยชื่อ


mpg.tbl["model"] # ออกมาเป้น tibble
mpg.tbl[["model"]] # ออกมาเป็น vector
mpg.tbl[[5]] 
mpg$model # ออกมาเป็น vector ด้วยการ hard code

mpg.tbl[4:8, "model"]
mpg.tbl[[4:8, "model"]] # จะเรียกออกมาเป็น vector ทำแบบนี้ไม่ได้
mpg.tbl[4:8, "model"][["model"]] # แปลงเป็น vector
mpg.tbl[4:8, "model"][["model"]][1:2] # เรียกตัวที่ 1 ถึง 2 ใน vector นี้


# ได้ออกมาเป็น dataframe
test.df <- read.csv(file="./data/test_data.csv")
str(test.df)

# ได้ออกมาเป็น tibble
test.tb <- read_csv(file="./data/test_data.csv")
str(test.tb)


flights_tb <- read_csv(file="./data/flights.csv")
str(flights_tb)

# carrier = สายการบิน
# flight = ชื่อเที่ยวบิน
# origin = ชื่อย่อสนามบินต้นทาง
# dest = ชื่อย่อสนามบนปลายทาง
# air_time = ระยะเวลาที่อยูู่บนอากาศ นาที

#------------------------------------------------------------------------------#

# filter()

filter(flights_tb, month==1)

filter(flights_tb, month==1, day==1)

filter(flights_tb, month<=6)


filter(flights_tb, month==1 & month==3) # ผิด
 
filter(flights_tb, month==1 | month==3) # ถูก ไม่มี month ที่ ==1 ==3 พร้อมกัน

filter(flights_tb, !(month==1 | month==3)) # !() คือ not

filter(flights_tb, dep_time>600 | dep_time<700)
filter(flights_tb, xor(dep_time>600, dep_time<700)) # ไม่เอา dep_time >600 และ < 700

filter(flights_tb, origin=="JFK" | origin=="LGA")
# %in% อยู่ใน set
# เอา origin ที่อยู่ใน set JFK , LGA
filter(flights_tb, origin %in% c("JFK", "LGA")) # ดีกว่าถ้าต้องเขียนเยอะๆ

# Exercise
filter(flights_tb, arr_delay>=120)

filter(flights_tb, dest %in% c("IAH", "HOU"))

filter(flights_tb, carrier %in% c("AA", "UA", "DL"))

filter(flights_tb, month %in% c(7, 8, 9))
filter(flights_tb, month >=7 & month<=9)

filter(flights_tb, arr_delay>=120 & dep_delay<=0)

#------------------------------------------------------------------------------#

# arrange() คือการจัดเรียงข้อมูล

# จัดเรียงตาม year month day ตามลำดับ
arrange(flights_tb, year, month, day)

arrange(flights_tb, arr_delay)
# desc() = descending มากไปน้อย
arrange(flights_tb, desc(arr_delay))

#------------------------------------------------------------------------------#

# select()

select(flights_tb, year, month, day) # ชื่อตาราง และ ชื่อคอลัมน์ที่ต้องการ

select(flights_tb, year:day)

select(flights_tb, -(year:day)) # ไม่เอา col year ถึง day



# starts_with() ขึ้นต้นด้วย
select(flights_tb, starts_with("arr")) # เลือก col ที่ขึ้นต้นด้วย arr

# ends_with() ลงท้ายด้วย
select(flights_tb, ends_with("delay")) # เลือก col ที่ลงท้ายด้วย delay
 
# contains
select(flights_tb, contains("arr_")) # เลือก col ที่บรรจุคำว่า arr_

# col ที่ขึ้นต้นด้วย arr และตามด้วย year month day
select(flights_tb, contains("arr_"), year:day) 

# col ที่ขึ้นต้นด้วย arr และตามด้วย col ที่เหลือทั้งหมด
# สามารถใช้ฟังก์ชันนี้ในการจัดเรียงลำดับ colได้ด้วย
select(flights_tb, contains("arr_"), everything()) 

#------------------------------------------------------------------------------#




















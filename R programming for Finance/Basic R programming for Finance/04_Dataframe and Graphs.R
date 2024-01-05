# read and write data
read.csv(file='./data/test_data.csv', header=TRUE)

test.df <- read.csv(file='./data/test_data.csv', header=TRUE)

# save data csv file
write.csv(x=test.df, file="./data/test_write.csv")

# อีกวิธีการ import data 
# ให้ดูในช่อง environment
# import dataset
# เลือก From Text (base)
# เลือกไฟล์ที่ต้องการ import
# ถ้าข้อมูลมีเป็นภาษาไทยให้เลือกตรง encoding เป็น UTF-8


#---------------------------------------------------------------------#


# How to import package?
# Tools -> Install package
# ตรงช่อง packages ให้พิมชื่อว่า tidyverse 


#---------------------------------------------------------------------#

# GGPLOT
library(tidyverse)

# use data mpg
mpg.df <- mpg

# check structure
str(mpg.df)


#---------------------------------------------------------------------


# Graph
# create point graph
# mapping คือการจับคู่
ggplot(data = mpg.df) +  
  geom_point(mapping=aes(x=displ, y=hwy)) # aes เช่น สี ขนาด ลักษณะของจุด

# เราสามารถผูกข้อมูลเป็น layer แทนที่จะผูกแบบทั้งหมดได้
# ถ้าเราอยากจะใช้ข้อมูลจากตารางอื่นๆ เราก็ใส่ทีละ layer ได้
ggplot() +  
  geom_point(mapping=aes(x=displ, y=hwy),
             data=mpg.df)

# เช่น ดึงจะสร้างกราฟเส้นเพิ่มโดยใช้ข้อมูลจากตารางอื่นๆ
# ggplot() +  
#   geom_point(mapping=aes(x=displ, y=hwy),
#              data=mpg.df) +
#   geom_line(data=mpg.df2)

# กำหนดสีของจุด
# อะไรที่จะกำหนดแล้วไม่เกี่ยวกับตาราง ให้กำหนดไว้นอกฟังก์ชัน aes()
ggplot(data=mpg.df) +  
  geom_point(mapping=aes(x=displ, 
                         y=hwy, 
                         color=class, 
                         size=cyl), color="red", size=3)


# Faceting wrap
ggplot(data=mpg.df) + 
  geom_point(mapping=aes(x=displ, y=hwy)) +
  facet_wrap(~class) # ใช้สร้างกราฟย่อยออกตามตัวแปรเชิงปริมาณที่เลือก

ggplot(data=mpg.df) + 
  geom_point(mapping=aes(x=displ, y=hwy)) +
  facet_wrap(~class, nrow=1) # เปลี่ยนจำนวนแถวได้ด้วยเติม nrow
ggplot(data=mpg.df) + 
  geom_point(mapping=aes(x=displ, y=hwy)) +
  facet_wrap(~class, ncol=1) # ncolเปลี่ยนจำนวนคอลัมน์เพื่อเปรียบเทียบแนวแกน x


# Faceting grid
ggplot(data=mpg.df) + 
  geom_point(mapping=aes(x=displ, y=hwy, color=class)) +
  facet_grid(drv~cyl) # cyl ที่เป็น 4 5 6 8 หมายถึงว่าเป็นแกนนอน
                      # แกนตั้งก็จะแบ่งตาม drv หรือ 4 f r


#---------------------------------------------------------------------#


# create bar graph
# color เป็นกรอบนอกของเหลี่ยม
ggplot(data=mpg.df) +  
  geom_bar(mapping=aes(x=class, color=manufacturer)) 

# fill คือสีในแท่ง
ggplot(data=mpg.df) +  
  geom_bar(mapping=aes(x=class, fill=drv)) 


#---------------------------------------------------------------------#






































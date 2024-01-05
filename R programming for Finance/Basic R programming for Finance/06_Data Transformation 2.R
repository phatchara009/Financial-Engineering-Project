library(tidyverse)

#------------------------------------------------------------------------------#

# mutate()
# sml = small
flights_sml <- select(flights_tb, 
                      year:day, 
                      ends_with("delay"),
                      distance,
                      air_time
                      )

# สร้าง col เพิ่มอีกหลายๆ col ในที่นี้มี gain กับ speed ที่ถูกเพิ่มเข้ามาอีก 2 col
mutate(flights_sml, 
       gain = arr_delay - dep_delay,
       speed = (distance/air_time)*60)


# ทำแบบนี้จะ error เราจะต้องสร้างตามลำดับ
mutate(flights_sml, 
       gain_per_hour = gain/hours,
       gain = arr_delay - dep_delay,
       hours = air_time/60)
# gain ต้องมาก่อนเพราะะจะเอาไปใช้คำนวณ
mutate(flights_sml, 
       gain = arr_delay - dep_delay,
       hours = air_time/60,
       gain_per_hour = gain/hours)

## 
#ตัวอย่างเรื่อง operator
14/5
# %/% integer division ปัดเศษทิ้ง เอาแต่จำนวนเต็ม
14 %/% 5 
# %% remainder เอาแต่เศษที่หารออกมาได้
14 %% 5 # 14 หาร 5 = 2 เศษ 4 (2*10 + 4) 
##


# Exercise
flights_ex <- mutate(flights_tb,
              dep_time_min = (dep_time %/% 100)*60 + (dep_time %% 100),
              sched_dep_time_min = (sched_dep_time %/% 100)*60 + (sched_dep_time %% 100))
flights_ex <- mutate(flights_tb,
              dep_time_min = (dep_time %/% 100)*60 + (dep_time %% 100),
              sched_dep_time_min = dep_time_min - dep_delay)

#------------------------------------------------------------------------------#

# summarize() or summarise()

summarize(flights_tb,
          delay = mean(dep_delay))

# na.rm = TRUE ทำให้ไม่เอา NA มาคำนวณด้วย
# แต่ไม่เวลาทำงานจริงควรจะ set เป็น false ก่อนเพื่อเพราะะปกติเราจะต้องแก้ naให้เรียบร้อย
summarize(flights_tb,
          delay = mean(dep_delay, na.rm = TRUE))

summarize(flights_tb,
          mean_delay = mean(dep_delay, na.rm = TRUE),
          sd_delay = sd(dep_delay, na.rm = TRUE))

#------------------------------------------------------------------------------#

# group_by()

flights_grouped <- group_by(flights_tb,
                            year, month, day)
flights_grouped # สังเกตผลว่าจะมี groups : year month day

# summarize มักจะใช้คู่กับ group by เพื่อดูผลสรุปแต่ละกลุ่ม
summarize(flights_grouped,
          mean_delay = mean(dep_delay, na.rm = TRUE),
          sd_delay = sd(dep_delay, na.rm = TRUE))


# Exercise
by_carrier <- group_by(flights_tb, carrier)
summarize(by_carrier,
          mean_dep_delay = mean(dep_delay, na.rm = TRUE),
          sd_dep_delay = sd(dep_delay, na.rm = TRUE),
          mean_arr_delay = mean(arr_delay, na.rm = TRUE),
          sd_arr_delay = sd(arr_delay, na.rm = TRUE))

#------------------------------------------------------------------------------#

# Pipe %>%

# Ex
# x %>% f(y)             ->    f(x, y)
# x %>% f(y) %>% g(z)    ->    g(f(x, y), z)

# Exercise
flight_tb %>% 
  mutate(gain = arr_delay - dep_delay,
         speed = (distance/air_time)*60) %>%
  filter(month %in% c(10,11,12)) %>%
  select(gain, speed, carrier) %>%
  group_by(carrier) %>%
  summarize(mean_gain = mean(gain, na.rm=TRUE),
            max_gain = max(gain, na.rm=TRUE),
            min_gain = min(gain, na.rm=TRUE),
            mean_speed = mean(speed, na.rm=TRUE)) %>%
  arrange(mean_gain, mean_speed) 

# เอามาใช้กับ ggplot ก็ได้
flight_tb %>% 
  mutate(gain = arr_delay - dep_delay,
         speed = (distance/air_time)*60) %>%
  filter(month %in% c(10,11,12)) %>%
  select(gain, speed, carrier) %>%
  group_by(carrier) %>%
  summarize(mean_gain = mean(gain, na.rm=TRUE),
            max_gain = max(gain, na.rm=TRUE),
            min_gain = min(gain, na.rm=TRUE),
            mean_speed = mean(speed, na.rm=TRUE)) %>%
  arrange(mean_gain, mean_speed) 
  ggplot() + 
    geom_bar(mapping=aes(x=carrier), stat="identity")    
  

# เอาตารางนี้เก็บไว้ในตัวแปรก็ได้
summarize_flights <- flights_tb %>% 
                        mutate(gain = arr_delay - dep_delay,
                               speed = (distance/air_time)*60) %>%
                        filter(month %in% c(10,11,12)) %>%
                        select(gain, speed, carrier) %>%
                        group_by(carrier) %>%
                        summarize(mean_gain = mean(gain, na.rm=TRUE),
                                  max_gain = max(gain, na.rm=TRUE),
                                  min_gain = min(gain, na.rm=TRUE),
                                  mean_speed = mean(speed, na.rm=TRUE)) %>%
                        arrange(mean_gain, mean_speed) 
































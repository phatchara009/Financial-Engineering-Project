library(tidyverse)

diamonds.tb <- diamonds

ggplot(data=diamonds.tb) + 
  geom_bar(mapping=aes(x=cut))

# ใช้ stat_count() มาคำนวณการนับ แล้วค่อยเอามาสร้างกราฟ
help(geom_bar)

# ทำ  bar plot แบบนี้ก็ได้แต่ว่าไม่นิยมทำ
ggplot(data=diamonds.tb) + 
  stat_count(mapping=aes(x=cut))

#------------------------------------------------------------------------------#

demo <- tibble(
  ~cut, ~freq,
  "Fair", 1610,
  "Good", 4906,
  "Very Good", 12082,
  "Premium", 13791,
  "Ideal", 21551)

#------------------------------------------------------------------------------#

# เรามีข้อมูลที่เรานับมาแล้ว ให้ใช้ stat="identity" 
# จึงต้องกำหนด y ด้วย เพราะเราไม่ให้ฟังก์ชัน count เองแล้ว
ggplot(data = demo) +
  geom_bar(mapping=aes(x=cut, y=freq), stat="identity") 

# plot bar เหมือนเดิม
# แต่ให้แกน y เป็นสัดส่วน หรือ percent แทน
# group เทากับ 1 เพราะ เหมือนให้คำนวณสัดส่วนภายในกลุ่ม 
# เพราะภายใน ฟังก์ชันมีการแบ่งกลุ่มกันได้อยู่ เราจึงกำหนดให้คำนวณสัดส่วนภายในกลุ่ม 1
ggplot(data = diamonds.tb) +
  geom_bar(mapping=aes(x=cut, y=after_stat(prop), group=1))


help(geom_boxplot)

ggplot(data=diamonds.tb) + 
  stat_summary(
    mapping=aes(x=cut, y=depth),
    fun.min=min,
    fun.max=max,
    fun=median
  )


# ใช้สรุปข้อมูล
lower_sd <- function(x) {
  return(mean(x) - sd(x))
}  
upper_sd <- function(x) {
  return(mean(x) + sd(x))
}

ggplot(data=diamonds.tb) + 
  stat_summary(
    mapping=aes(x=cut, y=depth),
    fun.min=lower_sd,
    fun.max=upper_sd,
    fun=mean
  )

ggplot(data=diamonds.tb) +
  geom_boxplot(mapping=aes(x=cut, y=depth))

# median จะอยู่ตรงพื้นที่ที่กว้างเสมอ
ggplot(data=diamonds.tb) +
  geom_violin(mapping=aes(x=cut, y=depth))

ggplot(data=diamonds.tb) +
  geom_violin(mapping=aes(x=cut, y=depth)) +
  stat_summary(
    mapping=aes(x=cut, y=depth),
    fun.min=lower_sd,
    fun.max=upper_sd,
    fun=mean
  )

# จับ plot รวมกันได้ด้วย
ggplot(data=diamonds.tb) +
  geom_violin(mapping=aes(x=cut, y=depth)) +
  geom_boxplot(mapping=aes(x=cut, y=depth), alpha=0.01)

#------------------------------------------------------------------------------#

ggplot(data=diamonds.tb) +
  geom_violin(mapping=aes(x=cut, y=depth)) +
  coord_flip() # ใช้กลับ x เป็น y, y เป็น x

ggplot(data=diamonds.tb) +
  geom_violin(mapping=aes(x=cut, y=depth))


bar <- 
  ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut), 
           show.legend = FALSE, # ไม่ต้องบอกว่าแต่ละสีมีความหมายว่าอะไร
           width = 1) + # ความกว้างของแต่ละแท่ง
  theme(aspect.ratio = 1) + 
  labs(x = NULL, y = NULL) # labs = labels ให้เป็น NULL คือไม่ต้องแสดง label เลย

bar

bar + coord_flip()

bar + coord_polar() # เปลี่ยนพิกัด x พวก ideal fair premium ... ที่เป็นเชิงปริมาณเป็น องศา  !!ไม่ค่อยดี


bar_stack <- diamonds %>% mutate(group = "polar") %>% 
  ggplot() +
  geom_bar(mapping = aes(x = group, fill = cut), 
           show.legend = FALSE, # ไม่ต้องบอกว่าแต่ละสีมีความหมายว่าอะไร
           width = 1,  # ความกว้างของแต่ละแท่ง
           position = "stack",
  ) +
  theme(aspect.ratio = 1) + 
  labs(x = NULL, y = NULL) # labs = labels ให้เป็น NULL คือไม่ต้องแสดง label

bar_stack

#------------------------------------------------------------------------------#













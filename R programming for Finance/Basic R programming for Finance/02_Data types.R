# How to create vector

var_a <- c(2, 3, 4, 5, 7)
var_b <- c("text1", "text2")
# var_c ถ้ามีตัวเลขกับ text รวมกันใน vector เดียว มันจะปรับให้ 2 เป็น text ด้วย
var_c <- c(2, "text") 
# ดังนั้นไม่ควรผสมประเภทข้อมูล
# ตรงตัวแปร
# num [... : ...] เป็น vector ของตัวเลข
# chr [... : ...] เป็น vecor ของ text


#-------------------------------------------------------------------#

# seq() = sequnce
seq_a <- seq(10)
seq_a

seq_b <- seq(0.5)
seq_b
# วิธีการทำงานคือ
# สร้างความถี่ของตัวเลขโดยเริ่มที่ 1 เสมอ และจะสร้างไปเรื่อยๆจนถึงตัวที่กำหนด

seq_c <- seq(1.7)
seq_c

# seq(from, to)
seq_d <- seq(2, 8.1)
seq_d

seq_dd <- seq(2.5, 8.1)
seq_dd

# seq(from, to, by)
seq_e <- seq(2.5, 8.1, 1.5)
seq_e

seq_f <- seq(from=2.5, by=1.5, to=8.1) 
# สลับตำแหน่งได้ถ้าใส่ชื่อ argumentด้วย
seq_f

# error เพราะจบที่ 1 จะเพิ่มทีละะ 1 ไม่ได้
seq_g <- seq(from=5, to=1, by=1)

seq_gg <- seq(from=5, to=1, by=-1)

seq_ggg <- seq(from=0, to=-11, by=-2)

# ใช้ทำอะไรที่ซับซ้อนไม่ได้

#-------------------------------------------------------------------#

# rep() = repeat

rep_a <- rep(x=1, times=5)
rep_a # สร้าง 1 ซ้ำกัน 5 ครั้ง

# length.out คือ ความยาวของ vector สุดท้ายยที่เราต้องการ
rep_b <- rep(x=1, length.out=5)
rep_b

rep_c <- rep(x="text", length.out=5)
rep_c

# ทำซ้ำ vector ก้ได้
vec_a <- c(1,2)
rep(x=vec_a, times=3)
rep(x=vec_a, length.out=5) # จะสร้างไม่เกิน 5 ตัว   
# เอาจริงๆไม่ควรตั้งชื่อเยอะๆถ้าเป็นไปได้

# ทำซ้ำเลข 1 2 ครั้ง เลข 2 3 ครั้ง ตามลำดับ 
rep(x=vec_a, times=c(2,3))

rep(x=c(1, 2, 3), times=c(2,3))

rep(x=c(1, 2, 3), times=c(2,3,4)) # vector ขนาดต้องเท่ากันเสมอ

rep(x=c(1, 2, 3), times=rep(x=2,times=3))
rep(x=c(1, 2, 3), times=rep(x=2,length.out=3)) # ดีกว่า
# ใช้ length.out เพื่อการันตีว่ามี 2 สิบตัวแน่นอน
rep(x=seq(10), times=rep(x=2,length.out=10))

n <- 10
m <- 5
rep(x=seq(n), times=rep(x=m,length.out=n))

rep(x=c("red", "white", "blue"), times=c(10, 20, 20))

#-------------------------------------------------------------------#

# factor()
fac_x <- factor(c("red", "white", "blue"))
fac_x
vec_x <- rep(x=c("red", "white", "blue"), times=c(10, 20, 20))
fac_x <- factor(vec_x)

levels(fac_x) # เพื่อดูว่ามีกลุ่มอะไรที่แบ่งได้บ้าง
levels(vec_x)
table(fac_x) # บอกว่าแต่ละกลุ่มมีจำนวนเท่าไหร่
table(vec_x)

vec_x

# ตั้งให้มีทั้งหมด 4 กลุ่มตาม vec_groups
# โดยปกติ factor จะกำหนดชื่อกลุ่มตามข้อมูลที่มีอยู่
# แต่คราวนี้กำหนดชื่อกลุ่มแยกออกมาเอง
vec_groups <- c("red", "white", "blue", "grean")
fac_x <- factor(vec_x, levels=vec_groups)
table(fac_x)

# ordered ช่วยให้ข้อมูลเรียงลำดับตาม
fac_x <- factor(vec_x,
                levels=vec_groups,
                ordered=TRUE
                )
table(fac_x)

#-------------------------------------------------------------------#

vec_x <- c("red", "white", "blue")
vec_y <- seq(3)

# 3obs 2variables
df_a <- data.frame(vec_x, vec_y)

# ตั้งชื่อคอลัมน์ได้
df_a <- data.frame(
  color=vec_x, 
  number=vec_y
  )

# str() = structure



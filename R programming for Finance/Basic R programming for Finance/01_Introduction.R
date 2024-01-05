2+3

2*3

2/3

2-3

2^3

a = 5 # ทาง computer กำหนดด้านซ้ายให้มีค่าเท่ากับด้านขวา

b <- 3 # ใช้ <- ตามธรรมเนียม ควรใช้แบบนี้มากที่สุด ****

6 -> c # แบบนี้ก้ได้ แต่ไม่นิยม

6 = c # แบบนี้ทำไม่ได้ ควรจะะเป็น ชื่อตัวแปร = ค่า

d <- 9

a - b

c * d

e <- a - b

c * e

# comments

exp(1)

y <- exp(10)

y

log(1)

log(exp(1))


# Writing functions
# ใช้ {} ในการสร้าง block
# ทั้งหมดนี้นับเป็น 1 block
func_name <- function(x){
  return(x^2 + 2*x + 1)
}
func_name(x=3) # ทำแบบ func_name(x <- 3) ไม่ได้  


func_name <- function(x){
  result <- x^2
  result <- result + 2*x
  result <- result + 1
  return(result)
}
func_name(x=3)

# ไม่ควรใช้ตัวที่อยู่ใน global scope
d <- 10 # ตัว d อยู่ใน global scope
func_name <- function(x){
  result <- x^2
  result <- result + 2*x
  result <- result + d
  return(result)
}
func_name(x=3) 
x # หา x ไม่เจอเพราะ อยู่ใน local scope จะใช้ x ได้แค่ข้างในฟังก์ชัน
# x จะถูกลบทิ้งหลังจากใช้ฟังก์ชัน result ก็เช่นเดียวกัน

# exp <- function(x){
#  return(x^2)
#}
# ไม่ควรตั้งชื่อฟังก์ชันทับกับฟังก์ชันที่มีอยู่แล้วใน R

# มาตราฐานการตั้งชื่อฟังก์ชัน หรือ ชื่อตัวแปร
# onetwothree
# OneTwo
# oneTwoThree
# one_two_three  snake case นิยมใช้แบบนี้มากกว่า


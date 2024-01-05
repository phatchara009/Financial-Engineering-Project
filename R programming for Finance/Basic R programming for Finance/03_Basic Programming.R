# Dataframes

x <- c("red", "white", "blue")
z <- c(1,2,3)
y <- data.frame(col.x=x, col.z=z)
str(y)

# ออกมาเป็น vector เหมือนกันทั้งสองแบบ
y$col.x # เป็นการ hard code เข้าไปในชื่อคอลัมน์
x

# ออกมาเป็นลักษณะ columns หรือรูปแบบของ dataframes column แรกคอลัมน์เดียว
y[1]
y
y["col.x"] # นิยมสุดเพราะเราไม่รู้เลขของ column

# เรียกเป็น dataframes และเรียกเป็น vector ได้
# ออกมาเป็น vector
y[[1]] 
y[["col.x"]]

w <- c(4,5,6)

# การ add column ใหม่
# ถ้า col.w ไม่ได้อยู่ในตาราง จะเพิ่ม vector w เข้าไปในตาราเอง
y$col.w <- w # เป็นการ hard code
y["col.w"] <- w # นิยมกว่า
new_col_name <- "col.w2"
y[new_col_name] <- w

# จะ error เพราะ replacemennt มี 2 แถว แต่ data มี 3 แถว
# ขนาดของข้อมูลไม่เท่ากัน
v <- c(10,11)
y["col.v"] <- v # Error!

# เรียกหลาย column
col_names <- c("col.x", "col.z")
y[col_names]
y[c("col.x", "col.z")] # แบบนี้ดีกว่าไม่ต้องงสร้างตัวแปรใหม่
y[1:2] # ใช้เมื่อรู้ตำแหน่งตารางแน่นอน

y[-4] # ไม่เลือก column ที่ 4 และแสดงคอลัมน์ที่เหลือทั้งหมด

# เรียกชื่อ column ของ table y ทั้งหมด
colnames(y)

# สมมติให้ a เป็น y
# การทำแบบนี้จะไม่ใช้ memory เพิ่มเติม
# ดังนั้นถ้าจะไปแก้อะไรก็ไปแก้ใน a
# โดยไม่ควรยุ่งกับ raw data
a <- y

# เป็นฟังก์ชันที่พยายามหาว่า "col.w" อยู่ตำแหน่งไหนของ colnames(เป็น vector)
match("col.w", colnames(y))

y[-match("col.w", colnames(y))]


#--------------------------------------------------------------------#

# List
# list เหมือนกับ vector
# แต่ list เก็บข้อมูลได้หลายประเภทในมิติเดียว
# มักจะใช้ list ในการเก็บผลของการประมวลผลได้ เช่น กลุ่มของข้อมูล
y <- list("one", TRUE, 3, c("f", "o", "u", "r"))

# อันนี้จะเรียก list ที่มีขนาดเท่ากับ 1 ออกมาก่อน แล้วเรียก vector ตัวนั้นออกมา
y[1] 
# เรียก vector ออกมาเลย
y[[1]]

y[2:3]

y[c(1,3)]

# เรียกตัวที่ 3 ใน vector ที่เป็นตัวที่ 4 ของ list
y[[4]] # เป็น vector ที่มีขนาดเท่ากับ 4
y[[4]][3] # และเรียกตัวที่ 3 มา
# ถ้าใช้ y[4][3] จะเป็น list ที่มีขนาดเท่ากับ 1 ทำให้ไม่สามารถเรียกอะไรในlist ได้


# สามารถตั้งชื่อองค์ประกอบได้
# จะทำให้ไม่งงถ้ามี list ต่อกันเยอะๆ
z <- list(first="one", 
          second=TRUE, 
          third=c(1,2,3,4)
          ) 

z[["third"]][2]


#--------------------------------------------------------------------#

# Looping
# เลือกได้อย่าใช้ loop เพราะช้า

for (x in 1:5) {
  print(x)
}

for (x in z) {
  print(x)
}

for (x in seq(from=5, to=100, by=10)) {
  print(x)
}

# ใน python จะค่อยๆ gen ตัวเลขขึ้นมาตอน loop ทำให้ไม่เปลืองเนื้อที่
# แต่ R ใช้การสร้าง vector ตัวเลขขึ้นมาทีเดียวแล้ว loop ทำให้เปลืองเนื้อที่

#--------------------------------------------------------------------#

# If-Else
# If
# ใน () เป็นอะไรก็ได้ที่เป็น หรือ ให้ผลเป็น boolean
x <- 1
if (x<0) {
  print(x)
} else if (x>0) {
  print("else if")
} else
  print("else")
}

#--------------------------------------------------------------------#

# While loop
x <- 0
while (x<5) {
  print(x)
  x = x+1 # ควรมีการ update ค่าในทุกๆ loop
}

#--------------------------------------------------------------------#

# Exercise

func1 <- functions(var_x) {
  if (var_x %% == 0) {
    return(var_x^2)
  } else if (var_x %% 2 != 0) {
    return(var_x^0.5)
  }
}

func2 <- function(start, end) {
  result <- 0
  for (var_x in start:end) {
    result <- result + var_x^2
  }
  return(result)
}


































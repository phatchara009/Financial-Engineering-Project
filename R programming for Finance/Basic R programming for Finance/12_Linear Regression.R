library(tidyverse)

Car_discounts = read.csv("/Users/Admin/Documents/Project_R/InClass/data/Car_discounts.csv")

#------------------------------------------------------------------------------------#

# scatter plots เพื่อดูการกระจายของข้อมูล
ggplot(data=Car_discounts) + 
  geom_point(mapping=aes(x=Income, y=Discount))

# linear line on graph
ggplot(data=Car_discounts) +
  geom_point(mapping=aes(x=Income, y=Discount)) +
  # abline คือ เส้นตรงที่มี slope และ intercept (จุดตัดแกน y)
  geom_abline(intercept=3000, slope=-0.05, color="red") +
  geom_abline(intercept=2500, slope=-0.04, color="blue") +
  geom_abline(intercept=2800, slope=-0.06, color="green")

# only red line
ggplot(data=Car_discounts) +
  geom_point(mapping=aes(x=Income, y=Discount), size=3) +
  geom_abline(intercept=3000, slope=-0.05, color="red", size=3)

#------------------------------------------------------------------------------------#
  
# linear regression

#----------------------------------------------------------------------------#
# ระยะห่างระหว่างจุดแต่ละจุดจนถึงเส้นสีแดงคือ ความคลาดเคลื่อน 
# ดังนั้นเส้นตรงที่ดีที่สุดที่แสดงความสัมพันธ์ระหว่าง รายได้และ discount
# คือเส้นตรงที่มีความคาดเคลื่อนยกกำลังสองของทุกจุดมารวมกัน น้อยที่สุด 
# เรียกว่า Ordinary Least Square (OLS)
#----------------------------------------------------------------------------#

# lm(formula, data = ชื่อdataframe)
# รูปแบบของ formula คือ y ~ x หรือ ตัวแปรตาม ~ ตัวแปรอิสระ
# กด alt + 126 จะได้ ~ เรียกว่า tilda
lm_result <- lm(Discount ~ Income, data=Car_discounts)
lm_result

# ลองเอาผลมา plot graph ดู
ggplot(data=Car_discounts) +
  geom_point(mapping=aes(x=Income, y=Discount)) +
  geom_abline(intercept=3000, slope=-0.05, color="red") +
  geom_abline(intercept=2500, slope=-0.04, color="blue") +
  geom_abline(intercept=2800, slope=-0.06, color="green") +
  geom_abline(intercept=2626.03622, slope=-0.03807, color="orange", size=3)

# structure of lm_result
str(lm_result)

# example : get coefficieants from result
lm_result$coefficients

# summary of result
summary(lm_result)

# Getting coefficient values programmatically
str(lm_result$coefficients)

# Coefficient of Income
# as list
lm_result$coefficient["Income"]
# as number value
lm_result$coefficient[["Income"]]

# structure of summary
str(summary(lm_result))
 
# Getting R square & adjusted R squared
summary(lm_result)$r.squared 
summary(lm_result)$adj.r.squared

# ANOVA
anova(lm_result)

# CI
confint(lm_result, level=0.95)

# plotting regression graphs
# วิธีทำ พอขึ้นหน้า console ว่า
# Hit <Return> to see next plot:
# ให้กดปุ่ม enter เพื่อ plot graph
# สามารถ กด enter ได้ 4 ครั้งเพื่อดูกราฟหลายๆอย่าง
# และข้างๆปุ่ม zoom จะมีลูกษรไปข้างหน้ากับย้อนกลับ
# สามารถกดดูอันก่อนๆได้ กลับไปกลับมาได้

plot(lm_result) # residuals plot

#------------------------------------------------------------------------------------#

# Multiple Linear Regression 
lm_multi_result <- lm(Discount ~ Age + Income, data=Car_discounts)

# result
lm_multi_result

# summary
summary(lm_multi_result)

# getting coefficient values
lm_multi_result$coefficients[["Age"]]
lm_multi_result$coefficients[["Income"]]

# plotting
plot(lm_multi_result)

#########################################################################################

##### Assignment #####

APT_Example = read.csv("/Users/Admin/Documents/Project_R/InClass/data/APT_Example.csv")

apt <- APT_Example %>%
  mutate(Asset.1 = Asset.1 - RF,
         Asset.2 = Asset.2 - RF,
         Asset.3 = Asset.3 - RF,
         Asset.4 = Asset.4 - RF,
         Asset.5 = Asset.5 - RF,
         Mkt = Mkt - RF)

#------------------------------------------------------------------------------------#

## Assignment 1

# Asset 1
capm_result_asset1 <- lm(Asset.1 ~ Mkt, data=apt)
summary(capm_result_asset1)

capm_result_asset1$coefficients
summary(capm_result_asset1)$adj.r.squared

# Asset 2
capm_result_asset2 <- lm(Asset.2 ~ Mkt, data=apt)
summary(capm_result_asset2)

capm_result_asset2$coefficients
summary(capm_result_asset2)$adj.r.squared

# Asset 3
capm_result_asset3 <- lm(Asset.3 ~ Mkt, data=apt)
summary(capm_result_asset3)

capm_result_asset3$coefficients
summary(capm_result_asset3)$adj.r.squared

# Asset 4
capm_result_asset4 <- lm(Asset.4 ~ Mkt, data=apt)
summary(capm_result_asset4)

capm_result_asset4$coefficients
summary(capm_result_asset4)$adj.r.squared

# Asset 5
capm_result_asset5 <- lm(Asset.5 ~ Mkt, data=apt)
summary(capm_result_asset5)

 capm_result_asset5$coefficients
summary(capm_result_asset5)$adj.r.squared

#------------------------------------------------------------------------------------#

## Assignment 2

# Asset 1
apt_result_asset1 <- lm(Asset.1 ~ Mkt + SMB + HML, data=apt)
summary(apt_result_asset1)

apt_result_asset1$coefficients
summary(apt_result_asset1)$adj.r.squared

# Asset 2
apt_result_asset2 <- lm(Asset.2 ~ Mkt + SMB + HML, data=apt)
summary(apt_result_asset2)

apt_result_asset2$coefficients
summary(apt_result_asset2)$adj.r.squared

# Asset 3
apt_result_asset3 <- lm(Asset.3 ~ Mkt + SMB + HML, data=apt)
summary(apt_result_asset3)

apt_result_asset3$coefficients
summary(apt_result_asset3)$adj.r.squared

# Asset 4
apt_result_asset4 <- lm(Asset.4 ~ Mkt + SMB + HML, data=apt)
summary(apt_result_asset4)

apt_result_asset4$coefficients
summary(apt_result_asset4)$adj.r.squared

# Asset 5
apt_result_asset5 <- lm(Asset.5 ~ Mkt + SMB + HML, data=apt)
summary(apt_result_asset5)

apt_result_asset5$coefficients
summary(apt_result_asset5)$adj.r.squared

#------------------------------------------------------------------------------------#











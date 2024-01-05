import pandas as pd
import numpy as np
import os
import EMACO # เอาฟังก์ชันสร้างกราฟ EMACO มาใช้
from sig import transformSig
from statistics import mean
from trade import tradeSim ##

files = os.listdir('data/') # list directory คือให้แสดงออกมาว่าใน directory data/ มีไฟล์อะไรอยู่บ้าง โดยจะสร้างเป็น list ขึ้นมา
A = []
for file in files: # อ้างถึง file ที่อยู่ใน list ของ files นี้ data ก็จะเริ่มจาก ADVANC.csv
    print(file) # ปริ้นชื่อไฟล์บนหน้าจอ
    df = pd.read_csv('data/'+file) # อ่านไฟล์ csv ที่อยู่บนหน้าจอที่ปริ้นที่ละไฟล์
    close = df['Close']
    [ema_short, ema_long] = EMACO.emaco(close,10,50) # รับค่า ema_short และ long ตามลำดับที่ return มา
    signal = EMACO.EMACO_Sig(ema_short,ema_long)
    signal = transformSig(signal) # แปลงสัญญาณให้เป็นแค่ 1 กับ -1
    profit = tradeSim(df,signal,file) # ส่งสิ่งที่ต้องการ 3 ตัวไปให้ก็คือ df signal
    A.append(profit) # เอา profit ที่ได้มาสร้างเป็น list A ทางด้านบน และค่อยๆเพิ่มข้อมูลผลต่อแทนต่อปีของหุ้นแต่ละตัว
avg = mean(A)
print(avg)
A.append(np.nan) # เอาค่าว่างต่อท้ายก่อนแล้วค่อยต่อด้วย avg
A.append(avg)
A = pd.Series(A) # แปลง list A ให้เป็น series 
A.to_csv('tradesim/_EMACO_profit.csv') # เอา series แปลงเป็น excel

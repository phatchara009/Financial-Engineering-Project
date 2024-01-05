# ปรับหา paramiters ที่ดีที่สุดสำหรับ
import pandas as pd # สร้างและจัดการ dataflames
import numpy as np # ใช้เวลาที่ต้องมีค่า nan
import os # คือ operating system คือการ list directory เพื่อดูว่ามีไฟล์ชื่ออะไรบ้าง
import RSI
from sig import transformSig # import จากไฟล์ sig.py เพื่อใช้ tranfromSig โดยไม่ต้องอ้าง sig.
from statistics import mean
from trade import tradeSim

A = []
files = os.listdir('data/') # list directory ให้ list ว่าใน folder data มีไฟล์อะไรบ้าง จะสร้างเป็น list ที่มีชื่อไฟล์ขึ้นมา
# สร้าง loop ซ้อนกัน 3 loop
# วน 3 loop แรกอย่างละ 4 รอบจากที่ comment ให้ดู เป็นทั้งหมด 64 รอบ
# loop สุดท้ายเป็นวนตามไฟล์ที่มี
# วิธีการ loop ตามลำดับ เช่น 4 20 50 , 4 20 60, 4 20 70, 4 20 80, 4 30 50, 4 30 60, 4 30 70, 4 30 80, 4 40 50, ..., 19, 50, 80 # 
# n หรือ periods คือระยะเวลา กำหนดว่า ค่าเริ่มต้นคือ 4 เพิ่มทีละ 5 และค่าสุดท้ายที่ไม่ทำคือ 20 ดังนั้น periods ที่จะทำคือ 4 9 14 19
for periods in range(4,20,5):
    # ระดับ OS กำหนดว่า ค่าเริ่มต้นคือ 20 เพิ่มทีละ 10 และค่าสุดท้ายที่ไม่ทำคือ 51 ดังนั้น periods ที่จะทำคือ 20 30 40 50
    for OS in range(20,51,10):
        # ระดับ OB กำหนดว่า ค่าเริ่มต้นคือ 50 เพิ่มทีละ 10 และค่าสุดท้ายที่ไม่ทำคือ 81 ดังนั้น periods ที่จะทำคือ 50 60 70 80
        for OB in range(50,81,10):
            print(periods,OS,OB)
            B = []
            C = []
            for file in files:
                df = pd.read_csv('data/'+file)
                close = df['Close']
                rsi = RSI.rsi(close,periods)
                signal = RSI.RSI_Sig(rsi,OS,OB)
                signal = transformSig(signal)
                profit = tradeSim(df,signal,file)
                C.append(profit)
            B = [periods,OS,OB,mean(C)];
            A.append(B);
A = pd.DataFrame(A) # แปลง list A เป็น dataflames
A.to_csv('tradesim/_RSI_profit.csv')

# พอไปเปิดไฟล์ csv ให้ดู 5 อันดับแรกและเลือก ค่า paramiter แต่ละตัวที่เป็นส่วนใหญ่ใน 5 อันดับแรก
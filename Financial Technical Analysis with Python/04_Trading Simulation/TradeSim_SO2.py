import pandas as pd
import numpy as np
import os
import SO2 
from sig import transformSig
from statistics import mean
from trade import tradeSim ##

files = os.listdir('data/')
A = []
for file in files:
    print(file)
    df = pd.read_csv('data/'+file)
    high = df['High']
    low = df['Low']
    close = df['Close']
    [sK, sD] = SO2.so(high,low,close,5,3,3) # ทำฟังก์ชันนี้เสร็จได้ sK และ sD มา
    signal = SO2.SO2_Sig(sK,sD) # เอา sK และ sD หาสัญญาณซื้อขาย
    signal = transformSig(signal) # แปลงสัญญาณซื้อขาย
    profit = tradeSim(df,signal,file) # หากำไรของหุ้นแต่ละรอบที่ลูปมา
    A.append(profit) 
avg = mean(A)
print(avg)
A.append(np.nan)
A.append(avg)
A = pd.Series(A)
A.to_csv('tradesim/_SO2_profit.csv')

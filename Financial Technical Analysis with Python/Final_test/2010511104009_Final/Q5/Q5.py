import pandas as pd
import numpy as np
from sig import transformSig
import os
from statistics import mean
from trade import tradeSim
from My_Signal import My_Sig

A = []
path = 'data/'
files = os.listdir(path)
for periods in range(4,15,5):
    for sp in range(5,21,5):
        for lp in range(25,101,25):
            print(periods,sp,lp)
            B = []
            C = []
            for file in files:
                df = pd.read_csv(path+file)
                close = df['Close']
                signal = My_Sig(close,periods,sp,lp)
                signal = transformSig(signal)
                profit = tradeSim(df,signal,file)
                C.append(profit)
            B = [periods,sp,lp,mean(C)];
            A.append(B);
A = pd.DataFrame(A)
A.to_csv('tradesim/_RSI_profit.csv')
print("Run เสร็จสมบูรณ์!!")

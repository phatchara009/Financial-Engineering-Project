import pandas as pd
import numpy as np
from sig import transformSig
import os
import RSI
from statistics import mean
from trade import tradeSim

A = []
path = 'data/'
files = os.listdir(path)
for periods in range(4,20,5):
    for OS in range(20,51,10):
        for OB in range(50,81,10):
            print(periods,OS,OB)
            B = []
            C = []
            for file in files:
                df = pd.read_csv(path+file)
                close = df['Close']
                rsi = RSI.rsi(close,periods)
                signal = RSI.RSI_Sig(rsi,OS,OB)
                signal = transformSig(signal)
                profit = tradeSim(df,signal,file)
                C.append(profit)
            B = [periods,OS,OB,mean(C)];
            A.append(B);
A = pd.DataFrame(A)
A.to_csv('tradesim/_RSI_profit.csv')

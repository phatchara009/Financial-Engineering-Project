import pandas as pd
import numpy as np 
import os
import EMACO
from sig import transformSig 
from statistics import mean
from trade import tradeSim

A = []
files = os.listdir('data/')
for sp in range(15,41,5):
    for lp in range(150,251,5):
        print(sp,lp)
        B = []
        C = []
        for file in files:
            df = pd.read_csv('data/'+file)
            close = df['Close']
            [ema_short, ema_long] = EMACO.emaco(close,sp,lp)
            signal = EMACO.EMACO_Sig(ema_short,ema_long)
            signal = transformSig(signal)
            profit = tradeSim(df,signal,file)
            C.append(profit)
        B = [sp,lp,mean(C)];
        A.append(B);
A = pd.DataFrame(A)
A.to_csv('tradesim/_EMACO_profit.csv')
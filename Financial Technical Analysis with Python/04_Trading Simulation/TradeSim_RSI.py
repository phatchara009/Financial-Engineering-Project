import pandas as pd
import numpy as np
import os
import RSI 
from sig import transformSig
from statistics import mean
from trade import tradeSim ##

files = os.listdir('data/')
A = []
for file in files:
    print(file)
    df = pd.read_csv('data/'+file)
    close = df['Close']
    rsi = RSI.rsi(close,14)
    signal = RSI.RSI_Sig(rsi,30,70)
    signal = transformSig(signal)
    profit = tradeSim(df,signal,file)
    A.append(profit) 
avg = mean(A)
print(avg)
A.append(np.nan)
A.append(avg)
A = pd.Series(A)
A.to_csv('tradesim/_RSI_profit.csv')

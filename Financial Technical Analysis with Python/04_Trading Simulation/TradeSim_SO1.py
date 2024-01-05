import pandas as pd
import numpy as np
import os
import SO1 
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
    sK = SO1.so(high,low,close,5,3)
    signal = SO1.SO1_Sig(sK,20,80)
    signal = transformSig(signal)
    profit = tradeSim(df,signal,file)
    A.append(profit) 
avg = mean(A)
print(avg)
A.append(np.nan)
A.append(avg)
A = pd.Series(A)
A.to_csv('tradesim/_SO1_profit.csv')

import pandas as pd
import numpy as np
import os
import MACD1 
from sig import transformSig
from statistics import mean
from trade import tradeSim ##

files = os.listdir('data/')
A = []
for file in files:
    print(file)
    df = pd.read_csv('data/'+file)
    close = df['Close']
    MACD = MACD1.macd(close)
    signal = MACD1.MACD1_Sig(MACD)
    signal = transformSig(signal)
    profit = tradeSim(df,signal,file)
    A.append(profit) 
avg = mean(A)
print(avg)
A.append(np.nan)
A.append(avg)
A = pd.Series(A)
A.to_csv('tradesim/_MACD1_profit.csv')

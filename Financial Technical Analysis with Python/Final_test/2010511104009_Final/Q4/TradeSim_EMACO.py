import pandas as pd
import numpy as np
import os
import EMACO
from sig import transformSig
from statistics import mean
from trade import tradeSim

files = os.listdir('data/')
A = []
for file in files:
    print(file)
    df = pd.read_csv('data/'+file)
    close = df['Close']
    [ema_short, ema_long] = EMACO.emaco(close,10,50)
    signal = EMACO.EMACO_Sig(ema_short,ema_long)
    signal = transformSig(signal)
    profit = tradeSim(df,signal,file)
    A.append(profit)
avg = mean(A)
print(avg)
A.append(np.nan)
A.append(avg)
A = pd.Series(A)
A.to_csv('tradesim/_EMACO_profit.csv')

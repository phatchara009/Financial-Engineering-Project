import pandas as pd
import numpy as np
import os
import BB 
from sig import transformSig
from statistics import mean
from trade import tradeSim ##

files = os.listdir('data/')
A = []
for file in files:
    print(file)
    df = pd.read_csv('data/'+file)
    close = df['Close']
    [mb,ub,lb] = BB.bb(close,20,2)
    signal = BB.BB_Sig(close,lb,ub)
    signal = transformSig(signal)
    profit = tradeSim(df,signal,file)
    A.append(profit) 
avg = mean(A)
print(avg)
A.append(np.nan)
A.append(avg)
A = pd.Series(A)
A.to_csv('tradesim/_BB_profit.csv')

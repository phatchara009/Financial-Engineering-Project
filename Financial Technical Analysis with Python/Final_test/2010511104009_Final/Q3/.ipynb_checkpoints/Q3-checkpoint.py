import pandas as pd
import numpy as np
from RSI import rsi
from MACD1 import macd

def My_Sig(RSI,MACD):
    rows = len(RSI)
    signal = [0]*rows
    for i in range(1,rows):
        if (RSI[i-1]<=30) and (RSI[i]>30) and (MACD[i]>0):
            signal[i] = 1
        elif (RSI[i-1]>=70) and (RSI[i]<70) and (MACD[i]<0):
            signal[i] = -1
    return signal
    
df = pd.read_csv('KBANK.csv')
close = df['Close']
RSI = rsi(close,14)
MACD = macd(close)
signal = My_Sig(RSI,MACD)
df['RSI'] = RSI
df['MACD'] = MACD
df['Signal'] = signal
df.to_csv('My_Signal.csv')
print("Run ได้แล้วจ้า")
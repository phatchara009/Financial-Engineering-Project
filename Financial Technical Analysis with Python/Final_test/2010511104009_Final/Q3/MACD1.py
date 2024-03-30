import pandas as pd
import numpy as np

def macd(close):
    ema_12 = close.ewm(span=12, adjust=False).mean()
    ema_12[0:11] = np.nan
    ema_26 = close.ewm(span=26, adjust=False).mean()
    ema_26[0:25] = np.nan
    MACD = ema_12-ema_26
    return MACD

def MACD1_Sig(MACD):
    rows = len(MACD)
    signal = [0] * rows
    for i in range(1,rows):
        if (MACD[i-1]<=0) and (MACD[i]>0):
            signal[i] = 1
        elif (MACD[i-1]>=0) and (MACD[i]<0):
            signal[i] = -1
    return signal
import pandas as pd
import numpy as np
import sig

def macd(close):
    ema_12 = close.ewm(span=12, adjust=False).mean()
    ema_12[0:11] = np.nan
    ema_26 = close.ewm(span=26, adjust=False).mean()
    ema_26[0:25] = np.nan
    MACD = ema_12-ema_26
    SL = MACD.ewm(span=9, adjust=False).mean()
    SL[0:25+9-1] = np.nan
    return [MACD, SL]

def MACD2_Sig(MACD,SL):
    rows = len(MACD)
    signal = [0] * rows
    for i in range(1,rows):
        if (MACD[i-1]<=SL[i-1]) and (MACD[i]>SL[i]):
            signal[i] = 1
        elif (MACD[i-1]>=SL[i-1]) and (MACD[i]<SL[i]):
            signal[i] = -1
    return signal


import pandas as pd
import numpy as np
import sig

def emaco(close,sp,lp):
    ema_short = close.ewm(span=sp, adjust=False).mean()
    ema_short[0:sp-1] = np.nan
    ema_long = close.ewm(span=lp, adjust=False).mean()
    ema_long[0:lp-1] = np.nan    
    return [ema_short,ema_long]

def EMACO_Sig(ema_short,ema_long): 
    rows = len(ema_short)
    signal = [0] * rows
    for i in range(1,rows):
        if (ema_short[i-1]<=ema_long[i-1]) and (ema_short[i]>ema_long[i]):
            signal[i] = 1
        elif (ema_short[i-1]>=ema_long[i-1]) and (ema_short[i]<ema_long[i]):
            signal[i] = -1
    return signal


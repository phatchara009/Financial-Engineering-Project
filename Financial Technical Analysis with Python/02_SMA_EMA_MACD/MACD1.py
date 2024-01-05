import pandas as pd
import numpy as np
def MACD1_Sig(close):
    rows = len(close)
    signal = [0] * rows
    ema_12 = close.ewm(span=12, adjust=False).mean()
    ema_12[0:11] = np.nan
    ema_26 = close.ewm(span=26, adjust=False).mean()
    ema_26[0:25] = np.nan
    macd = ema_12-ema_26
    for i in range(1,rows):
        if (macd[i-1]<=0) and (macd[i]>0):
            signal[i] = 1
        elif (macd[i-1]>=0) and (macd[i]<0):
            signal[i] = -1
    return [macd,signal]

df = pd.read_csv('data/SCB.csv')
close = df['Close']
[macd, signal] = MACD1_Sig(close)
df['MACD'] = macd
df['Signal'] = signal
df.to_csv('data/SCB_MACD1.csv')

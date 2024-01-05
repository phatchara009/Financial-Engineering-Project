import pandas as pd
import numpy as np
def MACD2_Sig(close):
    rows = len(close)
    signal = [0] * rows
    ema_12 = close.ewm(span=12, adjust=False).mean()
    ema_12[0:11] = np.nan
    ema_26 = close.ewm(span=26, adjust=False).mean()
    ema_26[0:25] = np.nan
    macd = ema_12-ema_26
    sl = macd.ewm(span=9, adjust=False).mean()
    sl[0:25+9-1] = np.nan
    for i in range(1,rows):
        if (macd[i-1]<=sl[i-1]) and (macd[i]>sl[i]):
            signal[i] = 1
        elif (macd[i-1]>=sl[i-1]) and (macd[i]<sl[i]):
            signal[i] = -1
    return [macd,sl,signal]

df = pd.read_csv('data/SCB.csv')
close = df['Close']
[macd, sl, signal] = MACD2_Sig(close)
df['MACD'] = macd
df['SL'] = sl
df['Signal'] = signal
df.to_csv('data/SCB_MACD2.csv')

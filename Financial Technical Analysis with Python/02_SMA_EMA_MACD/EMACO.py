import pandas as pd
import numpy as np
def EMACO_Sig(close,sp,lp):
    rows = len(close)
    signal = [0] * rows
    ema_short = close.ewm(span=sp, adjust=False).mean()
    ema_short[0:sp-1] = np.nan
    ema_long = close.ewm(span=lp, adjust=False).mean()
    ema_long[0:lp-1] = np.nan    
    for i in range(1,rows):
        if (ema_short[i-1]<=ema_long[i-1]) and (ema_short[i]>ema_long[i]):
            signal[i] = 1
        elif (ema_short[i-1]>=ema_long[i-1]) and (ema_short[i]<ema_long[i]):
            signal[i] = -1
    return [ema_short,ema_long,signal]
    
df = pd.read_csv('data/SCB.csv')
close = df['Close']
#Set short period as 10, and set long period as 50
[ema_short, ema_long, signal] = EMACO_Sig(close,10,50)
df['EMA_Short'] = ema_short
df['EMA_Long'] = ema_long
df['Signal'] = signal
df.to_csv('data/SCB_EMACO.csv')

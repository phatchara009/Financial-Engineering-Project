import pandas as pd
import sig

def bb(close,periods,nstd):
    mb = close.rolling(window=periods).mean()
    std = close.rolling(window=periods).std()
    ub = mb+nstd*std
    lb = mb-nstd*std
    return [mb,ub,lb]

def BB_Sig(close,lb,ub):
    rows = len(close)
    signal = [0] * rows
    for i in range(1,rows):
        if (close[i-1]<=lb[i-1]) and (close[i]>lb[i]):
            signal[i] = 1
        elif (close[i-1]>=ub[i-1]) and (close[i]<ub[i]):
            signal[i] = -1
    return signal



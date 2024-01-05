import pandas as pd
import sig

def so(high,low,close,kperiods,slowperiods,dperiods):
    ll = low.rolling(window=kperiods).min()
    hh = high.rolling(window=kperiods).max()
    fK = (close-ll)/(hh-ll)*100
    sK = fK.rolling(window=slowperiods).mean()
    sD = sK.rolling(window=dperiods).mean()
    return [sK, sD]

def SO2_Sig(sK,sD):
    rows = len(sK)
    signal = [0] * rows
    for i in range(1,rows):
        if (sK[i-1]<=sD[i-1]) and (sK[i]>sD[i]):
            signal[i] = 1
        elif (sK[i-1]>=sD[i-1]) and (sK[i]<sD[i]):
            signal[i] = -1
    return signal


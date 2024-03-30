import pandas as pd
import numpy as np

def rsi(close,n):
    rows = len(close)
    change = [0]*rows
    change[0] = np.nan
    for i in range(1,rows):
        change[i] = close[i]-close[i-1]
    changearr = np.array(change)
    gain = np.where(changearr>0,changearr,[0]*rows)
    gain[0] = np.nan
    loss = np.where(changearr<0,-changearr,[0]*rows)
    loss[0] = np.nan
    gain = pd.Series(gain)
    loss = pd.Series(loss)
    avg_gain = [0]*rows
    avg_loss = [0]*rows
    RS = [np.nan]*rows
    RSI = [np.nan]*rows
    avg_gain[n] = gain[1:n+1].mean()
    avg_loss[n] = loss[1:n+1].mean()
    RS[n] = avg_gain[n]/avg_loss[n]
    RSI[n] = 100-100/(1+RS[n])
    for i in range(n+1,rows):
        avg_gain[i] = ((n-1)*avg_gain[i-1]+gain[i])/n
        avg_loss[i] = ((n-1)*avg_loss[i-1]+loss[i])/n
        RS[i] = avg_gain[i]/avg_loss[i]
        RSI[i] = 100-100/(1+RS[i])
    return pd.Series(RSI)

def RSI_Sig(RSI,OS,OB):
    rows = len(RSI)
    signal = [0]*rows
    for i in range(1,rows):
        if (RSI[i-1]<=OS) and (RSI[i]>OS):
            signal[i] = 1
        elif (RSI[i-1]>=OB) and (RSI[i]<OB):
            signal[i] = -1
    return signal
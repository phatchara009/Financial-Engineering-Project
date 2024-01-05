import pandas as pd
import sig

def so(high,low,close,kperiods,slowperiods):
    ll = low.rolling(window=kperiods).min()
    hh = high.rolling(window=kperiods).max()
    fK = (close-ll)/(hh-ll)*100
    sK = fK.rolling(window=slowperiods).mean()
    return sK

def SO1_Sig(sK,OS,OB):
    rows = len(sK)
    signal = [0] * rows
    for i in range(1,rows):
        if (sK[i-1]<=OS) and (sK[i]>OS):
            signal[i] = 1
        elif (sK[i-1]>=OB) and (sK[i]<OB):
            signal[i] = -1
    return signal

df = pd.read_csv('data/SCB.csv')
high = df['High']
low = df['Low']
close = df['Close']
sK = so(high,low,close,5,3)
signal = SO1_Sig(sK,20,80)
df['slowK'] = sK
df['Signal'] = sig.transformSig(signal)
df.to_csv('data/SCB_SO1.csv')

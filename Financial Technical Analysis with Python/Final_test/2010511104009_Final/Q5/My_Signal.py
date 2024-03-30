from EMACO import emaco
from RSI import rsi

def My_Sig(close,periods,sp,lp):
    rows = len(close)
    signal = [0] * rows
    RSI = rsi(close, periods)
    [short_ema, long_ema] = emaco(close,sp,lp)
    for i in range(1,rows):
        if (RSI[i-1]<=30) and (RSI[i]>30):
            signal[i] = 1
        elif (short_ema[i-1]>=long_ema[i-1]) and (short_ema[i]<long_ema[i]):
            signal[i] = -1
    return signal

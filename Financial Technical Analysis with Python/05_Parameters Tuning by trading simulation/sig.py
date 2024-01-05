def transformSig(signal):
    rows = len(signal)
    signal[0] = -1
    for i in range(1,rows):
        if signal[i] == 0:
            signal[i] = signal[i-1];   
    return signal

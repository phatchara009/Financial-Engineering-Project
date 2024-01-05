import pandas as pd
import numpy as np

df = pd.read_csv('data/SCB.csv', index_col=0)
close = df['Close']
#calculate SMA
sma10 = close.rolling(window=10).mean()

#calculate EMA
ema10 = close.ewm(span=10, adjust=False).mean()
ema10[0:9] = np.nan

df['SMA10'] = sma10
df['EMA10'] = ema10
print(df.tail(10))
df.to_csv('data/newSCB.csv')


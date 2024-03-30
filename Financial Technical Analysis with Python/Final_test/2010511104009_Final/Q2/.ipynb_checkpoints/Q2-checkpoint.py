import pandas as pd
import numpy as np

df = pd.read_csv('KBANK.csv', index_col=0)
open = df['Open']
sma10O = open.rolling(window=10).mean()
ema10O = open.ewm(span=10, adjust=False).mean()
ema10O[0:9] = np.nan

df['SMA10O'] = sma10O
df['EMA10O'] = ema10O
df.to_csv('indicators.csv')
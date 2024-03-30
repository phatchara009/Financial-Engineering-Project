import datetime as dt
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
import pandas_datareader.data as web

start = dt.datetime(2015, 1, 1)
end = dt.datetime.now()
df = web.DataReader("CK.BK", 'yahoo', start, end)
print(df.tail())
close = df['Close']
mavg1 = close.rolling(window=25).mean()
mavg2 = close.rolling(window=100).mean()
mpl.rc('figure', figsize=(8, 7))
mpl.style.use('ggplot')
close.plot(label='CK')
mavg1.plot(label='SMA25')
mavg2.plot(label='SMA100')
plt.legend()
plt.show()

import datetime as dt
import pandas as pd
import pandas_datareader.data as web

start = dt.datetime(2015, 1, 1)
end = dt.datetime.now()
df = web.DataReader(["ADVANC.BK","CK.BK","DTAC.BK","SCB.BK","SAWAD.BK"],'yahoo', start, end)['Close']
df.columns = ['ADVANC','CK','DTAC','SCB','SAWAD']
returns = df.pct_change()
corr = returns.corr()
print(corr)

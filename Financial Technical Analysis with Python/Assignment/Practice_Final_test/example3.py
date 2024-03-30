import datetime as dt
import pandas as pd
import pandas_datareader.data as web
import matplotlib as mpl
import matplotlib.pyplot as plt

start = dt.datetime(2015, 1, 1)
end = dt.datetime.now()
df = web.DataReader(["ADVANC.BK","CK.BK","DTAC.BK","SCB.BK","SAWAD.BK"],'yahoo', start, end)['Close']
df.columns = ['ADVANC','CK','DTAC','SCB','SAWAD']
returns = df.pct_change()
plt.scatter(returns.mean(), returns.std())
plt.xlabel('Expected returns')
plt.ylabel('Risk')
for label, x, y in zip(returns.columns, returns.mean(), returns.std()):
    plt.annotate(
        label, 
        xy = (x, y), xytext = (20, -20),
        textcoords = 'offset points', ha = 'right', va = 'bottom',
        bbox = dict(boxstyle = 'round,pad=0.5', fc = 'yellow', alpha = 0.5),
        arrowprops = dict(arrowstyle = '->', connectionstyle = 'arc3,rad=0'))
plt.show()

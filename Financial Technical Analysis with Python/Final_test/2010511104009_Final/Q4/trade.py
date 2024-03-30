## Assumptions
## 1. Budget for each buy = 50,000.00 Baht
## 2. Buy at the open (ATO) of the next day after buy signals appear.
## 3. Commission and other fees for each buy or sell = 0.10%

import numpy as np
from math import floor

def tradeSim(df,signal,filename):
    Open = df['Open']
    rows = len(Open)
    num = 0
    total = 0
    Cost = 0
    numBuy = [np.nan]*rows
    cost = [np.nan]*rows
    numSell = [np.nan]*rows
    income = [np.nan]*rows
    profit = [np.nan]*rows
##  Buy & Sell Simulation    
    for i in range(1,rows-1):
        if (signal[i-1] == -1) and (signal[i] == 1):
            numBuy[i+1] = floor((50000/(Open[i+1]*1.0010))/50)*50
            num = numBuy[i+1]
            cost[i+1] = -numBuy[i+1]*Open[i+1]*1.0010
            Cost = cost[i+1]
        elif (signal[i-1] == 1) and (signal[i] == -1):
            numSell[i+1] = -num
            income[i+1] = -numSell[i+1]*Open[i+1]*0.9990
            profit[i+1] = income[i+1]+Cost;
            total = total + profit[i+1]
    filename = 'tradesim/' + filename
    df['Signal'] = signal
    df['NumBuy'] = numBuy
    df['Cost'] = cost
    df['NumSell'] = numSell
    df['Income'] = income
    df['Profit'] = profit
    df.to_csv(filename)
    total = total/50000/5*100
    return total

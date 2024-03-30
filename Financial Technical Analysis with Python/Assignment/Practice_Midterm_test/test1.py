import pandas as pd
data = {
    'apples': [3, 2, 0, 1], 
    'oranges': [0, 3, 7, 2]
}
purchases = pd.DataFrame(data)
print(purchases)

df = pd.read_csv('SCB.csv', index_col=0)
print(df)
print(df.tail(10))
df.info()
print(df.shape)
df.rename(columns = {
    'Open' : 'O',
    'High' : 'H',
    'Low' : 'L',
    'Close' : 'C',
    'Volume' : 'V'}, inplace = True)
df.to_csv('new_SCB.csv')
print(df['C'].describe())
print(df.describe())
X = df['C']
print(X)
Y = df[['H','L','C']]
print(Y)
A = df.loc['12/24/2015']
print(A)
B = df.loc['12/24/2015':'12/30/2015']
print(B)
C = df.iloc[0]
print(C)
D = df[(df['H']>=180) | (df['L']<=15)]
print(D)



#install pandas: "pip install pandas"
import pandas as pd
df=pd.read_csv('Data.csv')
#print(df.head())
print(df[df['price']<45000])
sort=df.sort_values(by="price",ascending=False)
print("\n Sorted data: ",sort)
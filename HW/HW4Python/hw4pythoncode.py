from pandas import DataFrame, Series
import pandas as pd; import numpy as np
from matplotlib import dates as mdates
from matplotlib import ticker as mticker
from matplotlib import pyplot as plt
from mplfinance.original_flavor import candlestick2_ochl
import datetime as dt


filepath = '000008.csv'
startdate = dt.date(2016, 1, 1)
enddate = dt.date(2016, 3, 30)

def readdata(path,eday):
    df = pd.read_csv(path,index_col = 0)
    df = df[df.index < eday.strftime('%Y-%m-%d')]
    return df

df = readdata(filepath,enddate)




fig = plt.figure(facecolor='#07000d',figsize=(10,5))
ax1 = plt.subplot(facecolor='#07000d')
##绘制k线图
candlestick2_ochl(ax = ax1,
                  opens = df["open"],
                  closes = df["close"],
                  highs = df["high"],
                  lows = df["low"],
                  width=0.5, colorup='r', colordown='g', alpha=0.75)
a = np.zeros(len(df.index))
ax1.grid(True, color='w')
ax1.yaxis.label.set_color("w")
ax1.spines['bottom'].set_color("#5998ff")
ax1.spines['top'].set_color("#5998ff")
ax1.spines['left'].set_color("#5998ff")
ax1.spines['right'].set_color("#5998ff")
ax1.tick_params(axis='y', colors='w')
plt.gca().yaxis.set_major_locator(mticker.MaxNLocator(prune='upper'))
ax1.tick_params(axis='x', colors='w')
plt.ylabel('Stock price and Volume')


##绘制成交量
volumeMin = 0
ax1v = ax1.twinx()
ax1v.fill_between(df.index.values,volumeMin, df.vol.values, facecolor='#00ffe8', alpha=.4)
ax1v.axes.yaxis.set_ticklabels([])
ax1v.grid(False)
ax1.xaxis.set_major_locator(mticker.MaxNLocator(10))
ax1v.set_ylim(0, 3*df.vol.values.max())
ax1v.spines['bottom'].set_color("#5998ff")
ax1v.spines['top'].set_color("#5998ff")
ax1v.spines['left'].set_color("#5998ff")
ax1v.spines['right'].set_color("#5998ff")
ax1v.tick_params(axis='x', colors='w')
ax1v.tick_params(axis='y', colors='w')
plt.show()











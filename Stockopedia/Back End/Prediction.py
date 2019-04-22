import numpy as np
from datetime import datetime
import smtplib
import time
from selenium import webdriver

from sklearn.linear_model import LinearRegression
from sklearn import preprocessing, svm
from sklearn.model_selection import train_test_split

from iexfinance.stocks import Stock
from iexfinance.stocks import get_historical_data

def predictData(stock, days):
    start = datetime(2017, 1, 1)
    end = datetime.now()

    df = get_historical_data(stock, start = start, end = end, output_format = 'pandas')

    csv_name = ('Exports/' + stock + '_Export.csv')
    df.to_csv(csv_name)
    df['prediction'] = df['close'].shift(-1)
    df.dropna(inplace = True)
    forecast_time = int(days)

    X = np.array(df.drop(['prediction'], 1))
    Y = np.array(df['prediction'])
    X = preprocessing.scale(X)
    X_prediction = X[-forecast_time:]

    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size = 0.5)

    clf = LinearRegression()
    clf.fit(X_train, Y_train)
    prediction = (clf.predict(X_prediction))

    print(prediction)

if __name__ == '__main__':
    predictData('AAPL', 5)
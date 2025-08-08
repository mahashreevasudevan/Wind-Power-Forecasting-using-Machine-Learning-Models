import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.stattools import adfuller
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Dropout, Bidirectional
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau
from sklearn.metrics import mean_squared_error, mean_absolute_error
from scipy.stats import pearsonr

# Loading the data 
df = pd.read_csv('D:\Wind\Wind Data.csv')
df['Hour'] = pd.to_datetime(df['Hour'])
df.set_index('Hour', inplace=True)

# Adding lags
df['WindSpeed_Lag1'] = df['WindSpeed'].shift(1)
df['WindSpeed_Lag2'] = df['WindSpeed'].shift(2)
df['WindPower_Lag1'] = df['GeneratedPower'].shift(1)
df.dropna(inplace=True)  

# Scaling the data
scaler = MinMaxScaler(feature_range=(0, 1))
df_scaled = scaler.fit_transform(df)

# Splitting the data into sequences
def create_sequences(data, seq_length):
    X, y = [], []
    for i in range(len(data) - seq_length):
        X.append(data[i:i + seq_length])
        y.append(data[i + seq_length][0])  
    return np.array(X), np.array(y)

# Adjusting the sequence length
seq_length = 168  

# Creating sequences
X, y = create_sequences(df_scaled, seq_length)

# Splitting the data into training and testing datasets
split = int(0.8 * len(X))
X_train, X_test = X[:split], X[split:]
y_train, y_test = y[:split], y[split:]

# BiLSTM model
model = Sequential()
model.add(Bidirectional(LSTM(100, return_sequences=True), input_shape=(X_train.shape[1], X_train.shape[2])))
model.add(Dropout(0.3))  
model.add(Bidirectional(LSTM(100)))
model.add(Dropout(0.3))
model.add(Dense(1))  


optimizer = Adam(learning_rate=0.001)
model.compile(optimizer=optimizer, loss='mean_squared_error')


early_stopping = EarlyStopping(monitor='val_loss', patience=10, restore_best_weights=True)
reduce_lr = ReduceLROnPlateau(monitor='val_loss', factor=0.2, patience=5, min_lr=0.0001)

# Training the model
history = model.fit(X_train, y_train, epochs=50, batch_size=32, validation_data=(X_test, y_test),
                    callbacks=[early_stopping, reduce_lr])

# Plotting the training and validation loss
plt.figure(figsize=(8, 6))
plt.plot(history.history['loss'], label='Training Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')
plt.title('Training and Validation Loss', fontsize=12, fontname='Times New Roman')
plt.xlabel('Epochs', fontsize=12, fontname='Times New Roman')
plt.ylabel('Loss', fontsize=12, fontname='Times New Roman')
plt.legend()
plt.show()

# Forecasting
train_predict = model.predict(X_train)
test_predict = model.predict(X_test)


train_predict = train_predict.reshape(-1, 1)
test_predict = test_predict.reshape(-1, 1)

# Inverse transform 
train_predict = scaler.inverse_transform(np.concatenate((train_predict, X_train[:, -1, 1:]), axis=1))[:, 0]
y_train = scaler.inverse_transform(np.concatenate((y_train.reshape(-1, 1), X_train[:, -1, 1:]), axis=1))[:, 0]
test_predict = scaler.inverse_transform(np.concatenate((test_predict, X_test[:, -1, 1:]), axis=1))[:, 0]
y_test = scaler.inverse_transform(np.concatenate((y_test.reshape(-1, 1), X_test[:, -1, 1:]), axis=1))[:, 0]

# Error Metrics
metrics = {
    'Train MSE': mean_squared_error(y_train, train_predict),
    'Test MSE': mean_squared_error(y_test, test_predict),
    'Train RMSE': np.sqrt(mean_squared_error(y_train, train_predict)),
    'Test RMSE': np.sqrt(mean_squared_error(y_test, test_predict)),
    'Train MAE': mean_absolute_error(y_train, train_predict),
    'Test MAE': mean_absolute_error(y_test, test_predict),
    'Train Correlation Coefficient': pearsonr(y_train, train_predict)[0],
    'Test Correlation Coefficient': pearsonr(y_test, test_predict)[0]
}

for metric, value in metrics.items():
    print(f'{metric}: {value}')

# Plot actual vs forecasted values 
plt.figure(figsize=(8, 6))
plt.plot(df.index[-24:], y_test[-24:], color='blue', label='Actual Wind Power')
plt.plot(df.index[-24:], test_predict[-24:], color='red', label='Forecasted Wind Power')
plt.title('Actual vs Forecasted Wind Power', fontsize=12, fontname='Times New Roman')
plt.xlabel('Date-Time', fontsize=12, fontname='Times New Roman')
plt.ylabel('Power (in kW)', fontsize=12, fontname='Times New Roman')
plt.legend()
plt.show()

# Residual Analysis Plot for Test Data
test_residuals = y_test - test_predict
plt.figure(figsize=(10, 5))
plt.plot(df.index[-len(test_residuals):], test_residuals, color='orange', label='Test Residuals')
plt.title('Residuals for Test Data', fontsize=12, fontname='Times New Roman')
plt.xlabel('Date-Time', fontsize=12, fontname='Times New Roman')
plt.ylabel('Residuals', fontsize=12, fontname='Times New Roman')
plt.legend()
plt.grid(True)
plt.show()

# Regression Plot for Test Data
plt.figure(figsize=(8, 6))
plt.scatter(y_test, test_predict, color='blue', label='Regression Plot')
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], color='red', lw=2, label='45-degree Line')
plt.xlabel('Actual Wind Power (kW)', fontsize=12, fontname='Times New Roman')
plt.ylabel('Predicted Wind Power (kW)', fontsize=12, fontname='Times New Roman')
plt.legend()
plt.grid(True)
plt.show()

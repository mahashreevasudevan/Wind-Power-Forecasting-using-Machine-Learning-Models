import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_absolute_error, mean_squared_error
import matplotlib.pyplot as plt
import xgboost as xgb

# Loading the dataset
winddata = pd.read_excel('D:/Wind/winddata1.xlsx')

# Creating lag features 
def create_lag_features(winddata, lags=[1, 3, 5, 10]):
    for lag in lags:
        winddata[f'Power_lag_{lag}'] = winddata['Power'].shift(lag)
    winddata = winddata.dropna()  
    return winddata

# Using multiple lags to capture temporal dependencies
winddata_lags = create_lag_features(winddata, lags=[1, 3, 5, 10])

# Preparing parameters (X) and target (y)
X = winddata_lags[['WS', 'pitch', 'Time', 'Power_lag_1', 'Power_lag_3', 'Power_lag_5', 'Power_lag_10']].values
y = winddata_lags['Power'].values

# Scaling the parameters
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Selecting the last 144 points for testing
test_size = 144
X_train, X_test, y_train, y_test = X_scaled[:-test_size], X_scaled[-test_size:], y[:-test_size], y[-test_size:]

# Setting up XGBoost parameters and hyperparameter tuning
xgb_model = xgb.XGBRegressor(objective='reg:squarederror', n_estimators=100)

# Hyperparameter tuning using GridSearchCV
param_grid = {
    'max_depth': [4, 6, 8],
    'learning_rate': [0.05, 0.1, 0.2],
    'subsample': [0.7, 0.8, 0.9],
    'colsample_bytree': [0.7, 0.8, 0.9]
}

grid_search = GridSearchCV(xgb_model, param_grid, cv=3, scoring='neg_mean_squared_error')
grid_search.fit(X_train, y_train)

# Best model from GridSearchCV
best_model = grid_search.best_estimator_

# Training best model with eval_set to track training and validation loss
eval_set = [(X_train, y_train), (X_test, y_test)]
best_model.fit(
    X_train,
    y_train,
    eval_set=eval_set,
    eval_metric='rmse',
    verbose=False
)

# Make forecasts only for the last 144 points
y_pred_test = best_model.predict(X_test)

# Evaluating the model performance for the last 144 points
mae = mean_absolute_error(y_test, y_pred_test)
rmse = np.sqrt(mean_squared_error(y_test, y_pred_test))
mse = mean_squared_error(y_test, y_pred_test)

print(f'Mean Absolute Error (MAE) for last 144 points: {mae}')
print(f'Root Mean Squared Error (RMSE) for last 144 points: {rmse}')
print(f'Mean Squared Error (MSE) for last 144 points: {mse}')

# Plotting actual power values vs forecasted
plt.figure(figsize=(10, 6))
plt.plot(y_test, label='Actual Wind Power')
plt.plot(y_pred_test, label='Forecasted Wind Power')
plt.title('Wind Power Forecasting with XGBoost')
plt.xlabel('Number of Datapoints')
plt.ylabel('Wind Power (in MW)')
plt.legend()
plt.show()

# Plotting training vs validation loss
results = best_model.evals_result()

plt.figure(figsize=(10, 6))
plt.plot(results['validation_0']['rmse'], label='Train RMSE')
plt.plot(results['validation_1']['rmse'], label='Validation RMSE')
plt.title('Training vs Validation RMSE')
plt.xlabel('Boosting Round')
plt.ylabel('RMSE')
plt.legend()
plt.grid(True)
plt.show()


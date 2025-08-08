# Wind Power Forecasting 

This repository contains a collection of traditional machine learning, deep learning, and physics-informed models developed for short-term (day-ahead) **wind power forecasting**. Each model explores different forecasting strategies using historical wind data.

## Objective:

Wind power forecasting is essential for grid stability and efficient renewable energy integration. This project evaluates various modeling techniques to forecast short-term (day-ahead) wind power based on historical data.

## Models Included:

| Model              | Folder            | Description |
|--------------------|-------------------|-------------|
| **XGBoost**        | `XGBoost/`         | Gradient boosting model leveraging tabular features. |
| **BiLSTM**         | `BiLSTM/`          | Bidirectional LSTM for capturing temporal patterns in time series data. |
| **ARIMA**          | `ARIMA/`           | Classical statistical model for linear time series forecasting. |
| **MLP Regressor**  | `MLP Regressor/`   | Feedforward neural network for regression on extracted features. |
| **Time-MoE**       | `Time-MOE/`        | Mixture-of-Experts model designed for time series data. |
| **PINN**           | `PINN/`            | Physics-Informed Neural Network integrating domain knowledge. |

**Note**: The code and model description can be found in the folder for each model

## Data:
- The wind data for **ARIMA** and **BiLSTM** model are taken from Copernicus Climate Data Store (ERA5 hourly data) at 1-hr interval, whereas for rest of the models like **XGBoost**, **MLP Regressor**, **Time-MOE**, and **PINN**, the wind data is from NIWE at 10-minute interval.
- The wind power data is generated using Pow Gen.m file and power curve data of 2MW wind turbine. 

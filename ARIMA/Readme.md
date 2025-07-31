# ARIMA-Based Wind Power Forecasting Model

This project uses an ARIMA (AutoRegressive Integrated Moving Average) model to forecast wind speed and forecast wind power generation using a normalized power curve.

---

## 🎯 Key Objectives

- Forecast wind speed using the ARIMA model.
- Convert forecasted wind speed to power output using a normalized power curve.
- Evaluate the accuracy of the model using error metrics (MSE, RMSE, MAE, Correlation).

---

## 🧪 Methodology

1. Load and visualize historical wind speed data.
2. Analyze time series properties using ACF and PACF plots.
3. Fit an ARIMA model to the wind speed data.
4. Map wind speed to power using a normalized turbine power curve.
5. Validate the model with standard statistical metrics.

![ARIMA Workflow](./images/arima_workflow_flowchart.png)

---

## 🔁 Model Pipeline

1. **Data Loading**: Read wind speed data from Excel.
2. **Visualization**: Plot time series to understand seasonal trends.
   ![Wind Speed Time Series](./images/wind_speed.png)
3. **ACF/PACF Analysis**: Help select ARIMA parameters.
   - ![ACF Plot](./images/acf_plot.png)
   - ![PACF Plot](./images/pacf_plot.png)
4. **Model Fitting**: Fit ARIMA using selected parameters.
5. **Power Curve Mapping**: Estimate power output.
   ![Power Curve](./images/power_curve.png)
6. **Forecasting**: Plot predicted power output.
   ![ARIMA Forecast Output](./images/arima_forecast.png)

---

## ⚠️ Challenges Addressed

- **Non-stationarity** in wind speed time series.
- Conversion of meteorological data to electrical power output.
- Smoothing inconsistencies in the power curve using interpolation.

---

## 📊 Results

| Metric                | Value   |
|-----------------------|---------|
| **MSE**               | 0.0097  |
| **RMSE**              | 0.0986  |
| **MAE**               | 0.0709  |
| **Correlation Coeff** | 0.8602  |

The ARIMA model demonstrates strong performance for short-term forecasting and aligns well with actual power generation trends.

---

## 🌍 Impact

- Enhances short-term wind power prediction.
- Supports energy system planning and grid integration of renewables.
- Provides a baseline for comparing ML/DL models like BiLSTM or KANN.

---

## 🛠️ Technology & Tools

- **Language**: MATLAB
- **Toolboxes**:
  - Econometrics Toolbox (for ARIMA)
  - Curve Fitting Toolbox (for power curve interpolation)
- **Input**: `.xlsx` wind speed dataset
- **Output**: Excel file of estimated power values

---

## 📁 File Structure

```text
ARIMA/
├── arima_model.m           # Main script for forecasting
├── README.md               # This file
├── images/
│   ├── arima_workflow_flowchart.png
│   ├── acf_plot.png
│   ├── pacf_plot.png
│   ├── wind_speed.png
│   ├── power_curve.png
│   └── arima_forecast.png

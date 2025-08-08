# Wind Power Forecasting with Time-MOE

The wind data has lot of variations and small errors can cost a lot. This project focuses on day-ahead wind power forecasting using a custom Mixture of Experts (Time-MOE) model built with TensorFlow. It uses both historical turbine data and engineered time features to forecast wind power.

## Key Objectives:

- Forecast short-term (day-ahead - 144 data points) wind power output based on historical turbine data
- Build a model that adapts to complex, non-linear patterns in time-series data
- Use descriptive and predictive analytics to enhance decision intelligence
- Evaluate how well Time-MOE handles variations in wind speed, pitch, and daily cycles
- Make the model interpretable with SHAP to understand feature importance

## Methodology:

This model includes:
- Data exploration using engineered features such as lag variables and cyclical time encodings
- Predictive modeling with a custom TensorFlow Mixture-of-Experts (MOE) architecture
- Improving predictive performance using gating networks to dynamically weigh expert opinions
- Data filtering and preprocessing with scaling and lag-based feature enrichment
- Model interpretability via SHAP to make model decisions more transparent

## Model Pipeline:

**Data Source** - The Wind data at 10-minute interval and the 2 MW wind turbine power curve data is taken from NIWE. The wind power data is geenrated from the wind speed data using the Pow Gen.m file. 

<img width="997" height="569" alt="WS-NIWE DATA" src="https://github.com/user-attachments/assets/9a2a663f-8cb7-4890-97ba-96a6c61178f2" />
<img width="785" height="620" alt="Power curve - newnew" src="https://github.com/user-attachments/assets/d2728c1c-dd91-405f-a9a9-6c3bfd63eb41" />

**1.Data Preparation**:
- Wind data from an Excel file
- Convert day-based timestamps to datetime
- Create sin_time and cos_time features for hour encoding
- Add lag features for wind speed, pitch, and power

**2.Preprocessing**:
- Drop NaNs from lagged features
- Standardize inputs using StandardScaler

**3.Training**:
- Split wind data into train and test datasets (80/20)
- Build and train the Time-MOE model with 3 experts and softmax gating
- Use AdamW optimizer for stability with weight decay
- Monitor both training and validation loss across 200 epochs

**4.Evaluation & Visualization**:
- Forecast wind power on the test set
- Compare actual vs predicted plots
- Compute MSE, MAE, RMSE
- Run SHAP for post-hoc interpretability

## Challenges Addressed:

- Capturing wind power trends over time with temporal encoding
- Reducing model overfitting with regularization and validation tracking
- using lag smoothing to understand the variations in the wind power data
- Explaining forecasts via SHAP 

## Results:

- The Time-MOE model forecasts wind power output with high accuracy.
- Validation loss converged quickly and remained stable across epochs.
- SHAP analysis revealed wind speed and lagged power as top contributors.
- The forecasted vs actual plot shows the model captures both trend and temporal seasonality well.
- Both RMSE and MAE is low, showing low forecast errors.

  | Metric | Value |
  |--------|--------|
  | MSE    | 2.219|
  | RMSE   |  1.490|
  | MAE    | 1.132|
  
<img width="877" height="545" alt="Time-MOE Loss" src="https://github.com/user-attachments/assets/4cafebdb-3ea9-43bc-a53d-08eb6ab45c7e" />
<img width="1189" height="590" alt="Time-MOE Forecast" src="https://github.com/user-attachments/assets/74128b64-6cb0-49d6-add2-aaaeb25d8cba" />

## Impact:

This model can be adapted for energy management systems, allowing operators to plan better around variable wind input. With high-resolution forecasting, even small gains in accuracy can reduce grid imbalances, save costs, and support renewable integration. It also demonstrates how domain-specific time encoding and MOE architectures work in real-world data scenarios.

## Technology & Tools:

- **Python**, **TensorFlow/Keras** for deep learning model development
- **Pandas**, **NumPy**, **Matplotlib** for data handling and visualization
- **SHAP** for interpretability
- **Scikit-learn** for preprocessing and metrics
- Feature engineering using cyclical encoding, lag-based memory, and temporal filtering





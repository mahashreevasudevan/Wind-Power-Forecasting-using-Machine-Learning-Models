# Wind Power Forecasting with XGBoost

This project focuses on forecasting wind power using historical turbine data and gradient boosting techniques. The goal is to capture the temporal patterns in wind energy production and deliver accurate short-term forecast.

## Key Objectives:

- Forecast short-term wind power based on historical data.
- Include lag-based temporal features to improve forecast accuracy.
- Build a scalable, testable pipeline that supports data filtering, model tuning, and evaluation.
- Use model interpretability and evaluation plots to assess performance across time windows.

## Methodology:

- **Data Source** - The wind speed data at 10-minute interval and the power curve data of 2 MW wind turbine is taken from the NIWE website.
- The wind power values are generated from the wind speed values using Pow Gen.m file.
- The power data is read and the lag features are identified to capture previous power values. These features are essential for modeling time-dependent behavior, which is common in energy systems.
- Descriptive analytics helped understand the relationships between parameters like wind speed (`WS`), blade pitch, and past power outputs which aided in modeling process.
- Training a gradient boosting model (XGBoost) to forecast future power values. The model was evaluated on the final 144 observations.

  <img width="997" height="569" alt="WS-NIWE DATA" src="https://github.com/user-attachments/assets/66147eb3-f241-4c1c-a421-270ced92dc0e" />
  <img width="785" height="620" alt="Power curve - newnew" src="https://github.com/user-attachments/assets/1b5072bb-1cba-438e-b63b-5447e0f162a5" />

## Model Pipeline:

1. **Data Loading & Cleaning**
   - Importing data from Excel
   - Creating lag-based features for temporal insight
   - Dropped NaN values resulting from lagging

2. **Feature Engineering**
   - Selected meaningful inputs: wind speed, pitch, time, and multiple lagged power values

3. **Data Scaling**
   - Applied standardization using `StandardScaler` for better model performance

4. **Train-Test Split**
   - Used time-aware splitting (most recent 144 rows as test data) to maintain sequence

5. **Model Selection**
   - Trained an XGBoost regressor with a defined parameter grid
   - Tuned hyperparameters using `GridSearchCV` for optimal inference performance

6. **Model Training & Evaluation**
   - Evaluated forecasts with **MAE**, **MSE**, and **RMSE**
   - Visualized results and training vs. validation performance to detect overfitting

7. **Forecasting**
   - Forecasted future wind power output and compared it against actual measurements

## Challenges Addressed:

- **Temporal dependencies**: Tackled using lag features to inject memory into the model.
- **Data filtering**: Removed incomplete sequences caused by lagging.
- **Model tuning complexity**: Solved with grid search over key XGBoost hyperparameters.
- **Overfitting risk**: Monitored using validation RMSE and early stopping principles.
- **Inference optimization**: Focused on minimizing test-time RMSE and ensuring scalable prediction.

## Results:

The model achieved strong results on the test data:

- **MAE**: 1.965
- **RMSE**: 2.957
- **MSE**: 8.744

These numbers show the model was able to make accurate short-term forecasts, especially considering the natural variation in wind power. The relatively low MAE suggests the model kept individual forecast errors small, and the RMSE indicates good consistency without large error values.

The actual vs forecasted power plot showed a close match across most time periods, and the training vs validation RMSE curves remained stable throughout boosting rounds indicating that the model didn’t overfit.

<img width="842" height="525" alt="XGBOOST - LOSS" src="https://github.com/user-attachments/assets/65442b70-bc63-4a3a-b5d5-2013980c79f7" />
<img width="850" height="545" alt="XGBOOST" src="https://github.com/user-attachments/assets/3fd2a1ee-449a-4789-b655-f2c3b55b1223" />

## Impact:

Forecasting wind power helps energy providers plan grid operations more efficiently and reduce dependence on non-renewables. This project simulates how decision intelligence can emerge from clean, versioned data and optimized modeling.

With the lag-based feature engineering and predictive model in place, this work lays the groundwork for real-time forecasting or deployment in low-latency environments.

## Technology and Tools:

- **Python** for scripting and modeling
- **Pandas** and **NumPy** for data manipulation
- **Matplotlib** for visualization
- **Scikit-learn** for scaling, splitting, and evaluation
- **XGBoost** for fast, accurate regression modeling
- **GridSearchCV** for hyperparameter tuning
- **Excel** as the data source






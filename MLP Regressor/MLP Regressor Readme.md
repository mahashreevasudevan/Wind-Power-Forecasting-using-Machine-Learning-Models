# Wind Power Forecasting with MLP Regressor

This project is about short-term wind power forecasting using an MLP Regressor model. It uses wind speed and wind turbine blade pitch angle as inputs to forecast the power output of a wind turbine. The goal is to capture patterns in historical wind behavior and forecast trends with a focus on accuracy and inference efficiency.

## Key Objectives:

- Forecast short-term wind power output using historical wind data.
- Identify and learn non-linear relationships between wind speed, pitch, and power generation.
- Use predictive analytics to support better energy planning decisions.
- Build a clean, reproducible pipeline that can be expanded and version-controlled.

## Methodology:

This project applies predictive modeling to forecast future wind power output. The main steps include:

- Data preprocessing and feature selection. **Data Source** - The wind data and the 2Mw wind turbine power curve data is taken from NIWE.  
- Train-test split with clear separation for forecasting
- Training a multi-layer perceptron (MLP) model
- Evaluation using MAE, MSE, and RMSE
- Visualization of model performance to validate generalization

<img width="997" height="569" alt="WS-NIWE DATA" src="https://github.com/user-attachments/assets/d270fb2d-2883-4b69-8c39-5a51a92061eb" />
<img width="785" height="620" alt="Power curve - newnew" src="https://github.com/user-attachments/assets/a00c6e56-cdb6-4269-bbad-a35235b6cc59" />

## Model Pipeline:

1. **Data Loading:** Reads structured wind data from Excel, including wind speed, pitch angle, and actual power output.
2. **Filtering:** Selects only the relevant features for modeling, improving focus and reducing noise.
3. **Data Split:** Holds out the last 144 data points for dedicated forecasting.
4. **Training:** Uses a two-layer MLP (64 and 32 neurons) with ReLU activation and the Adam optimizer. Training is done on the earlier portion of the dataset.
5. **Forecasting & Inference:** Predicts power output for the last 144 data points and calculates standard error metrics.
6. **Visualization:** Plots the actual vs predicted power to reveal how well the model captures trends and fluctuations.

## Challenges Addressed:

- **Non-linearity in Wind Behavior:** Wind speed and turbine pitch don’t affect power linearly. MLP helps capture these complex patterns.
- **Data Parallelism:** Efficient training using vectorized operations in `scikit-learn` to handle moderate-sized datasets smoothly.
- **Inference Optimization:** The forecasting step runs quickly and can scale to larger datasets with minimal changes.
- **Forecast Accuracy:** Focus on reducing error metrics (MAE, RMSE) while keeping the model lightweight.

## Results:

- **MAE:** 2.230
- **RMSE:** 4.079
- **MSE:** 16.643

The model tracks the actual power output closely, even during sharp changes in wind behavior. The forecast curve aligns well with real data, capturing both trends and anomalies. These results suggest the model understands the nonlinear dynamics between wind speed, pitch, and power making it ideal for short-term planning and quick operational insights.


<img width="850" height="545" alt="output" src="https://github.com/user-attachments/assets/eb522361-d05a-4636-9650-27e373371322" />


## Impact:

This forecasting model supports decision intelligence for wind farms. With more accurate short-term predictions, wind farms can:

- Balance supply and demand better
- Schedule maintenance without disrupting output
- Improve grid reliability and efficiency

## Technology and Tools:

- **Languages & Libraries:** Python, Pandas, NumPy, scikit-learn, Matplotlib
- **Machine Learning:** MLPRegressor (Multi-layer Perceptron)




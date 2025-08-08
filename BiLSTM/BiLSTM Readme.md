# Wind Power Forecasting Using BiLSTM (Bidirectional Long Short-Term Memory)

This project focuses on day-ahead forecasting wind power based on historical wind data. The goal is to build a forecasting model that understands temporal patterns and produces accurate short-term predictions. This kind of model supports decision intelligence for energy management and helps integrate wind energy more reliably into the grid.

## Key Objectives:
- Forecast short-term(day-ahead) wind power using historical wind data
- Identify temporal trends and seasonal patterns using lag features and sequence modeling
- Evaluate model accuracy using standard regression metrics (MSE, RMSE, MAE, correlation)
- Compare model forecasts to actual values to verify alignment
- Build a repeatable, scalable pipeline for time series forecasting using BiLSTM

## Methodology:

**Data Source** - The historical wind speed data of 1-hour interval and the power curve data of 2 MW wind turbine is taken from Copernicus Climate Data Store (ERA5 hourly data). The wind power is generated using the Pow Gen.m file.

<img width="1995" height="1035" alt="wind speed - newnew" src="https://github.com/user-attachments/assets/e47e9417-e5a7-4279-a77e-b67aab2a1b7b" />
<img width="785" height="620" alt="Power curve - newnew" src="https://github.com/user-attachments/assets/81fb8377-d1f4-402e-92d4-87b18b5d0e40" />

**1. Data Stationarity Check** - 
Used the ADF (Augmented Dickey-Fuller) test to assess stationarity.

**2. ACF & PACF Analysis** - 
- The Autocorrelation Function (ACF) tells us how much the current value depends on previous values — like lagged correlations
- The Partial Autocorrelation Function (PACF) isolates the effect of each lag, removing contributions from earlier lags
- These plots helped in identifying useful lags to add as input features

<img width="564" height="435" alt="acf-newnew" src="https://github.com/user-attachments/assets/bdc254d0-abe8-4385-a138-c8d267829430" />
<img width="564" height="435" alt="pacf-newnew" src="https://github.com/user-attachments/assets/f749d71c-6de7-4f5b-b98c-d235a37a02e0" />

**3.Lag Feature Engineering** -
Added lagged features like WindSpeed_Lag1, WindSpeed_Lag2, and WindPower_Lag1. This provides the model with historical context, improving predictive performance.

**4. Scaling** - 
- Used MinMaxScaler to normalize all features to a range of 0 to 1.
- This helps the LSTM layers converge faster and perform better.

**5. Sequence Generation** -
Reshaped the data into weekly sequences (168 time steps = 24 hours × 7 days). This captures weekly patterns and seasonal wind trends.

## Model Pipeline:

Here’s a detailed breakdown of the model:
- **Input Shape**: (168, features)
- **Layer 1**: Bidirectional LSTM with 100 units and return_sequences=True
- **Dropout**: 0.3 dropout rate to reduce overfitting
- **Layer 2**: Another Bidirectional LSTM with 100 units
- **Dropout**: Another 0.3 dropout
- **Output Layer**: Dense layer with 1 unit to predict wind power
- **Optimizer**: Adam (learning rate = 0.001)
- **Loss Function**: Mean Squared Error
- **Epochs**: Trained up to 50 epochs with early stopping based on validation loss
- **Batch Size**: 32
- **Callbacks**: ReduceLROnPlateau to decrease learning rate if performance plateaus

This architecture helps the model learn both forward and backward dependencies in the time series, making it more aware of context across time.

<img width="2844" height="2305" alt="BILSTM FLOWCHART2908NEW" src="https://github.com/user-attachments/assets/a5bb755d-ad81-48a3-9fab-55aed3c070d5" />

## Challenges Addressed:

- Non-stationary behavior in wind data was managed through differencing and lag analysis
- Temporal dependencies were tackled using BiLSTM’s dual-direction learning
- Scaling issues avoided using normalization and inverse transformations
- Overfitting reduced through Dropout, EarlyStopping, and learning rate scheduling
- Forecast error handled via lag filtering and smoothing the model outputs

## Results:
The model did well in terms of accuracy and generalization:

| Metric | Value |
|--------|--------|
| MSE    | 0.0033|
| RMSE   |  0.0580|
| MAE    | 0.0285|
| Correlation Coefficient  |  0.9455|

- **Training and Validation Loss** plot shows steady convergence, with the validation loss remaining consistently low which means the model generalizes without overfitting.
- **Regression Plot** compares actual vs forecasted wind power on the test set. Most points follow the red 45-degree line, showing that the predictions are closely aligned with the actual data.
- **Forecast vs Actual Plot** focuses on the last 24 hours. The red line is the model’s forecast, and the blue line is the actual power generated. The predictions clearly follow the shape and peaks of the real values, which is critical in energy forecasting.

<img width="708" height="549" alt="loss-newnew" src="https://github.com/user-attachments/assets/a9d656ce-b682-48d6-9a26-fd4e962a4de6" />
<img width="692" height="525" alt="regression - newnew" src="https://github.com/user-attachments/assets/8ecf5da4-c5e6-4ba2-9791-bbd585960c41" />
<img width="721" height="527" alt="download" src="https://github.com/user-attachments/assets/e6e54045-bd9c-4600-be70-1240dbba8aea" />

## Impact:

Accurate wind power forecasting helps reduce reliance on backup fossil fuels, improves energy storage decisions, and boosts the reliability of renewable sources in the grid. This model can serve as a stepping stone for real-time deployment in wind farms or energy trading platforms.

## Technology and Tools:

- **Python**
- **Pandas**, **NumPy** for data wrangling
- **Matplotlib** and **Statsmodels** for ACF/PACF and plotting
- **MinMaxScaler** for feature scaling
- **TensorFlow/Keras** for deep learning
- **Pearson correlation**, MAE, RMSE for evaluation





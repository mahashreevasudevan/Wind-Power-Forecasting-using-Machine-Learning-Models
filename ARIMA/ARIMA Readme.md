## Wind Power Forecasting with ARIMA

This project forecasts wind power output using a rolling ARIMA model. It’s built using real-world data, and the goal is to understand and forecast how much power wind turbines might produce over the next day.

## Key Objectives:

Wind is unpredictable, and that makes it difficult to plan energy use. This project helps with that by:
- Forecasting wind power a day ahead  
- Using patterns in historical data to make decisions about the future  
- These guesses are done using a rolling window, which keeps things dynamic and accurate

## Model Pipeline:

### Data Source - 
The historical wind speed data of 10-mintute interval is taken from Copernicus Climate Data Store (ERA5 hourly data). 
The wind power is generated using the Pow Gen.m file. 

<img width="1995" height="1035" alt="wind speed - newnew" src="https://github.com/user-attachments/assets/d4c3828d-c33b-4c09-8707-e63faf226307" />
<img width="785" height="620" alt="Power curve - newnew" src="https://github.com/user-attachments/assets/e8db487e-8c97-4626-a95a-c5fbdd8e8c02" />

### 1. Load and Prepare the Data  
- Load wind speed and power data from CSV files  
- Convert timestamps into proper datetime format  
- Separate out wind speed, power, and time columns  
- Define the forecast range (144 points = 1 day)

### 2. Set Up the Rolling Window  
- Use the most recent 365 data points for each forecast step  
- This window slides forward one point at a time  
- Keeps the model trained only on past data, so forecasts stay realistic

### 3. Fit the ARIMA Model  
- At each step, fit an ARIMA(1,1,1) model on the current window  
- Use ACF and PACF plots to justify lag choices

<img width="564" height="435" alt="acf-newnew" src="https://github.com/user-attachments/assets/da5b09ab-0a22-4e87-94b7-abacfaae1b82" />
<img width="564" height="435" alt="pacf-newnew" src="https://github.com/user-attachments/assets/477d37f3-355c-425d-81d1-82a800de3b6d" />

### 4. Forecast One Step Ahead  
- After fitting, forecast just one value  
- Store that forecast and repeat the process for all 144 points (one full day)

### 5. Evaluate the Results  
- Once all 144 forecasts are done, compare them to the actual power values  
- Calculate MSE and RMSE to see how accurate the forecasts were

### 6. Plot Everything  
- Visualize the actual vs forecasted power  

<img width="2449" height="2174" alt="arima flowchart" src="https://github.com/user-attachments/assets/5c292877-c287-4fbe-b324-f67f68df44ca" />

## Challenges Adressed:

- Forecasts wind power using real historical data  
- Avoids data leakage by only training on past data at every step  
- Shows trends clearly, so it’s easier identify changes  
- Uses a rolling approach that adapts with each new forecast

## Results:

The model was evaluated on the final 144 data points (1 day of 10-minute intervals). 

| Metric | Value |
|--------|--------|
| MSE    | 0.0097|
| RMSE   |  0.0986|
| MAE    | 0.0709|
| Correlation Coefficient  |  0.8602|

The correlation is strong, and the error values are quite low. It shows that the ARIMA model handled the short-term trends in wind power pretty well.

<img width="822" height="615" alt="arimaforecast neww" src="https://github.com/user-attachments/assets/ecbf4c20-4663-40b5-aea3-5d4b4adc113f" />

## Impact:

- Supports load forecasting in renewable energy systems.
- Enables decision intelligence for utility and smart grid applications.
- Provides a foundation for real-time, adaptive forecasting pipelines.
- Demonstrates effective use of time-series filtering and modeling under real-world conditions.

## Technology & Tools:

- MATLAB for model development and visualization
- ARIMA (1,1,1) time-series model
- ACF/PACF analysis for parameter tuning
- Data Filtering and preprocessing
- Modular codebase for data versioning, retraining, and scaling

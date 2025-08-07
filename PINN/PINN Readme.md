# Wind Power Forecasting with PINNs

This project uses Physics-Informed Neural Networks (PINNs) to forecast wind power for a day ahead based on wind speed and wind turbine blade pitch data. The goal is to build a model that learns from data and it also follows the physical laws behind it.

## Key Objectives:

- Forecast wind power output using historical wind data  
- Compare actual vs forecasted power visually and numerically  
- Use PINNs to include physics directly in the learning process  
- Optimize for fast inference and strong validation performance  

## Methodology:

Instead of training a model to mimic the data, the model includes physics theory through a PINN. The model learns from wind speed and blade pitch. This results in better generalization and fewer overfitting problems.

## Model Pipeline:

**Data Source** - The wind speed and blade pitch angle at 10-minute interval data is taken NIWE. The wind power data is generated using Pow Gen.m file. 

<img width="997" height="569" alt="WS-NIWE DATA" src="https://github.com/user-attachments/assets/d6541ee2-9158-4107-aa74-427733fdc53f" />
<img width="785" height="620" alt="Power curve - newnew" src="https://github.com/user-attachments/assets/c00a57b0-e9d4-4753-be4a-55b1bec3088b" />

1. **Data Loading + Cleaning**
   - Excel-based dataset (`WS`, `pitch`, `Power`, `Time`)
   - Cleaned missing values and sorted by time
   - Timestamp engineering for better temporal structure

2. **Feature Engineering**
   - Standardized features using `StandardScaler`
   - Target variable: Wind Power output in megawatts

3. **Model Architecture**
   - TensorFlow-based PINN
   - loss combining MSE and physics residuals
   - **Input layer:** 2 neurons (wind speed and pitch)
   - **Hidden layers:** 4 fully connected layers, each with 20 neurons  
   - **Activation function:** `tanh` — captures nonlinearity and keeps gradients flowing  
   - **Output layer:** 1 neuron forecasting wind power  
   - **Loss function:** Combination of:
     - Mean Squared Error (MSE) for data fit  
     - Physics-based residual loss
   - **Optimizer:** Adam 
   - **Learning Rate:** Default (`0.001`), stable across training  

4. **Training**
   - 200 epochs using training-validation split
   - Data parallelism supported via TensorFlow backend

5. **Evaluation**
   - Forecasts compared visually against actual values
   - Loss curves monitored for overfitting detection

## Challenges Addressed:

- Cleaned irregular and noisy time series data  
- Prevented overfitting with validation tracking   
- Used descriptive analytics to smooth data and highlight patterns  
- Ensured inference optimization for practical deployments  

## Results:

- Forecasted power matches actual output closely  
- Low and stable validation loss across epochs  
- Trends and short-term fluctuations are captured well  
- Model handled peaks, dips, and irregular patterns robustly  

| Metric | Value |
|--------|--------|
| MSE    | 637.2988|
| RMSE   |  25.2448|
| MAE    | 23.9804|

<img width="846" height="391" alt="PINN- LOSS" src="https://github.com/user-attachments/assets/02dca915-d3ec-441f-b96e-2ccdf9753428" />
<img width="1005" height="545" alt="FORECAST-PINN" src="https://github.com/user-attachments/assets/7b586faa-4c96-47b8-a3b1-f61b3d5b14f6" />


## Impact:

This project blends predictive analytics with physics to improve forecast reliability. This is ideal working on decision intelligence in wind farm operations, power grid load balancing, and energy trading. It also lays the foundation for reproducibility in renewable energy models.

## Technology and Tools:

**Languages**: Python

**Libraries & Frameworks**:
- TensorFlow – model building and training (including PINN customization)
- pandas – data manipulation and filtering
- NumPy – numerical operations and array management
- Matplotlib – visualizations (loss curves, forecast plots)
- Scikit-learn – feature scaling and data splitting



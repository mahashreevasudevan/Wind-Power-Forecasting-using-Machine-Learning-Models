% Loading the datasets
%The wind data is at 10 minute interval
data = readtable('D:\Wind\Wind Data.csv');
powerCurveData = readtable('D:\Wind\power curve data.csv'); 


datetimeStrings = data.datetime; % Extracting the datetime column
windSpeed = data.ws;             % Extracting the wind speed column
actualPower = data.power;        % Extracting the actual power column

% Checking if datetimeStrings is a string array
if iscell(datetimeStrings)
    datetimeStrings = string(datetimeStrings);
end

% Converting datetime strings to datetime format
datetimeArray = datetime(datetimeStrings, 'InputFormat', 'dd-MM-yyyy HH:mm');


forecastDuration = 144; % forecasting for a day 
rollingWindowSize = 365; % Size of the rolling window in data points

% Split the data into training and testing sets
%the entire dataset except the last 144 points is considered for training 
trainSize = height(data) - forecastDuration;
trainData = actualPower(1:trainSize);
testData = actualPower(trainSize+1:end);

% Initializing forecast results
forecastedPower = zeros(forecastDuration, 1);

% Rolling Window Forecasting
%here sliding window forecast is considered 

%here the rolling window starts from the end of the dataset and moves backwards so as to avoid negative or zero start index

for t = 1:forecastDuration
    % Determine the end of the rolling window
    endIdx = trainSize + t - 1; %determines the end index of the rolling window in the data, and the t-1 Adjusts the index to match the current time step in the forecast.

%endIdx gives the index in the data that corresponds to the end of the current rolling window.
    startIdx = max(1, endIdx - rollingWindowSize + 1); % determines the start index of the data

%max() function ensures that the startindex is not less than 1     
    % Extracting the rolling window data
    rollingWindowData = actualPower(startIdx:endIdx); %extracts the data within the rolling window

%actualPower(startIdx:endIdx) this extracts the actualpower data between start index and end index    
    % Fitting the ARIMA model
%Mdl stores the model specification 
    Mdl = arima('ARLags',1,'D',1,'MALags',1); % ARIMA(1,1,1) model is used .i.e. p,q,d values are 1,1,1 respectively
    try
        EstMdl = estimate(Mdl, rollingWindowData); 
%estimate(Mdl, rollingWindowData), this fits the Mdl arima model to the rollingwindowdata
    catch 
        error('ARIMA model estimation failed for rolling window. Check your data and model specifications.');
    end
    
    % Forecast using the ARIMA model
    [forecastedPower(t), ~] = forecast(EstMdl, 1, 'Y0', rollingWindowData); 
%forecastedPower(t), this function stores the forecasted value for timestep 't'
end
% Calculate error metrics
mseValue = immse(testData, forecastedPower);
rmseValue = sqrt(mseValue);

% Display error metrics
fprintf('MSE: %.4f\n', mseValue);
fprintf('RMSE: %.4f\n', rmseValue);

% Load and process the power curve data
powerCurveWindSpeed = powerCurveData.ws; % Assuming column name is 'WindSpeed'
powerCurvePower = powerCurveData.power;         % Assuming column name is 'Power'

% Set up the figure and subplots
figure;

% Plot Wind Speed vs. DateTime
subplot(3, 1, 1);
plot(datetimeArray(trainSize+1:end), windSpeed(trainSize+1:end), 'b');
title('Wind Speed vs. DateTime');
xlabel('DateTime');
ylabel('Wind Speed (m/s)');
grid on;

% Plot Forecasted Wind Power
subplot(3, 1, 2);
plot(datetimeArray(trainSize+1:end), forecastedPower, 'r');
title('Forecasted Wind Power');
xlabel('DateTime');
ylabel('Wind Power (kW)');
grid on;

% Plot Power Curve
subplot(3, 1, 3);
plot(powerCurveWindSpeed, powerCurvePower, 'g');
title('Power Curve');
xlabel('Wind Speed (m/s)');
ylabel('Wind Power (kW)');
grid on;



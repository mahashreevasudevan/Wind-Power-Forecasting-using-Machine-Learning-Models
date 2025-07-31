%% Calling the file and loading the wind speed data
[filename, filepath] = uigetfile({'*.xls;*.xlsx', 'Excel Files (*.xls, *.xlsx)'}, 'Select Wind Speed Data File');
cd(filepath);
windData = readtable(filename);

% Display the table and its size
disp(head(windData));
disp(size(windData));

% Extract datetime and wind speed
datetimeData = windData{:, 1}; 
WSpeed = windData{:, 2};       

%% Plotting the wind speed time series
figure(1)
plot(datetimeData, WSpeed, 'b')
axis tight 
title('Time series of wind speed');
xlabel('Datetime');
ylabel('Wind Speed (m/s)');
datetick('x', 'yyyy-mm-dd HH:MM', 'keepticks')  % Formatting the x-axis to show datetime

%% Load and fit the power curve data
[wpms, wpTxt, wpWind] = xlsread('D:\Wind\DATA\kayathar_testing\normalizedpcurve.xlsx', 1);
Speed = wpms(:, 1);
power = wpms(:, 4);

% Check for negative power values in the power curve data
if min(power) < 0
    error('Power values in the power curve data contain negative values.');
end

% Fit the power curve using linear interpolation
[xData, yData] = prepareCurveData(Speed, power);
ft = 'linearinterp';
opts = fitoptions(ft);
opts.Normalize = 'on';
[fitresult, gof] = fit(xData, yData, ft, opts);

% Plot the fitted power curve
figure(2)
h1 = plot(fitresult, xData, yData);
title('Normalized Power Curve');
legend(h1, 'Power vs. Wind Speed', 'Normalized Power Curve', 'Location', 'NorthEast');
xlabel('Wind Speed (m/s)');
ylabel('Power (kW)');

%% Calculate the power output using the fitted power curve
PWR = feval(fitresult, WSpeed);

% Ensure all power values are non-negative
PWR(PWR < 0) = 0;

%% Plot the generated power time series
figure(3)
plot(datetimeData, PWR, 'm')
axis tight 
title('Time series of Estimated Power (kW)');
xlabel('Datetime');
ylabel('Power (kW)');
datetick('x', 'yyyy-mm-dd HH:MM', 'keepticks')  % Format the x-axis to show datetime

%% Save the results to an Excel file
Headers = {'Datetime', 'Wind Speed (m/s)', 'Estimated Power (kW)'};
covtime = cellstr(datestr(datetimeData, 'yyyy-mm-dd HH:MM:SS'));
outputData = horzcat(covtime, num2cell(WSpeed), num2cell(PWR));
xlswrite('Power gen _no pitch.xls', outputData, 1, 'A2');
xlswrite('Power gen _no pitch.xls', Headers, 1, 'A1');

clear all;
close all;
clc;

%% calling the file
% Loading the Data_file
[filename, filepath] = uigetfile({'*.*', 'All Files'}, 'Select Data File 1');
cd(filepath);
[Nos, ~, ~] = xlsread(filename, 1);

% Time processing
time_duration = seconds(Nos(:, 1));
time_datetime = datetime('12:00:00') + time_duration;
formatted_time = datestr(time_datetime, 'HH:MM:SS.FFF');

%% Data vectors
time=Nos(:,1);
WSpeed=Nos(:,2);
WSpeedref=Nos(:,3);
pitchangle=Nos(:,4);
genspeed=Nos(:,5);
rpmcount=Nos(:,6);
activePowerkW = Nos(:,7);
reactivePower = Nos(:,8).*1000;
reactivePowerkW = Nos(:,8);
freq=Nos(:,9);

%%
figure(1)
plot(time,Nos(:,2),'b')
axis tight 
title('Time series of wind profile ');
datetick('x','mm','keepticks')
xlabel('Month');
ylabel('Wind Speed m/s');

%% Wind Generation in kW
figure (2)
[wpms, wpTxt, wpWind] = xlsread('normalizedpcurve',3);
Speed = wpms(:,1);
power = wpms(:,2);
[xData, yData] = prepareCurveData( Speed, power );

% Set up fittype and options.
ft = 'linearinterp';
opts = fitoptions( ft );
opts.Normalize = 'on';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
%figure( 'Name', 'Normalized 200kW Powercurve' );
h1 = plot( fitresult, xData, yData );
title('Normalized Power Curve');
legend( h1, 'Power vs. Wind Speed', 'Normalized Power curve', 'Location', 'NorthEast' );
% Label axes
xlabel( 'Wind Speed m/s' );
ylabel( 'Power (kW)' );
 xi=get(h1,'xData');
yi=get(h1,'yData');

%% Energy Pattern Factor
WS = Nos(:,2);
N = length(WS);
EPF = zeros(1,1);
 k = zeros(1,1);
 lamda = zeros(1,1);
F = zeros(N,1);
for i =1
wcubemean = nanmean((WS(:,i)).^3);
wmeancube = ((nanmean(WS(:,i))).^3);
EPF(:,i) = (wcubemean/wmeancube);
% %% Calculation of Shape parameter
 k(:,i) =(1+ (3.69/((EPF(:,i)).^2)));
% %% Calculation of Scaling parameter
 lamda(:,i)= ((nanmean(WS(:,i)))/(gamma(1+(1/k(:,i)))));
end
Energy_Pattern_Factor = round(EPF*100)/100;

%% Wind speed distribution
% di=HWS(:,1);
di=WS(:,1);
handles.current1_data=di;
 dWS = 0.02;
% binCtrs = 0:dWS:ceil(max(handles.current1_data));
binCtrs = xi{2,1};
powervbins1 =yi{2,1};
hist(handles.current1_data,binCtrs);
counts = hist(handles.current1_data,binCtrs);
n = length(handles.current1_data);
prob = counts / (n * dWS);
bar(binCtrs,prob,'hist');
h = get(gca,'child');
% set(h,'FaceColor','r');
title(' Wind Speed Distribution');
xlabel('Wind Speed'); ylabel('Probability Density'); 
xgrid = linspace(1.1*min(handles.current1_data),1.1*max(handles.current1_data),length(handles.current1_data));
 pdfEst = wblpdf(xgrid,lamda(1,1),k(1,1));
line(xgrid,pdfEst,'Color','r');
axis tight

%%
nn =1;
vbins1 = binCtrs;
figure(3)
plot(vbins1, powervbins1, '*')
PW = horzcat(vbins1',(powervbins1'.*nn));
xlabel('velocity (m/s)');
ylabel('turbine power (W)');
title('Turbine Power Curve')

%%
[bincounts,ind] = histc(di,vbins1);
N = length(ind);
for t = 1:N
    if ind(t)==0
        PWR(t) = 0;
    else 
        PWR(t) = PW(ind(t),2);
    end
end 
PWRkwh=(PWR./6);

%% File generation
Headers = {'Hour','Wind Speed (m/s)','Generated Power (MW)'}; 
covtime = cellstr(datestr(time,'yyyy-mm-dd HH:MM:SS'));
generation= horzcat(di,PWR');
xlswrite('Generated Power.xls',generation,1,'B2');
xlswrite('Generated Power.xls',covtime,1,'A2');
xlswrite('Generated Power.xls',Headers,1,'A1');

%%
figure
subplot(3,1,1)9
plot(time,Nos(:,2),'b')
axis tight 
title('Time series of wind profile ');
datetick('x','mm','keepticks')
xlabel('Month');
ylabel('Wind Speed m/s');
subplot(3,1,2)
plot(time,PWR','m')

axis tight 
title('Time series of Estimated power (kW) ');
datetick('x','mm','keepticks')
xlabel('Month');
ylabel('kW');
subplot(3,1,3)
plot(time,activePowerkW,'m')
axis tight 
title('Time series of Generated power');
datetick('x','mm','keepticks')
xlabel('Month');
ylabel('kW');
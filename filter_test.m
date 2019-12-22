clear all;
close all;
plotEnable = false;

%% Rain gauge

rainAugust = (load('RainGauge/UCL_rain_rate_20190801-20190831.mat'));
rainAugust = rainAugust.rr;
rainJuly = load('RainGauge/UCL_rain_rate_20190701-20190731.mat');
rainJuly = rainJuly.rr;
rainJune = load('RainGauge/UCL_rain_rate_20190601-20190630.mat');
rainJune = rainJune.rr;
rainMay = load('RainGauge/UCL_rain_rate_20190501-20190531.mat');
rainMay = rainMay.rr;

%% WIND - Q band - 10 août 2019

day3 = load('L1_co/Wind/2019-08-10/Alphasat_Q_LLN_L1_co_20190811.mat');
day2 = load('L1_co/Wind/2019-08-10/Alphasat_Q_LLN_L1_co_20190810.mat');
day1 = load('L1_co/Wind/2019-08-10/Alphasat_Q_LLN_L1_co_20190809.mat');

time = day1.dtime;
time = time-time(1);
time = hours(time);

ind_period = find((datetime(day1.dtime.Year(1), day1.dtime.Month(1), day1.dtime.Day(1))<= rainAugust.time) &  (datetime(day3.dtime.Year(1), day3.dtime.Month(1), day3.dtime.Day(1)+1)) > rainAugust.time);
t_period = rainAugust.time(ind_period);
t_hours = hours(t_period - t_period(1));

rainLLN = rainAugust.lln(ind_period);
rainPerwez = rainAugust.perwez(ind_period);
rainBousval = rainAugust.bousval(ind_period);
rainWavre = rainAugust.wavre(ind_period);


lvlday1 = day1.level;
lvlday2 = day2.level;
lvlday3 = day3.level;

%% BRX template

band = 'Q'; % <-- CHANGE BAND HERE
day_process = datetime(2019, 8, 10); % <-- CHANGE DAY HERE
events_file_path = 'lln_EF_20190809.txt';
brx_data_dir_path = 'C:\Users\Arthur\Documents\University\MA1_Q1\LELEC2910\Propagation_project\Antennas_2\L1_co\Wind\2019-08-10';
  
[dtime, brx_level, brx_template, events] = processing.create_brx_template(day_process, band, events_file_path, brx_data_dir_path,1,1,true);                
excess_attenuation = brx_template - brx_level;
%% Filter design

d1 = designfilt('bandstopfir','FilterOrder',100, ...
         'CutoffFrequency1',2.75,'CutoffFrequency2',3.1, ...
         'SampleRate',10,'StopbandAttenuation',65);
filtered_att = filtfilt(d1,excess_attenuation);

%% PSD
close all;
segment_length_in_minutes = 10; % [min]
sampling_rate = 10; % [Hz]


t_0 = datetime(2019, 8, 10, 17, 0, 0);
t_end = datetime(2019, 8, 10, 18, 0, 0);
ind_block = (t_0 <= dtime) & (dtime <= t_end);
signal_block = filtered_att(ind_block);
% signal_block = excess_attenuation(ind_block);
[PSD, f_PSD] = processing.extract_signal_psd(signal_block, segment_length_in_minutes, sampling_rate);

figure;
loglog(f_PSD, PSD);
grid minor;
xlabel('Frequency [Hz]')
ylabel('Power Spectral Density [dB^2/Hz]')
title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));
%%

x = f_PSD(1387:4097);
y = PSD(1387:4097);

x = log10(x./x(1));
y = 10*log10(y);

p = polyfit(x,y,1);

slope = (10*(PSD(1387))).*f_PSD(1387:4097).^(p(1)/10);
loglog(f_PSD(1387:4097),slope);

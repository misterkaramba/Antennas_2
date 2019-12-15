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

band = 'Ka'; % <-- CHANGE BAND HERE
day_process = datetime(2019, 8, 10); % <-- CHANGE DAY HERE
events_file_path = 'lln_EF_20190809.txt';
brx_data_dir_path = 'C:\Users\Arthur\Documents\University\MA1_Q1\LELEC2910\Propagation_project\Antennas_2\L1_co\Wind\2019-08-10';
  
[dtime, brx_level, brx_template, events] = processing.create_brx_template(day_process, band, events_file_path, brx_data_dir_path,1,1,true);                
excess_attenuation = brx_template - brx_level;

%% Spectral analysis
segment_length_in_minutes = 10; % [min]
sampling_rate = 10; % [Hz]


t_0 = datetime(2019, 8, 9, 0, 0, 0);
t_end = datetime(2019, 8, 11, 23, 0, 0);
ind_block = (t_0 <= dtime) & (dtime <= t_end);
signal_block = excess_attenuation(ind_block);
[PSD, f_PSD] = processing.extract_signal_psd(signal_block, segment_length_in_minutes, sampling_rate);

% figure;
% plot(dtime(ind_block), signal_block);
% grid minor;
% xlabel('Time')
% ylabel('Signal level ["dB"]');
% xtickformat('dd-HH:mm')
% title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));

figure;
loglog(f_PSD, PSD);
grid minor;
xlabel('Frequency [Hz]')
ylabel('Power Spectral Density [dB^2/Hz]')
title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));

%% ERA5 - correlation between speed and spectral density
ERA = load('ERA5\ERA5_Surface_LLN_20190801-20190831.mat');
speed_north = ERA.v10;
speed_east = ERA.u10;
time_measured = ERA.dtime; %measurements are made every one hour;

PSD_table_9 = zeros(71,1); 

for i=0:70
    t_0 = datetime(2019, 8, 9, i, 0, 0);
    t_end = datetime(2019, 8, 9, i+1, 0, 0);
    ind_block = (t_0 <= dtime) & (dtime <= t_end);
    signal_block = excess_attenuation(ind_block);
    [PSD, f_PSD] = processing.extract_signal_psd(signal_block, segment_length_in_minutes, sampling_rate);
    
%     figure;
%     loglog(f_PSD, PSD);
%     grid minor;
%     xlabel('Frequency [Hz]')
%     ylabel('Power Spectral Density [dB^2/Hz]')
%     title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));
    
    mean = sum(PSD)/length(PSD);
    
    index = 2385:2475; % location of the peak -> 2.9 ~3.02 Hz
    PSD_table_9(i+1) = sum(PSD(index))/(length(index)*mean); %2.9956Hz
    
end

ind_period_measurement = find((datetime(2019, 8, 9, 0, 0, 0)<= time_measured) &  (datetime(2019, 8, 11, 23, 0, 0) > time_measured));
wind_speed_north = speed_north(ind_period_measurement);
wind_speed_east = speed_east(ind_period_measurement);

R = corrcoef([PSD_table_9 abs(wind_speed_north) abs(wind_speed_east)]) 

%% Plots

if(plotEnable)
%     figure();
%     plot(time,lvlday1);
%     title('day1');
% 
%     figure();
%     plot(time,lvlday2);
%     title('day2');
% 
%     figure();
%     plot(time,lvlday3);
%     title('day3');
%     
%     figure();
%     plot(t_hours,rainLLN);
%     title('rain lln');
%     
%     figure();
%     plot(t_hours,rainPerwez);
%     title('rain perwez');
%     
%     figure();
%     plot(t_hours,rainBousval);
%     title('rain bousval');
%     
%     figure();
%     plot(t_hours,rainWavre);
%     title('rain wavre');
    
    figure;
    subplot(2, 1, 1)
    plot(dtime, brx_level); hold on;
    plot(dtime, brx_template);
    xtickformat('dd-HH')
    xlabel('Time [hours]');
    ylabel('Signal level ["dB"]');
    grid minor;
    legend('Signal', 'Template', 'location', 'best')
    title(sprintf('Alphasat %s band - LLN - %s', band, datestr(day_process, 'yyyy-mm-dd')));
    subplot(2, 1, 2)
    plot(dtime, excess_attenuation); hold on;
    plot(dtime, events*max(excess_attenuation)/2);
    xtickformat('dd-HH')
    xlabel('Time [hours]');
    ylabel('Attenuation [dB]');
    grid minor;
    legend('Excess', 'Events', 'location', 'best')

    
end






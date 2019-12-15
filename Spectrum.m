close all;
clear all;

%% Parameters

band = 'Ka'; % <-- CHANGE BAND HERE
segment_length_in_minutes = 10; % [min]
sampling_rate = 10; % [Hz]
plotEnable = true;

%% Test day with low clear-sky 
% brx = load(['C:\Users\Arthur\Documents\University\MA1_Q1\LELEC2910\Propagation_project\Antennas_2\L1_co\Scintillation\2019-05-27\' ['Alphasat_' band '_LLN_L1_co_20190528.mat']]);

globalPsd = 0;

% Clear-sky averaging -> pente -80/3 db/dec // cut off = 0.04Hz
for i=0:9
    t_0 = datetime(2019, 5, 28, i, 0, 0);
    t_end = datetime(2019, 5, 28, i+1, 0, 0);
    ind_block = (t_0 <= brx.dtime) & (brx.dtime <= t_end);
    signal_block = brx.level(ind_block);
    [PSD, f_PSD] = processing.extract_signal_psd(signal_block, segment_length_in_minutes, sampling_rate);
    globalPsd = globalPsd + PSD/10;
end

if plotEnable
    figure;
    plot(brx.dtime(ind_block), signal_block);
    grid minor;
    xlabel('Time')
    ylabel('Signal level ["dB"]');
    xtickformat('dd-HH:mm')
    title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));

    figure;
    loglog(f_PSD, globalPsd);
    grid minor;
    xlabel('Frequency [Hz]')
    ylabel('Power Spectral Density [dB^2/Hz]')
    title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));
end

%% Test day with low clear-sky 
brx = load(['C:\Users\Arthur\Documents\University\MA1_Q1\LELEC2910\Propagation_project\Antennas_2\L1_co\Scintillation\2019-05-27\' ['Alphasat_' band '_LLN_L1_co_20190528.mat']]);

globalPsd = 0;

% Clear-sky averaging -> pente -80/3 db/dec // cut off = 0.04Hz
for i=0:9
    t_0 = datetime(2019, 5, 28, i, 0, 0);
    t_end = datetime(2019, 5, 28, i+1, 0, 0);
    ind_block = (t_0 <= brx.dtime) & (brx.dtime <= t_end);
    signal_block = brx.level(ind_block);
    [PSD, f_PSD] = processing.extract_signal_psd(signal_block, segment_length_in_minutes, sampling_rate);
    globalPsd = globalPsd + PSD/10;
end

if plotEnable
    figure;
    plot(brx.dtime(ind_block), signal_block);
    grid minor;
    xlabel('Time')
    ylabel('Signal level ["dB"]');
    xtickformat('dd-HH:mm')
    title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));

    figure;
    loglog(f_PSD, globalPsd);
    grid minor;
    xlabel('Frequency [Hz]')
    ylabel('Power Spectral Density [dB^2/Hz]')
    title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));
end
% A test script to obtain the PSD from the brx data
band = 'Ka'; % <-- CHANGE BAND HERE
segment_length_in_minutes = 10; % [min]
sampling_rate = 10; % [Hz]

%% Test day with low clear-sky scintillation and rain
brx = load(['Alphasat_' band '_LLN_L1_co_20190528.mat']);

% Clear-sky
t_0 = datetime(2019, 5, 28, 0, 0, 0);
t_end = datetime(2019, 5, 28, 1, 0, 0);
ind_block = (t_0 <= brx.dtime) & (brx.dtime <= t_end);
signal_block = brx.level(ind_block);
[PSD, f_PSD] = processing.extract_signal_psd(signal_block, segment_length_in_minutes, sampling_rate);

figure;
plot(brx.dtime(ind_block), signal_block);
grid minor;
xlabel('Time')
ylabel('Signal level ["dB"]');
xtickformat('dd-HH:mm')
title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));

figure;
loglog(f_PSD, PSD);
grid minor;
xlabel('Frequency [Hz]')
ylabel('Power Spectral Density [dB^2/Hz]')
title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));

% Rain
t_0 = datetime(2019, 5, 28, 14, 0, 0);
t_end = datetime(2019, 5, 28, 15, 0, 0);
ind_block = (t_0 <= brx.dtime) & (brx.dtime <= t_end);
signal_block = brx.level(ind_block);
[PSD, f_PSD] = processing.extract_signal_psd(signal_block, segment_length_in_minutes, sampling_rate);

figure;
plot(brx.dtime(ind_block), signal_block);
grid minor;
xlabel('Time')
ylabel('Signal level ["dB"]');
xtickformat('dd-HH:mm')
title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));

figure;
loglog(f_PSD, PSD);
grid minor;
xlabel('Frequency [Hz]')
ylabel('Power Spectral Density [dB^2/Hz]')
title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));

%% Test day with wind induced antenna vibrations
brx = load(['Alphasat_' band '_LLN_L1_co_20190608.mat']);


t_0 = datetime(2019, 6, 8, 2, 0, 0);
t_end = datetime(2019, 6, 8, 3, 0, 0);
ind_block = (t_0 <= brx.dtime) & (brx.dtime <= t_end);
signal_block = brx.level(ind_block);
[PSD, f_PSD] = processing.extract_signal_psd(signal_block, segment_length_in_minutes, sampling_rate);

figure;
plot(brx.dtime(ind_block), signal_block);
grid minor;
xlabel('Time')
ylabel('Signal level ["dB"]');
xtickformat('dd-HH:mm')
title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));

figure;
loglog(f_PSD, PSD);
grid minor;
xlabel('Frequency [Hz]')
ylabel('Power Spectral Density [dB^2/Hz]')
title(sprintf('Alphasat %s LLN %s to %s', band, datestr(t_0, 'yyyy-mm-dd HH:MM:SS'), datestr(t_end, 'yyyy-mm-dd HH:MM:SS')));
% A test script to obtain the template and excess attenuation from the brx data
band = 'Ka'; % <-- CHANGE BAND HERE
day_process = datetime(2019, 5, 28); % <-- CHANGE DAY HERE
events_file_path = 'lln_EF_201905.txt';
                
%% Test default suggested behavior (with filter)
[dtime, brx_level, brx_template, events] = processing.create_brx_template(day_process, band, events_file_path, []);                
excess_attenuation = brx_template - brx_level;

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

%% Test default behavior (without filter)
[dtime, brx_level, brx_template, events] = processing.create_brx_template(day_process, band, events_file_path, [], 2, 2, false);                
excess_attenuation = brx_template - brx_level;

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
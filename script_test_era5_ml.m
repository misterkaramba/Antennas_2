% A test script to plot the model levels ERA5 parameters for individual profiles
era5_ml = load('ERA5/ERA5_ModLev_LLN_20190501-20190531.mat');

ind_t = find(era5_ml.dtime == datetime(2019, 5, 18, 15, 0, 0));

figure;
plot(era5_ml.T(:, ind_t), era5_ml.z(:, ind_t)/1e3);
xlabel('Temperature [K]');
ylabel('Altitude [km]');
ylim([0 20]);
grid minor;
title(sprintf('ERA5 - LLN - %s', datestr(era5_ml.dtime(ind_t), 'yyyy-mm-dd HH:MM')));

figure;
plot(era5_ml.q(:, ind_t)*1e3, era5_ml.z(:, ind_t)/1e3);
xlabel('Specific humidity [g/kg]');
ylabel('Altitude [km]');
ylim([0 20]);
grid minor;
title(sprintf('ERA5 - LLN - %s', datestr(era5_ml.dtime(ind_t), 'yyyy-mm-dd HH:MM')));

figure;
plot(era5_ml.q_cloud(:, ind_t)*1e3, era5_ml.z(:, ind_t)/1e3);
xlabel('Specific cloud water content [g/kg]');
ylabel('Altitude [km]');
ylim([0 20]);
grid minor;
title(sprintf('ERA5 - LLN - %s', datestr(era5_ml.dtime(ind_t), 'yyyy-mm-dd HH:MM')));

figure;
plot(era5_ml.q_rain(:, ind_t)*1e3, era5_ml.z(:, ind_t)/1e3);
xlabel('Specific rain water content [g/kg]');
ylabel('Altitude [km]');
ylim([0 20]);
grid minor;
title(sprintf('ERA5 - LLN - %s', datestr(era5_ml.dtime(ind_t), 'yyyy-mm-dd HH:MM')));

wind = sqrt(era5_ml.u.^2 + era5_ml.v.^2);
figure;
plot(wind(:, ind_t), era5_ml.z(:, ind_t)/1e3);
xlabel('Wind speed [m/s]');
ylabel('Altitude [km]');
ylim([0 20]);
grid minor;
title(sprintf('ERA5 - LLN - %s', datestr(era5_ml.dtime(ind_t), 'yyyy-mm-dd HH:MM')));
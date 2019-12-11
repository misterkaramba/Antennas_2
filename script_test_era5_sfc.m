% A test script to plot the surface levels ERA5 parameters over one month
era5_sfc = load('ERA5/ERA5_Surface_LLN_20190501-20190531.mat');

figure;
plot(era5_sfc.dtime, era5_sfc.sp/1e2); 
xlabel('Time')
ylabel('Surface pressure [hPa]');
grid minor;
axis tight;
xtickformat('dd-HH');
title('ERA5 - LLN');

figure;
plot(era5_sfc.dtime, era5_sfc.t2m - 273.15); 
xlabel('Time')
ylabel('2 m temperature [°C]');
grid minor;
axis tight;
xtickformat('dd-HH');
title('ERA5 - LLN');

figure;
plot(era5_sfc.dtime, era5_sfc.RH2m); 
xlabel('Time')
ylabel('Relative humidity [%]');
grid minor;
axis tight;
xtickformat('dd-HH');
title('ERA5 - LLN');

wind_10 = sqrt(era5_sfc.u10.^2 + era5_sfc.v10.^2); % [m/s]
figure;
plot(era5_sfc.dtime, wind_10); 
xlabel('Time')
ylabel('Wind speed [m/s]');
grid minor;
axis tight;
xtickformat('dd-HH');
title('ERA5 - LLN');

figure;
plot(era5_sfc.dtime, era5_sfc.deg0l/1e3); 
xlabel('Time')
ylabel('Zero degree isotherm alitude [km]');
grid minor;
axis tight;
xtickformat('dd-HH');
title('ERA5 - LLN');

rr = era5_sfc.lsrr + era5_sfc.crr; % [mm/s]
figure;
plot(era5_sfc.dtime, rr*3600);
xlabel('Time')
ylabel('Rainfall rate [mm/h]');
grid minor;
axis tight;
xtickformat('dd-HH');
title('ERA5 - LLN');

figure;
plot(era5_sfc.dtime, era5_sfc.tcwv);
xlabel('Time')
ylabel('Integrated water vapor content [mm]');
grid minor;
axis tight;
xtickformat('dd-HH');
title('ERA5 - LLN');

figure;
plot(era5_sfc.dtime, era5_sfc.tclw);
xlabel('Time')
ylabel('Integrated liquid water content [mm]');
grid minor;
axis tight;
xtickformat('dd-HH');
title('ERA5 - LLN');

figure;
plot(era5_sfc.dtime, era5_sfc.cbh/1e3);
xlabel('Time')
ylabel('Cloud base altitude [km]');
grid minor;
axis tight;
xtickformat('dd-HH');
title('ERA5 - LLN');

figure;
plot(era5_sfc.dtime, era5_sfc.blh/1e3);
xlabel('Time')
ylabel('Boundary layer altitude [km]');
grid minor;
axis tight;
xtickformat('dd-HH');
title('ERA5 - LLN');
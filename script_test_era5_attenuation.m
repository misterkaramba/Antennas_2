% A test script to obtain the attenuation components from ERA5 data
era5_ml = load('ERA5/ERA5_ModLev_LLN_20190501-20190531.mat');
era5_sfc = load('ERA5/ERA5_Surface_LLN_20190501-20190531.mat');

%%  Alphasat link properties at Louvain-la-Neuve
band = 'Ka'; % <-- CHANGE BAND HERE

if strcmp(band, 'Ka')
    f = 19.701; % [GHz]
    polarization = 90; % [degree]
elseif strcmp(band, 'Q')
    f = 39.402; % [GHz]
    polarization = 45; % [degree]
else
    error('Band not supported.')
end
elevation = 28.9; % [degree]

%% Gaseous specific attenuation
p_vap = thermodynamics.water_vapour_pressure(era5_ml.p, era5_ml.q);
[gamma_ox, gamma_wv] = itur.p676_12.specific_attenuation_gases(f, era5_ml.T, era5_ml.p/1e2, p_vap/1e2);

%% Cloud specific attenation
% N.B.: The suitability of ERA5 cloud content for this operation is open to discussion.
rho_air = thermodynamics.dry_air_density(era5_ml.p, era5_ml.T); % [kg/m^3]
M_cloud =  era5_ml.q_cloud.*rho_air*1e3; % [g/m^3]
gamma_cloud = itur.p840_8.specific_attenuation_cloud(f, era5_ml.T, M_cloud);

%% Rain specific attenuation
% N.B.: The suitability of ERA5 rain rate for this operation is open to discussion.
%(Local rain rate measurements should be preferred.)
R_rain = (era5_sfc.lsrr + era5_sfc.crr)*3600; % [mm/h]
R_rain = repmat(R_rain', [137 1]); % Repeat the ground rain rate vertically
deg0l = repmat(era5_sfc.deg0l', [137 1]);
R_rain(era5_ml.z >= deg0l) = 0; % Rain_rate is 0 above "rain height" (assumed to be the 0°C isotherm)
R_rain(R_rain < 0) = 0;
gamma_rain = itur.p838_3.specific_attenuation_rain(f, R_rain, elevation, polarization);

%% Integration of specific attenuation into rain attenuation
num_t = size(era5_ml.z, 2);
A_ox = zeros(num_t, 1);
A_wv = zeros(num_t, 1);
A_cloud = zeros(num_t, 1);
A_rain = zeros(num_t, 1);
for ind_t = 1:num_t
    A_ox(ind_t) = trapz(era5_ml.z(:, ind_t)/1e3, gamma_ox(:, ind_t));
    A_wv(ind_t) = trapz(era5_ml.z(:, ind_t)/1e3, gamma_wv(:, ind_t));
    A_cloud(ind_t) = trapz(era5_ml.z(:, ind_t)/1e3, gamma_cloud(:, ind_t));
    A_rain(ind_t) = trapz(era5_ml.z(:, ind_t)/1e3, gamma_rain(:, ind_t));
end

% Cosecant scaling of zenith attenuations
A_ox = A_ox/sind(elevation);
A_wv = A_wv/sind(elevation);
A_cloud = A_cloud/sind(elevation);
A_rain = A_rain/sind(elevation);

figure;
plot(era5_ml.dtime, A_ox); hold on;
plot(era5_ml.dtime, A_wv);
axis tight;
xtickformat('dd-HH')
xlabel('Time');
ylabel('Gaseous attenuation [dB]');
legend('Oxygen', 'Water vapour');
grid minor;
title(sprintf('Alphasat %s - LLN', band));

figure;
plot(era5_ml.dtime, A_cloud);
axis tight;
xtickformat('dd-HH')
xlabel('Time');
ylabel('Cloud attenuation [dB]');
grid minor;
title(sprintf('Alphasat %s - LLN', band));

figure;
plot(era5_ml.dtime, A_rain);
xtickformat('dd-HH')
axis tight;
xtickformat('dd-HH')
xlabel('Time');
ylabel('Rain attenuation [dB]');
grid minor;
title(sprintf('Alphasat %s - LLN', band));
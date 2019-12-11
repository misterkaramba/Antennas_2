clear all;
close all;

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
plotEnable = true;

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

%% Plots

if(plotEnable)
    figure();
    plot(time,lvlday1);
    title('day1');

    figure();
    plot(time,lvlday2);
    title('day2');

    figure();
    plot(time,lvlday3);
    title('day3');
    
    figure();
    plot(t_hours,rainLLN);
    title('rain lln');
    
    figure();
    plot(t_hours,rainPerwez);
    title('rain perwez');
    
    figure();
    plot(t_hours,rainBousval);
    title('rain bousval');
    
    figure();
    plot(t_hours,rainWavre);
    title('rain wavre');
    
end






% Vinay Ramakrishnaiah
% all sub-urban area
% n = 36 antennas
% Threshold  = -85 dBW
% distance = 1 km
clear 
close all

%% Plot the percentage of angles above a certain threashold
Pt = [0,1,2,3,4,5,6,7,8,9,10,11];
PT = [0,0.7391,1.4783,2.2174,2.9565,3.6956,4.4348,5.1739,5.9130,6.6521,7.3913,8.1304,8.8695,9.6087,10.34578,11.0869];
% Percentage above
WOVTL = [0,6.0417,15.4861,21.0417,24.9306,27.9861,30.4861,36.3889,43.6111,...
    50.2778,56.1111,61.6667];
WVTL_CVX = [0,0,0.4167,1.25,1.9444,2.5,2.9861,3.9583,16.25,80.2778,92.8472,...
    95.1389,97.8472,98.6806,98.9583,99.3750];
WVTL_NM = [0,0,0.9722,3.1944,5.4167,8.9583,11.5972,16.0417,29.5628,70.5556,...
    81.6667,86.1806];
% Plot the values
figure
hold all
plot(Pt,WOVTL,'-o')
plot(Pt,WVTL_NM,'-^')
plot(PT,WVTL_CVX,'-x')
hold off
legend('Without VTL','With VTL - NM','With VTL - CVX')
xlabel('Total power (W)')
ylabel('Percentage of angles above -95 dBW')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
set(findall(gca, 'Type', 'Text'),'FontSize',32);
set(findall(gca, 'Type', 'Axes'),'FontSize',32);
set(findall(gcf, 'Type', 'Legend'),'FontSize',32);

%% Plot the gains
load Gain;
load Gain_NM;
load Gain_CVX;
deltheta = 0 : pi/720 : 2*pi-pi/720; % Look angles
figure
hold all
plot(deltheta, 10*log10(Gain));
plot(deltheta, 10*log10(Gain_NM));
plot(deltheta, 10*log10(Gain_CVX));
hold off
ylim([-20,20])
legend('ideal gain','NM optimized gain','CVX optimized gain')
xlabel('look angle (radians)')
ylabel('Gain (dB)')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
set(findall(gca, 'Type', 'Text'),'FontSize',32);
set(findall(gca, 'Type', 'Axes'),'FontSize',32);
set(findall(gcf, 'Type', 'Legend'),'FontSize',32);

%% Plot the received power
load Pr;
load Pr_NM;
load Pr_CVX;
figure
hold all
plot(deltheta, 10*log10(Pr))
plot(deltheta, 10*log10(Pr_NM))
plot(deltheta, 10*log10(Pr_CVX))
hold off
ylim([-110,-80])
legend('Omni received power','NM array received power','CVX array received power')
xlabel('look angle (radians)')
ylabel('Received power (dBW)')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
set(findall(gca, 'Type', 'Text'),'FontSize',32);
set(findall(gca, 'Type', 'Axes'),'FontSize',32);
set(findall(gcf, 'Type', 'Legend'),'FontSize',32);

%% Plot the variation with distance
dist = 1000:25:1300;
figure
hold all
load perWOVTL;
plot(dist,perWOVTL(1:length(dist)));
load perWVTL_CVX_dist;
plot(dist,perWVTL_CVX_dist(1:length(dist)));
load perWVTL_NM_dist;
plot(dist,perWVTL_NM_dist(1:length(dist)));
hold off
legend('Without VTL','With VTL - CVX','With VTL - NM')
xlabel('distance from the transmitter (m)')
ylabel('Percentage of angles above -95 dBW')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
set(findall(gca, 'Type', 'Text'),'FontSize',32);
set(findall(gca, 'Type', 'Axes'),'FontSize',32);
set(findall(gcf, 'Type', 'Legend'),'FontSize',32);

%% different terrains
load Pr_CVX_terrain_act;
load Pr_CVX_terrain;
load Pr_NM_terrain;
load Pr_terrain;
load Pr_ideal;
figure
hold all
plot(deltheta, 10*log10(Pr_ideal))
plot(deltheta, 10*log10(Pr_terrain))
% plot(deltheta, 10*log10(Pr_NM_terrain))
plot(deltheta, 10*log10(Pr_CVX_terrain))
plot(deltheta, 10*log10(Pr_CVX_terrain_act))
hold off
legend('Ideal','Omni','CVX with attenuators','CVX with amplifiers')
xlabel('look angle (radians)')
ylabel('Received power (dBW)')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
set(findall(gca, 'Type', 'Text'),'FontSize',32);
set(findall(gca, 'Type', 'Axes'),'FontSize',32);
set(findall(gcf, 'Type', 'Legend'),'FontSize',32);

%% Different array geometries
load Gest_CVX_cir;
load Gest_CVX_sq;
load Gest_CVX_lin;
load Gest_NM_cir;
load Gest_NM_sq;
load Gest_NM_lin;
figure
hold all
plot(deltheta, 10*log10(Gain),'-*');
plot(deltheta, 10*log10(Gest_CVX_cir),'-');
plot(deltheta, 10*log10(Gest_CVX_sq),'-');
plot(deltheta, 10*log10(Gest_CVX_lin),'-');
hold off
ylim([-15,20])
legend('ideal gain','CVX circular','CVX square','CVX linear')
xlabel('look angle (radians)')
ylabel('Gain (dB)')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
set(findall(gca, 'Type', 'Text'),'FontSize',32);
set(findall(gca, 'Type', 'Axes'),'FontSize',32);
set(findall(gcf, 'Type', 'Legend'),'FontSize',32);
figure
hold all
plot(deltheta, 10*log10(Gain),'-*');
plot(deltheta, 10*log10(Gest_NM_cir),'-');
plot(deltheta, 10*log10(Gest_NM_sq),'-');
plot(deltheta, 10*log10(Gest_NM_lin),'-');
hold off
ylim([-15,20])
legend('ideal gain','NM circular','NM square','NM linear')
xlabel('look angle (radians)')
ylabel('Gain (dB)')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
set(findall(gca, 'Type', 'Text'),'FontSize',32);
set(findall(gca, 'Type', 'Axes'),'FontSize',32);
set(findall(gcf, 'Type', 'Legend'),'FontSize',32);

%% Varying number of antenna elements
load Gest_CVX_cir4;
load Gest_CVX_cir16;
load Gest_CVX_cir36;
load Gest_NM_cir4;
load Gest_NM_cir16;
load Gest_NM_cir36;
figure
hold all
plot(deltheta, 10*log10(Gain),'-*');
plot(deltheta, 10*log10(Gest_CVX_cir4),'-');
plot(deltheta, 10*log10(Gest_CVX_cir16),'-');
plot(deltheta, 10*log10(Gest_CVX_cir36),'-');
hold off
ylim([-20,20])
legend('ideal gain','CVXcir4','CVXcir16','CVXcir36')
xlabel('look angle (radians)')
ylabel('Gain (dB)')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
set(findall(gca, 'Type', 'Text'),'FontSize',32);
set(findall(gca, 'Type', 'Axes'),'FontSize',32);
set(findall(gcf, 'Type', 'Legend'),'FontSize',32);
figure
hold all
plot(deltheta, 10*log10(Gain),'-*');
plot(deltheta, 10*log10(Gest_NM_cir4),'-');
plot(deltheta, 10*log10(Gest_NM_cir16),'-');
plot(deltheta, 10*log10(Gest_NM_cir36),'-');
hold off
ylim([-20,20])
legend('ideal gain','NMcir4','NMcir16','NMcir36')
xlabel('look angle (radians)')
ylabel('Gain (dB)')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
set(findall(gca, 'Type', 'Text'),'FontSize',32);
set(findall(gca, 'Type', 'Axes'),'FontSize',32);
set(findall(gcf, 'Type', 'Legend'),'FontSize',32);

%% Increasing the amplifier gain
load Gest_CVX_1;
load Gest_CVX_2;
load Gest_CVX_3
figure
hold all
plot(deltheta, 10*log10(Gain));
plot(deltheta, 10*log10(Gest_CVX_1),'-.');
plot(deltheta, 10*log10(Gest_CVX_2),'-.');
plot(deltheta, 10*log10(Gest_CVX_3),'-.');
hold off
legend('ideal gain','CVX |w|<=1','CVX |w|<=2','CVX |w|<=3')
xlabel('look angle (radians)')
ylabel('Gain (dB)')
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
set(findall(gca, 'Type', 'Text'),'FontSize',32);
set(findall(gca, 'Type', 'Axes'),'FontSize',32);
set(findall(gcf, 'Type', 'Legend'),'FontSize',32);
% Vinay Ramakrishnaiah
% Main program that implements Virtual Terrain Leveling
% clear
close all

global Gain deltheta

% look angles
deltheta = 0 : pi/720 : 2*pi-pi/720;
% deltheta = [deltheta,0];

%% define parameters for FSM
f = 9e08;
c = 3e08;
lambda = c/f;

%% define parameters for WIM
% h_B = height of building in meters 
% b = building separation in meters
% w = width of street in meters
% phi = street orientation angle w.r.t incident wave
% city_type = type of city used in hata model: 1 - open, 2 - suburban, 3 - midrise, 4 -
% highrise
h_bs = 50; % height of base station (transmitter) in meters (4 - 50 m)
h_m = 3; % height of receiver in meters (1 - 3 m)
phiflag = 1; % include street orientation
freq = f/1e6; % frequency of operation in MHz (800 - 2000 MHz)
hataflag = 0; % don't include Hata path loss

%% Compute path losses
% Path loss using WIM
% Distance must be in km for WIM. The values must be in the range of 20 - 5000 m
dist = 1000:25:1300;
% dist = 1000; % specify distance in m, later on scaled to km
distLength = length(dist);
phi = deltheta * 180 / pi;
phiLength = length(phi);
Pr_thresh = zeros(distLength,1);
Pr_obt_thresh = zeros(distLength,1);

for distInd = 1:distLength
    for i = 1:phiLength
        if (phi(i)>=0 && phi(i)<90)
            theta = phi(i);
            ter_label = 1;
            [h_B, b, w, city_type] = switch_zone(ter_label);
        elseif (phi(i)>=90 && phi(i)<180)
            theta = 180 - phi(i);
            ter_label = 1;
            [h_B, b, w, city_type] = switch_zone(ter_label);
        elseif (phi(i)>=180 && phi(i)<270)
            theta = phi(i) - 180;
            ter_label = 1;
            [h_B, b, w, city_type] = switch_zone(ter_label);
        else
            theta = phi(i) - 270;
            ter_label = 1;
            [h_B, b, w, city_type] = switch_zone(ter_label);
        end
        loss_wim_dB = wim(h_bs, h_m, h_B, b, w, phiflag, theta, dist(distInd)/1000, freq, city_type, hataflag);
        loss_wim(i) = abs(10^(loss_wim_dB/10)); % convert dB to non-dB path loss
    end
    % Path loss using FSM
    loss_fsm = fsm(lambda, dist(distInd));
    Gain = loss_wim/loss_fsm;
    for Pt = 11 % transmitter power in Watts
        Pr_desired = (Pt.*Gain)./loss_wim;
    %     Pr_desired = Pr_desired * sum(Pr) / sum(Pr_desired); %scale power to sum to the original power
    %     Gain = Pr_desired.*loss_wim/Pt;
    %     Gain = Gain*2*pi/sum(Gain);
        [wt,Gest,n,PT_fact] = computeWeights(lambda, deltheta);
    %     Gest = Gest*2*pi/trapz(deltheta, Gest); % Post scaling of estimated gain
  
        disp('PT=')
        PT = Pt*PT_fact
        Pr = Pt./loss_wim;
        Pr_obt = (Pt.*Gest)./(loss_wim);
        Pr_ideal = (Pt.*Gain)./(loss_wim);

        Threshold_db  = -95;
        Threshold = 10^(Threshold_db/10);
        Pr_thresh(distInd) = sum(Pr > Threshold);
        Pr_obt_thresh(distInd) = sum(Pr_obt > Threshold);  

        disp('Percentage of power above threshold without VTL')
        percentWOVTL = Pr_thresh/length(deltheta)*100;
        disp(percentWOVTL)
        disp('Percentage of power above threshold with VTL')
        percentWVTL = Pr_obt_thresh/length(deltheta)*100;
        disp(percentWVTL)
    end
end

figure
hold all
plot(dist,percentWOVTL)
plot(dist,percentWVTL)
xlabel('distance (m)')
ylabel('Percentage of look angles above threshold')
legend('without VTL', 'with VTL')
hold off

figure
hold all
plot(deltheta,10*log10(Pr))
plot(deltheta,10*log10(Pr_desired))
plot(deltheta,10*log10(Pr_obt))
xlabel('Look angle (radians)')
ylabel('Received power (dBW)')
legend('WIM Received power','Desired Received power','Obtained Received power')
hold off
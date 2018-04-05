%% Program to find the weights of an antenna array given the gain pattern
%  Author: Vinay Ramakrishnaiah

clear 
close all

% simulated gain
x = -pi : pi/360 : pi;
G = x.^2; % Gain with respect to origin

% Antenna location must be at the origin as we need to calculate the
% steering vector with respect to the same origin
x1 = 0;
y1 = 0;

f0=900e6;               % frequency
c=300e6;                % velocity of light
lambda=c/f0;            % wavelength
WaveNumber=2*pi/lambda; % wavenumber
d = lambda / 4;         % antenna spacing

arryshort = [x1,y1 x1+d,y1 x1,y1+d x1+d,y1+d x1,y1+2*d x1+2*d,y1 x1+2*d,y1+d x1+d,y1+2*d x1+2*d,y1+2*d];
Nsens = length(arryshort)/2;

for ksens=0:Nsens-1
    ix=ksens*2+1;
    for j=1:length(x) % consider all directions
        sLook(ksens + 1,j)=sdist(arryshort(ix),arryshort(ix+1),x(j));%calculate the steering vector for the nodes by considering all directions(for noise power)            
    end
end

h = exp(1i * sLook * WaveNumber);
w = G/h;

plot(x,G,'r.-');
hold on
plot(x,abs(w*h),'b-');
hold off
legend('Actual gain','Gain computed using weights')
xlabel('look angle');
ylabel('Gain');
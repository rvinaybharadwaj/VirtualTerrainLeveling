function [w, Gest, n, PT_fact] = computeWeights(lambda, lookAngle)

global h Gain deltheta
% Antenna location
x1 = 0;
y1 = 0;

WaveNumber=2*pi/lambda; % wavenumber
d = lambda / 4;         % antenna spacing

% arryshort = [x1,y1 x1+d,y1 x1,y1+d x1+d,y1+d x1,y1+2*d x1+2*d,y1 x1+2*d,y1+d x1+d,y1+2*d x1+2*d,y1+2*d];
% Select:
% 1. linear array
% 2. square grid array
% 3. circular array
select = 3;
n = [36]; % number of antennas in the array
for i=1:length(n)
    arryshort = array_setup( x1,y1,n(i),d,select );
    Nsens = length(arryshort)/2;

    for ksens=0:Nsens-1
        ix=ksens*2+1;
        hold on 
        scatter(arryshort(ix),arryshort(ix+1))
        for j=1:length(lookAngle) % consider all directions
            sLook(ksens + 1,j)=sdist(arryshort(ix),arryshort(ix+1),lookAngle(j));%calculate the steering vector for the nodes by considering all directions(for noise power)            
        end
    end
    hold off
    title('antenna array')
    h = exp(1i * sLook * WaveNumber);
    
    % Use only one weight finding technique at a time
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Uncomment this section for enabling search based phase-only weights
%     % Use Nelder-Mead search for finding phase-only weights
%     MaxFunEvals=realmax;
%     MaxIter=realmax;
%     options=optimset('MaxFunEvals',MaxFunEvals,'MaxIter',MaxIter);
%     guess=ones(1,Nsens);%initial guess of phi values to pass to fminsearch
%     [phi, fval] = fminsearch(@minGainError, guess, options);
%     w=exp(1i*phi);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Uncomment this section to enable convex optimization of weights
    % Use CVX software for optimization
    cvx_begin quiet
        variable w(n(i)) complex
        eps = w'*h-sqrt(Gain);
%         error = eps*eps';
        minimize(norm(eps,2))
%         minimize(sum(huber(eps)))
        subject to
            abs(w) <= 1;
    cvx_end
    w=w';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Uncomment this section to enable least square calculation of weights
%     % Use least-squares technique (pseudo inverse)
%     w = sqrt(Gain)/h;
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% Total "power factor"
    % Amplifier has to provide power equal to Pout-Pin, Pin = Pt/N and PT = sum(Pout)
    % Since Pout = G_volt^2*Pin, PT=Pt/N*sum(G_volt^2) 
    PT_fact = sum(abs(w))/length(w);  
%     PT_fact = 1; %% Set for Pt = PT in CVX
    %% Gain computation
    Gest(i,:) = (abs(w*h).^2); % Compute the power gain
    Gest(i,:) = (2*pi/trapz(deltheta,Gest(i,:)))*(PT_fact)*Gest(i,:);
end
figure
plot(lookAngle,10*log10(Gain));
legendInfo{1} = 'Required gain';
for i=1:length(n)    
    hold all
    plot(lookAngle,10*log10(Gest(i,:)));
    legendInfo{i+1} = ['Gain estimate, n = ' num2str(n(i))]; 
end
legend(legendInfo);
xlabel('look angle');
ylabel('Gain (dB)');
hold off
Gest = Gest(end,:);
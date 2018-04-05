function [ error ] = minGainError( phi )
%   Onjective function for minimization of error
    global h Gain deltheta
    w = exp(1i*phi);
    Gest = abs(w*h).^2;
    error = mean(abs(Gain-Gest));
end


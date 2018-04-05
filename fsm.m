% Vinay Ramakrishnaiah
function [ loss ] = fsm( lambda, dist )
% Calculates the path loss using free-space model
loss = (4*pi*dist/lambda)^2;

end


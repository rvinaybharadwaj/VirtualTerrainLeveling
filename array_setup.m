function [ arryshort ] = array_setup( x,y,n,d,select )
% arryshort = array_setup(x,y) builds an 'n' antenna arrays with an element
% in the location of the reference coordinates (x,y). The variable 'select'
% is used to choose the following type of antenna arrays
% 1. linear array
% 2. square grid array
% 3. circular array
    switch select
        case 1
            % linear array
            arryshort = [x,y];
            for i = 1:n-1
                arryshort = [arryshort,x,y+i*d];
            end
        case 2
            % square grid array
            sqrt_n = sqrt(n);
            x_array = x;
            y_array = y;
            for i = 1:sqrt_n-1
                x_array = [x_array,x+i*d];
                y_array = [y_array,y+i*d];       
            end
            [u,v] = meshgrid(x_array,y_array);
            arry = [u(:),v(:)]';
            arryshort = arry(:);
            
        case 3
            % circular array centered at (x,y)
            m = 0.5; % number of peels
            arryshort = [];
            theta = linspace(0,2*pi-2*pi/n,n).';
            a = x+cos(theta)*m;
            b = y+sin(theta)*m;
            pt = [a(:),b(:)];
            pt = pt';
            arryshort = [arryshort,pt(:)'];
    end
end


function [h_B, b, w, city_type] = switch_zone(ter_label)
   
    
%     h_B  = average building height in meters
%     b = building seperation in meters
%     w = street width in meters
%     theta = orientation of streets in degrees
%% City type
% 0 = open
% 1 = suburban
% 2 = mid-rise
% 3 = high-rise

    switch (ter_label)
        case 0
            h_B=5; b=100; w=b/2; city_type = 0;
        case 1 
            h_B=5; b=15; w=b/2; city_type = 1;
        case 2
            h_B=15; b=20; w=b/2; city_type = 2;
        case 3
            h_B=40; b=20; w=b/2; city_type = 3;
    end
end
%This is the Hata model. It is a very simple propagation model which 
%considers only trnsmitter antenna height, receiver antenna height and
%distance between them. I implemented this function just as a reference
%model for comparision with the Walfisch Ikegami model.
%##########################################################################
%Harish Muralidhara
%2009
%##########################################################################
%The various terms associated are explained below.

%h_bs = transmitter antenna height from ground level
%h_m = receiver antenna height
%c_h = Antenna height correction factor
 
%BK has added city_type and correction for big city
%--------------------------------------------------------------------------

function [loss] = hata (h_bs, h_m,d, freq, city_type,h_B)

c_h=0;
if h_B>15 %big city if buildings > 15 m ("Hata and CCIR formulas" PPT)
    if (freq >= 150 && freq<200)
        c_h = 8.29*(log10(1.54*h_m))^2 - 1.1; %Compute the antenna correction factor
    else if(freq >= 200 && freq<1500)
            c_h = 3.2*(log10(11.75*h_m))^2 - 4.97;
        end
    end 
else %not big city
    c_h = (1.1*log10(freq) - 0.7) * h_m - (1.56*log10(freq) - .8);
end
%baseline, city_type=0 for urban area
loss = 69.55 + 26.16*log10(freq)-13.82*log10(h_bs)-c_h+(44.9-6.55*log10(h_bs))*log10(d);%Final path loss
if(city_type == 1) %correction for suburban
    loss = loss-(2*(log10(freq/28))^2)-5.4;
end
if (city_type == 0) %correction for open rural
    loss = loss - (4.78*(log10(freq))^2)+(18.33*log10(freq))-40.94;
end

end

%End of Hata model
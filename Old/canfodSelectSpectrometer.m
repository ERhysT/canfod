function id = canfodSelectSpectrometer(wrapper,n)
% CANFODSELECTSPECTROMETER get a user input to select the
% spectrometer.
%
% ID = CANFODSELECTSPECTROMETER(WRAPPER, n)
% 
% Arguments:
% 
% wrapper (com.oceanoptics.omnidriver.api.wrapper.Wrapper) OceanOptics
% Omnidriver java object.
%  
% n (int) number of connected spectrometers.
% 
% Returns:
% 
% id (id) I.D number of slected spectrometer.
% 
% See also CANFODSHOWSPECTROMETERS, CANFODSETPARAM.
%

    id = -1;
    while ~isinteger(n) || id > n || id < 0

        id = input('Enter a spectrometer I.D. Number... ');
        
    end

    id = id - 1;                        % omnidriver counts from 0
    
end




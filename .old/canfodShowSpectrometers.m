function [models] = canfodShowSpectrometers(wrapper,n)
% CANFODSHOWSPECTROMETERS list the avaliable spectrometers.
%
% MODELS = CANFODSHOWSPECTROMETERS(WRAPPER, n)
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
% models (n by 2) cell of strings. Model name and Serial
% Number.
%
% See also CANFODINIT, CANFODSELECTSPECTROMETER.
%

    fprintf('\nSpectrometer(s) detected:\n');

    models = cell(n,2);

    for ii = 1 : n
        
        % getName uses 0 based counting system (ii-1)

        models{ii,1} = wrapper.getName(ii-1);
        models{ii,2} = wrapper.getSerialNumber(ii-1);
        fprintf('\t1. model: %s s/n: %s\n\n', ...
                models{ii,1}, models{ii,2});
        
    end
end
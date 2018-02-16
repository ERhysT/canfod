function canfodSetParam(wrapper)
% CANFODSETPARAM set the parameters of the specified
% spectrometer. Once the parameters have been set, a measurement
% can be taken with canfodAquire().
%
%    CANFODSETPARAM(WRAPPER)
%     
%    See also CANFODAQUIRE.
    
    
    idx_spectrometer = 0;
    integration_time = 5000;            % ms

    wrapper.setIntegrationTime(idx_spectrometer, integration_time);
    
end

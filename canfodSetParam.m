function canfodSetParam(wrapper)
% CANFODSETPARAM set the paramaters for aquisition

    idx_spectrometer = 0;
    integration_time = 5000;            % ms

    wrapper.setIntegrationTime(idx_spectrometer, integration_time);
    
end

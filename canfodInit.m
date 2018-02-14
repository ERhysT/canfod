function wrapper = canfodInit()
% CANFODINIT Initialise java class for omnidriver
    
    % omnidriver directory must be in classpath for the wrapper to
    % function
    
    wrapper = com.oceanoptics.omnidriver.api.wrapper.Wrapper();

    % Scan every avaliable USB address for spectrometer

    n_spectrometer =  wrapper.openAllSpectrometers();
    
    switch n_spectrometer
      case -1
       errstr =  wrapper.getLastException();
       errstr = strcat('Failed to open a spectrometer:\n', errstr);
       error(errstr);
      case 0
        error('No spectrometers connected');
    end

    % Get spectrometer information and print

    fprintf('%d Spectrometer(s) detected:\n', n_spectrometer);

    spectrometer_info = cell(n_spectrometer,2);
    
    for ii = 1 : n_spectrometer
        
        % getName uses 0 based counting system (ii-1)

        spectrometer_info{ii,1} = wrapper.getName(ii-1);
        spectrometer_info{ii,2} = wrapper.getSerialNumber(ii-1);
        fprintf('\t1. model: %s s/n: %s\n', ...
                spectrometer_info{ii,1}, spectrometer_info{ii,2});
        
    end
    
    
end


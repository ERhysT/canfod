function initialiseOmnidriver(HSF)
% Create an instance of the OmniDriver wrapper Java Class and
% initialise all connected spectrometers
    
    HSF.omnidriver = com.oceanoptics.omnidriver.api.wrapper.Wrapper();

    HSF.n_connected_spectrometers = ...
        int8( HSF.omnidriver.openAllSpectrometers();

    if ~isinteger(n) || n < -1
        error('Omnidriver I/O error');
    end
    
    switch n
      case -1                 % I/O error
        errstr = CS.omnidriver.getLastException();
        errstr = strcat('Failed to open a spectrometer:', errstr);
        error(errstr);
      case 0
        error('No spectrometers connected');
    end
end

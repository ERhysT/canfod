function [wrapper,n] = canfodInit()
% CANFODINIT Initialise Ocean Optics (tm) Omnidriver, create and
% return instance of omnidriver wrapper and the number of
% spectrometers connected. The connection to the spectrometer requires
% closing using canfodClose().
% 
% [WRAPPER, N] = CANFODINIT()
% 
% Returns:
% 
% wrapper (com.oceanoptics.omnidriver.api.wrapper.Wrapper) OceanOptics
% Omnidriver java object.
% 
% n (int) number of connected spectrometers.
% 
% See also CANFODSHOWSPECTROMETERS, CANFODCLOSE.
    
    % OmniDriver directory must be in classpath for the wrapper to
    % function. The classpath can be viewed using
    % javaclasspath().
    
    wrapper = com.oceanoptics.omnidriver.api.wrapper.Wrapper();

    % Scan every avaliable USB address for spectrometer

    n = wrapper.openAllSpectrometers();
    n = int8(n);
    
    if ~isinteger(n) || n < -1
        error('Omnidriver I/O error');
    end

    
    
    switch n
      case -1                           % I/O Error
       errstr =  wrapper.getLastException();
       errstr = strcat('Failed to open a spectrometer:', errstr);
       error(errstr);
      case 0
        error('No spectrometers connected');
    end
    
end


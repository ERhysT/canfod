function spectrum = canfodAquire(wrapper)
% CANFODAQUIRE aquire spectral data. Paramaters should be provided
% prior to aquisition using canfodSetParam(). Connection to
% spectrometer should be terminated with canfodClose().
%
%    SPECTRUM = CANFODAQUIRE(WRAPPER)
%
% See also CANFODSETPARAM, CANFODCLOSE.

    spectrum = wrapper.getSpectrum(0);

end

classdef Spectrometer < handle
% OceanOpticsHSF.Spectrometer class
% 
% Defines Spectrometer object that interfaces with OceanOptics.OmniDriver
% object to perform spectral measurements. The Spectrometer constructed is an
% array of objects with one instance of the Spectrometer object for every USB
% spectrometer detected by the OmniDriver.
% 
% The Spectrometer interfaces with the OmniDriver using the Java wrapper
% contained in an OmniDriver object.
% 
%          com.oceanoptics.omnidriver.api.wrapper
%
% NOTE: network spectrometers are not currently supported
%
% The default settings for each connected spectrometer are determined upon
% construction. These values are stored as properties. The extra features of the
% spectrometer which are interfaced using controllers other than the OmniDriver
% are determined using the isFeatureSupportedXXXX() functions provided by
% OmniDriver.
%
% Measurement parameters such as integration time, boxcar width and number of
% scans to average can be set using methods. These parameters are validated
% using 
% 
% Additional validation parameters have been created where the
% spectrometer/OmniDriver does not provide a mechanism for sane
% defaults.
% 
% Calibration are retrevied on initialisation, however they cannot currently
% be set.
% 
% TODO: -
%       -
%       -
%       -
%       -
%       -
%       -
%       -
% 
    properties
        
        OD                   OmniDriver % Reference to OmniDriver

        idx                  int        % index number assigned by omnidriver
                                        % omnidriver uses zero based counting
                                        % system

        name                 string     % identifying the type of
                                        % spectrometer
        
        serial_number        string     % serial number of the specified
                                        % spectrometer
        
        max_int_time         int        % maximum allowed integration time,
                                        % in microseconds

        min_int_time         int        % minimum allowed integration time,
                                        % in microseconds

        int_step_inc         int        % integration step size in
                                        % microseconds
        
        max_intensity        int        % maximum possible value for a CCD
                                        % pixel. Equivalent to the saturation
                                        % point.

        firmware_ver         string     % version of the FX2 firmware in the
                                        % spectrometer

        firmware_model       string     % model name in the spectrometer
        
        n_px                 int        % total number of pixels (ie. CCD
                                        % elements) provided by this
                                        % spectrometer, including any dark or
                                        % bevel (unused) pixels
        
        n_dark_px            int        % number of dark pixels provided by
                                        % this spectrometer
        
        int_time             int        % current integration time setting,
                                        % in units of microseconds

        n_scan_average       int        % number of scans to average
        
        boxcar_width         int        % number of pixels on either side of
                                        % a given pixel to average together
                                        % when obtaining a spectrum.

        mode                 int        % external trigger mode of the
                                        % spectrometer.

        p_elect_dark         bool       % True if electrical dark connection
                                        % is enabled

        p_stray_light        bool       % true if stray light correction is
                                        % enabled
        
        p_non_linear         bool       % true if non linearity correction is
                                        % enabled
        
        p_strobe             bool       % true if strobe is enabled

        p_timeout            bool       % true if an aquisition timeout is
                                        % set
        
        wavelengths          double     % calculated wavelength values
                                        % corresponding to each pixel in the
                                        % acquired spectrum. Wavelength
                                        % calibration coefficients have been
                                        % applied to improve the accuracy of the
                                        % returned values.

        % Optional supported features, interrogated on construction to determine
        % if each feature is supported.
        
        features = struct( 'gpio', 0, ...
                           'saturation_threshold', 0, ...
                           'spibus', 0, ...
                           'light_src', 0, ...
                           'single_strobe', 0, ...
                           'continuous_strobe', 0, ...
                           'current_out', 0, ...
                           'board_temp', 0, ...
                           'detector_temp', 0, ...
                           'analogue_in', 0, ...
                           'analogue_out', 0, ...
                           'ls450', 0, ...
                           'ls450_external_temp', 0, ...
                           'uv_vis_light_src', 0, ...
                           'px_binning', 0, ...
                           'network_config', 0, ...
                           'spectrum_type', 0, ...
                           'external_trigger_delay', 0, ...
                           'ic2bus', 0, ...
                           'hi_gain_mode', 0, ...
                           'irradiance_cal_factor', 0, ...
                           'nonlinearity_correction_provider', 0, ...
                           'stray_light_correction', 0, ...
                           'controller_version', 0, ...
                           'wavelength_calibration_provider', 0, ...
                           'thermo_electric', 0, ...
                           'indy', 0, ...
                           'internal_trigger', 0, ...
                           'data_buffer', 0);

        
        % Calibration Coefficients (Java Objects)
        % Class: com.oceanoptics.omnidriver.spectrometer.Coefficients

        cc_eeprom                       % Refresh our internal buffer with
                                        % the current calibration settings
                                        % obtained directly from the
                                        % spectrometer EEPROM. Then return a
                                        % copy of these values. These are the
                                        % values which will be used for all
                                        % spectral acquisitions on this
                                        % spectrometer. 

        cc_buffer                       % calibration coefficients as
                                        % currently stored in our internal
                                        % buffer. These are the values which
                                        % will be used for all spectral
                                        % acquisitions on this spectrometer.
    end
    
    properties (Access = private, Constant = true)
        % Properties not defined by OmniDriver but useful for validation.

        MAX_BOXCAR_WIDTH = 100;         % maximum number of pixels averaged
        MAX_N_SCANS = 50;               % maximum number of scans to average
        
    end

    methods
    
        function S = Spectrometer(OD)
        % Constructs an array of spectrometers for each connected spectrometer
            
            if nargin ~= 1 || ~strcmp( class(OD), 'OmniDriver' )

                warning(['Spectrometer requires OmniDriver object interface ' ...
                         'with hardware']);
                
                return
            end
            
            S(OD.number_connected_spectrometer) = Spectrometer;

            idx = 0;                 % omnidriver uses 0 based counting

            for idx = 1 : OD.number_connected_spectrometers
                
                S(idx).idx = idx;
                idx = idx + 1;

                S.OD = OD;

                getAllCapabilities(S);

            end
        end
        
        function setIntegrationTime(idx, time)
        % Validate the requested integration time according to the
        % capabilites of the indexed spectrometer. If within acceptable
        % boundries, apply to indexed spectrometer.

            if time < S(idx).min_int_time ...
                    || time > S(idx).max_int_time ...
                    || ~isreal(time) ...
                    || ~isint(time)

                errstr = sprintf(['Cannot set integration time: the integration ' ...
                                  'time must be a real integer between %d and ' ...
                                  '%d us.'], ...
                                 S(idx).min_int_time, S(idx).max_int_time);
                warning(errstr);

                return
            
            end

            % Set Integration time using OmniDriver wrapper:
            %
            % com.oceanoptics.omnidriver.api.wrapper
            %  setIntegrationTime()
            %
            % public void setIntegrationTime(int spectrometerIndex,
            %                                int usec)

            OD.wrapper.setIntegrationTime(idx, time);
            assertApplied(time, S.OD.wrapper.getIntegrationTime(idx), ...
                          'integration time');
            S(idx).int_time = time;

        end

        function setBoxcarWidth(idx, width)
        % Set the number of pixels on either side of a given pixel to average
        % together when obtaining a spectrum. For example, if you set this
        % parameter to 2, each pixel of the acquired spectrum will be the
        % result of averaging 5 pixels together, 2 on the left, 2 on the
        % right, and the pixel itself. Set this value to 0 to avoid this
        % "smoothing" mechanism.
            
            if ~isint(width) ...
                    || width < 0 ...
                    || ~isreal(width) ...
                    || width > S.MAX_BOXCAR_WIDTH

                errstr = sprintf(['Cannot set boxcar width, input must be ' ...
                                  'a real positive integer less than %d.'], ...
                                 S.MAX_BOXCAR_WIDTH);
                warning(errstr);
                return
            
            end

            % Set boxcar width using OmniDriver wrapper:
            %
            % com.oceanoptics.omnidriver.api.wrapper
            %  setBoxcarWidth
            %
            % public void setBoxcarWidth(int spectrometerIndex,
            %                            int numberOfPixelsOnEitherSideOfCenter)

            OD.wrapper.setBoxcarWidth(idx, width);
            assertApplied(width, S.OD.wrapper.getBoxcarWidth(idx), ...
                          'boxcar width');
            S(idx).boxcar_width = width;

        end

        

        function setScansToAverage(idx, scans)
        % Define number of scans to average before returning spectral data from
        % OmniDriver getSpectrum(). Default is "1" - ie. do not average multiple
        % scans together. 
            
            if ~isint(scans) ...
                    || ~isreal(scans) ...
                    || scans < 1 ...
                    || scans > S.MAX_SCANS
                
                errstr = sprintf(['Cannot set boxcar width, input must be ' ...
                                  'a real positive integer less than %d.'], ...
                                 S.MAX_SCANS);
                warning(errstr);
                return
                
                % Set scans to average using OmniDriver wrapper:
                %
                % com.oceanoptics.omnidriver.api.wrapper            
                %  setScansToAverage
                %
                % public void setScansToAverage(int spectrometerIndex,
                %                               int channelIndex,
                
                OD.wrapper.setScansToAverage(idx, scans);
                assertApplied(scans, S.OD.wrapper.getScansToAverage(idx), ...
                              'scans to average');
                S(idx).boxcar_width = width;
                
            end
        end
    end

    methods (Access = private)
        
        getAllCapabilities(S, OD)          % declaration

        function assertApplied(tx, rx, str)
           
            errstr = sprintf('OmniDriver I/O error, could not set %s.', str);

            assert(tx == rx, errstr);
            
        end
    end
end

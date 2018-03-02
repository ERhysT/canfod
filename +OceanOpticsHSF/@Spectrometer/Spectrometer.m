classdef Spectrometer < handle
    
    properties
        
        id                   int        % ID number assigned by omnidriver
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
                           'data_buffer', 0, ...
                           );
        
        % Calibration Coefficients (Java Objects)
        % com.oceanoptics.omnidriver.spectrometer.Coefficients

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
    
    methods
    
        function S = Spectrometer(OD)
        % Constructs an array of spectrometers for each connected spectrometer
            
            if nargin ~= 1 || ~strcmp( class(OD), 'OmniDriver' )

                error(['Spectrometer class requires OmniDriver object']);

            end
            
            S(OD.number_connected_spectrometer) = Spectrometer;

            id = 0;                 % omnidriver uses 0 based counting

            for n = 1 : OD.number_connected_spectrometers)
                
                S(n).id = id;
                id = id + 1;

                S(n).name = OD.wrapper.getName(S(n).id);
                S(n).serial_number = OD.wrapper.getSerialNumber(S(n).id);

                S(n).max_int_time = ... % us
                    OD.wrapper.getMaximumIntegrationTime(S(n).id);
                
                S(n).min_int_time = ... % us
                    OD.wrapper.getMinimumIntegrationTime(S(n).id);
                
                S(n).int_step_inc = ... % us
                    OD.wrapper.getIntegrationStepIncrement(S(n).id);
                
                S(n).max_intensity = ... % a.u.
                    OD.wrapper.getMaxiumIntensity(S(n).id);
                
                S(n).firmware_ver = ...
                    OD.wrapper.getFirmwareVersion(S(n).id);
                
                S(n).firmware_model = ...
                    OD.wrapper.getFirmwareModel(S(n).id);
                
                S(n).n_px = ...
                    OD.wrapper.getNumberOfPixels(S(n).id);
                
                S(n).n_dark_px = ...
                    OD.wrapper.getNumberOfDarkPixels(S(n).id);
                
                S(n).int_time = ... % us
                    OD.wrapper.getIntegrationTime(S(n).id);
                
                S(n).n_scan_average = ....
                    OD.wrapper.getScansToAverage(S(n).id);
                
                S(n).boxcar_width = ...
                    OD.wrapper.getBoxcarWidth(S(n).id);
                
                S(n).cc_eeprom = ...
                    OD.wrapper.getCalibrationCoefficientsFromEEProm(S(n).id);

                S(n).cc_buffer = ...
                    OD.wrapper.getCalibrationCoefficientsFromBuffer(S(n).id);
                
                S(n).mode = ...
                    OD.wrapper.getExternalTriggerMode(S(n).id);
                
                S(n).p_elect_dark = ...
                    OD.wrapper.getCorrectForElectricalDark(S(n).id);
                
                S(n).p_stray_light = ...
                    OD.wrapper.getCorrectForStrayLight(S(n).id);
                
                S(n).p_non_linear = ...
                    OD.wrapper.CorrectForDetectorNonlinearity(S(n).id);
                
                S(n).p_strobe = ...
                    OD.wrapper.getStrobeEnable(S(n).id);

                S(n).wavelengths = ...
                    OD.wrapper.getWavelengths(S(n).id);
                
                % Determine what features are avaliable for use on this
                % spectrometer
                
                S(n).features.gpio = ...
                    OD.wrapper.isFeatureSupportedGPIO(S(n).id);

                S(n).features.saturation_threshold = ...
                    OD.wrapper.isFeatureSupportedSaturationThreshold(S(n).id);
                
                S(n).features.spibus = ...
                    OD.wrapper.isFeatureSupportedSPIBus(S(n).id);
                
                S(n).features.light_src = ...
                    OD.wrapper.isFeatureSupportedLightSource(S(n).id);
                
                S(n).features.single_strobe = ...
                    OD.wrapper.isFeatureSupportedSingleStrobe(S(n).id);
                
                S(n).features.current_out = ...
                    OD.wrapper.isFeatureSupportedCurrentOut(S(n).id);
                
                S(n).features.board_temp = ...
                    OD.wrapper.isFeatureSupportedBoardTemperature(S(n).id);
                
                S(n).features.detector_temp = ...
                    OD.wrapper.isFeatureSupportedDetectorTemperature(S(n).id);
                
                S(n).features.analogue_in = ...
                    OD.wrapper.isFeatureSupportedAnalogIn(S(n).id);
                
                S(n).features.analogue_out = ...
                    OD.wrapper.isFeatureSupportedAnalogOut(S(n).id);
                
                S(n).features.ls450 = ...
                    OD.wrapper.isFeatureSupportedLS450(S(n).id);
                
                S(n).features.ls450_external_temp = ...
                    OD.wrapper ...
                    .isFeatureSupported_USB_LS450_ExternalTemperature(S(n).id);
                
                S(n).features.uv_vis_light_src = ...
                    OD.wrapper.isFeatureSupported_UV_VIS_LightSource(S(n).id);
                
                S(n).features.px_binning = ...
                    OD.wrapper.isFeatureSupportedPixelBinning(S(n).id);
                
                S(n).features.network_config = ...
                    OD.wrapper.isFeatureSupportedNetworkConfigure(S(n).id);
                
                S(n).features.spectrum_type = ...
                    OD.wrapper.isFeatureSupportedSpectrumType(S(n).id);
                
                S(n).features.external_trigger_delay = ...
                    OD.wrapper.isFeatureSupportedExternalTriggerDelay(S(n).id);
                
                S(n).features.ic2bus = ...
                    OD.wrapper.isFeatureSupportedI2CBus(S(n).id);
                
                S(n).features.hi_gain_mode = ...
                    OD.wrapper.isFeatureSupportedHighGainMode(S(n).id);
                
                S(n).features.irradiance_cal_factor = ...
                    OD.wrapper ...
                    .isFeatureSupportedIrradianceCalibrationFactor(S(n).id);
                
                S(n).features.nonlinearity_correction_provider = ...
                    OD.wrapper ...
                    .isFeatureSupportedNonlinearityCorrectionProvider(S(n).id);
                
                S(n).features.stray_light_correction = ...
                    OD.wrapper.isFeatureSupportedStrayLightCorrection(S(n).id);
                
                S(n).features.controller_version = ...
                    OD.wrapper.isFeatureSupportedVersion(S(n).id);
                
                S(n).features.wavelength_calibration_provider = ...
                    OD.wrapper ...
                    .isFeatureSupportedWavelengthCalibrationProvider(S(n).id);
                
                S(n).features.thermo_electric = ...
                    OD.wrapper.isFeatureSupportedThermoElectric(S(n).id);
                
                S(n).features.indy = ...
                    OD.wrapper.isFeatureSupportedIndy(S(n).id);
                
                S(n).features.internal_trigger = ...
                    OD.wrapper.isFeatureSupportedInternalTrigger(S(n).id);
                
                S(n).features.data_buffer = ...
                    OD.wrapper.getFeatureControllerDataBuffer(S(n).id);

            end
        end
    end
end

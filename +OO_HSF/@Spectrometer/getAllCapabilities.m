function getAllCapabilities(S)
% GETALLCAPABILITIES obtain information about a connected USB spectrometer
% and store in a OO_HSF.Spectrometer object
% 
% This function uses the OceanOptics OmniDriver to connect with a USB
% spectrometer. The OmniDriver is used to obtain information about the
% spectrometer and its capabilities. This function is called during the
% construction of an OO_HSF/Spectrometer object.
%
% see also, OO_HSF.Spectrometer

    % OmniDriver and Spectrometer Model Information

    S(idx).name = OD.wrapper.getName(S(idx).idx);
    S(idx).serial_number =  OD.wrapper.getSerialNumber(S(idx).idx);
    S(idx).firmware_ver =  OD.wrapper.getFirmwareVersion(S(idx).idx);
    S(idx).firmware_model = OD.wrapper.getFirmwareModel(S(idx).idx);

    % Acquisition Parameters

    S(idx).int_time = OD.wrapper.getIntegrationTime(S(idx).idx);
    S(idx).max_int_time = OD.wrapper.getMaximumIntegrationTime(S(idx).idx);
    S(idx).min_int_time = OD.wrapper.getMinimumIntegrationTime(S(idx).idx);
    S(idx).int_step_inc = OD.wrapper.getIntegrationStepIncrement(S(idx).idx);

    S(idx).n_scan_average = OD.wrapper.getScansToAverage(S(idx).idx);
    S(idx).boxcar_width = OD.wrapper.getBoxcarWidth(S(idx).idx);

    S(idx).p_strobe = OD.wrapper.getStrobeEnable(S(idx).idx);
    S(idx).p_non_linear = ...
        OD.wrapper.getCorrectForDetectorNonlinearity(S(idx).idx);
    S(idx).p_elect_dark = OD.wrapper.getCorrectForElectricalDark(S(idx).idx);
    
    % Spectrometer Information

    S(idx).max_intensity = OD.wrapper.getMaxiumIntensity(S(idx).idx);
    S(idx).n_px = OD.wrapper.getNumberOfPixels(S(idx).idx);
    S(idx).n_dark_px = OD.wrapper.getNumberOfDarkPixels(S(idx).idx);
    S(idx).cc_eeprom = ...
        OD.wrapper.getCalibrationCoefficientsFromEEProm(S(idx).idx);
    S(idx).cc_buffer = ...
        OD.wrapper.getCalibrationCoefficientsFromBuffer(S(idx).idx);
    S(idx).mode = OD.wrapper.getExternalTriggerMode(S(idx).idx);
    S(idx).p_stray_light = OD.wrapper.getCorrectForStrayLight(S(idx).idx);
    S(idx).wavelengths = OD.wrapper.getWavelengths(S(idx).idx);
    
    % Optional Features
    
    S(idx).features.gpio = OD.wrapper.isFeatureSupportedGPIO(S(idx).idx);
    S(idx).features.saturation_threshold = ...
        OD.wrapper.isFeatureSupportedSaturationThreshold(S(idx).idx);
    S(idx).features.spibus = OD.wrapper.isFeatureSupportedSPIBus(S(idx).idx);
    S(idx).features.light_src = ...
        OD.wrapper.isFeatureSupportedLightSource(S(idx).idx);
    S(idx).features.single_strobe = ...
        OD.wrapper.isFeatureSupportedSingleStrobe(S(idx).idx);
    S(idx).features.current_out = ...
        OD.wrapper.isFeatureSupportedCurrentOut(S(idx).idx);
    S(idx).features.board_temp = ...
        OD.wrapper.isFeatureSupportedBoardTemperature(S(idx).idx);
    S(idx).features.detector_temp = ...
        OD.wrapper.isFeatureSupportedDetectorTemperature(S(idx).idx);
    S(idx).features.analogue_in = ...
        OD.wrapper.isFeatureSupportedAnalogIn(S(idx).idx);
    S(idx).features.analogue_out = ...
        OD.wrapper.isFeatureSupportedAnalogOut(S(idx).idx);
    S(idx).features.ls450 = ...
        OD.wrapper.isFeatureSupportedLS450(S(idx).idx);
    S(idx).features.ls450_external_temp = ...
        OD.wrapper.isFeatureSupported_USB_LS450_ExternalTemperature(S(idx).idx);
    S(idx).features.uv_vis_light_src = ...
        OD.wrapper.isFeatureSupported_UV_VIS_LightSource(S(idx).idx);
    S(idx).features.px_binning = ...
        OD.wrapper.isFeatureSupportedPixelBinning(S(idx).idx);
    S(idx).features.network_config = ...
        OD.wrapper.isFeatureSupportedNetworkConfigure(S(idx).idx);
    S(idx).features.spectrum_type = ...
        OD.wrapper.isFeatureSupportedSpectrumType(S(idx).idx);
    S(idx).features.external_trigger_delay = ...
        OD.wrapper.isFeatureSupportedExternalTriggerDelay(S(idx).idx);
    S(idx).features.ic2bus = ...
        OD.wrapper.isFeatureSupportedI2CBus(S(idx).idx);
    S(idx).features.hi_gain_mode = ...
        OD.wrapper.isFeatureSupportedHighGainMode(S(idx).idx);
    S(idx).features.irradiance_cal_factor = ...
        OD.wrapper.isFeatureSupportedIrradianceCalibrationFactor(S(idx).idx);
    S(idx).features.nonlinearity_correction_provider = ...
        OD.wrapper.isFeatureSupportedNonlinearityCorrectionProvider(S(idx).idx);
    S(idx).features.stray_light_correction = ...
        OD.wrapper.isFeatureSupportedStrayLightCorrection(S(idx).idx);
    S(idx).features.controller_version = ...
        OD.wrapper.isFeatureSupportedVersion(S(idx).idx);
    S(idx).features.wavelength_calibration_provider = ...
        OD.wrapper.isFeatureSupportedWavelengthCalibrationProvider(S(idx).idx);
    S(idx).features.thermo_electric = ...
        OD.wrapper.isFeatureSupportedThermoElectric(S(idx).idx);
    S(idx).features.indy = ...
        OD.wrapper.isFeatureSupportedIndy(S(idx).idx);
    S(idx).features.internal_trigger = ...
        OD.wrapper.isFeatureSupportedInternalTrigger(S(idx).idx);
    S(idx).features.data_buffer = ...
        OD.wrapper.isFeatureSupportedDataBuffer(S(idx).idx)

end

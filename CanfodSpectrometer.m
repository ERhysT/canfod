classdef CanfodSpectrometer < handle

    properties 

        % Omnidriver

        wrapper                         % Omnidriver object
        id                              % Omnidriver spectrometer
                                        % id
        % Measurement Parameters

        integration_time                % ms
        boxcar_width                    % px either side of centre

        p                               % Parameter predicates
        
        % Measurement Data

        wavelengths;                    % nm
        spectrum;                       % a.u.
        

    end
    
    methods

        function CS = CanfodSpectrometer()
        % CanfodSpectrometer Object Constructor

            % Initialise omnidriver wrapper and select spectrometer

            [CS.wrapper, n] = canfodInit();
            models = canfodShowSpectrometers(CS.wrapper, n);
            CS.id = canfodSelectSpectrometer(CS.wrapper, n);

            %            CS.getIntegrationTime;
            CS.p.isIntegrationTimeSet = false;

            %            CS.getBoxCarWidth;
            CS.p.isBoxcarWidthSet = false;
            
            % canfodGUI();

        end

        function setIntegrationTime(CS, integration_time)

            CS.integration_time = integration_time;
            Cs.p.isIntegrationTimeSet = false;

        end
        
        function setBoxcarWidth(CS, boxcar_width)
            
            CS.boxcar_width = boxcar_width;
            CS.p.isBoxcarWidthSet = false;
            
        end
        
        function setCorrectForDetectorNonlinearity(CS)
            
            
            
        end
        
        % Omnidriver Commands

        function pushIntegrationTime(CS)
        % Set the integration time using the omnidriver
        % 
        % com.oceanoptics.omnidriver.api.wrapper.Wrapper
        % 
        % public void setIntegrationTime(int spectrometerIndex,
        %                                int channelIndex,
        %                                int usec)
        %                                
        %     Parameters:
        %         spectrometerIndex - (0-n) of desired spectrometer
        %         in our collection of attached spectrometers.
        %         
        %         channelIndex - (0-n) specifies which channel of a
        %         multichannel spectrometer to control.
        %         
        %         IMPORTANT NOTE: when you set the integration time
        %         for a channel on the ADC1000-USB, you are setting
        %         the integration time for all enabled channels on
        %         that device. The ADC1000-USB does not allow you
        %         to set different integration times for each
        %         channel.
        %         
        %         usec - units: microseconds
            
            CS.wrapper.setIntegrationTime(CS.id, 0, CS.integration_time);
            CS.p.isIntegrationTimeSet = true;

        end
        
        function pushBoxcarWidth(CS)
        % Set the boxcar width using the omnidriver
        % 
        % com.oceanoptics.omnidriver.api.wrapper.Wrapper
        % 
        %     public void setBoxcarWidth(int spectrometerIndex,
        %                        int channelIndex,
        %                        int numberOfPixelsOnEitherSideOfCenter)
        %
        % Parameters:
        %     spectrometerIndex - (0-n) of desired spectrometer in
        %     our collection of attached spectrometers.
        %
        %     channelIndex - (0-n) specifies which channel of a
        %     multichannel spectrometer to control.
        %
        %     numberOfPixelsOnEitherSideOfCenter - (default is 0)
        %     The number of pixels on either side of a given pixel
        %     to average together when obtaining a spectrum. For
        %     example, if you set this parameter to 2, each pixel
        %     of the acquired spectrum will be the result of
        %     averaging 5 pixels together, 2 on the left, 2 on the
        %     right, and the pixel itself. Set this value to 0 to
        %     avoid this "smoothing" mechanism.
            
            CS.wrapper.setBoxcarWidth(CS.id, 0, CS.boxcar_width);
            CS.p.isBoxcarWidthSet = true;    
            
        end

        
        function pushAllParameters(CS)
        % Push set parameters to omnidriver
            
            if ~CS.p.isIntegrationTimeSet
                CS.pushIntegrationTime
            end
            
            if ~CS.p.isBoxcarWidthSet
                CS.pushBoxcarWidth
            end

        end
        
        % Measurements

        function getMeasurement(CS)
            
            CS.spectrum = CS.wrapper.getSpectrum(CS.id);
            CS.wavelengths = CS.wrapper.getWavelengths(CS.id);

        end

        function getIntegrationTime(CS)
        % Get the currently set integration time
        %
        % public int getIntegrationTime(int spectrometerIndex,
        %                               int channelIndex)
        %
        %     Parameters:
        %         spectrometerIndex - (0-n) of desired spectrometer
        %         in our collection of attached spectrometers.
        %
        %         channelIndex - (0-n) specifies which channel of a
        %         multichannel spectrometer to control. 
        %
        %     Returns:
        %         current integration time setting, in units of microseconds.

            CS.integration_time = CS.wrapper.getIntegrationTime(CS.id, 0);

        end

        function getBoxCarWidth(CS)
        % Get the currently set boxcar width
        % 
        % com.oceanoptics.omnidriver.api.wrapper.Wrapper
        %
        % public int getBoxcarWidth(int spectrometerIndex,
        %                           int channelIndex)
        %
        % Parameters:
        %     spectrometerIndex - (0-n) of desired spectrometer in
        %     our collection of attached spectrometers.
        %
        %     channelIndex - (0-n) specifies which channel of a
        %     multichannel spectrometer to control.
            
            
            CS.boxcar_width = CS.wrapper.getBoxcarWidth(CS.id, 0);
            
        end
        

        % Test functions for use from command line

        function plotWavelengthSpectrum(CS)

            f = plot(CS.wavelengths, CS.spectrum);
                 
            xlabel('Wavelength (nm)');

        end
        
        function test(CS)
            
            CS.setIntegrationTime(100);
            CS.setBoxcarWidth(5);
            
            CS.pushAllParameters;
            
            CS.getMeasurement;
            CS.plotWavelengthSpectrum;
            
        end
    end
end

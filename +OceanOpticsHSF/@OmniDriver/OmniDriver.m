classdef OmniDriver < handle
    
    properties
        
        wrapper                         % Java object
        api_version
        build_number
        number_connected_spectrometers

    end

    methods        

        function OD = OmniDriver()
        % Constructor creates omnidriver Java Object and performs
        % basic initialisation of connected USB spectrometers.

            OD.wrapper = com.oceanoptics.omnidriver.api.wrapper.Wrapper();

            OD.api_version = OD.wrapper.getApiVersion();
            OD.build_number = OD.wrapper.getBuildNumber();

            OD.number_connected_spectrometers = ...
                OD.wrapper.openAllSpectrometers();
            
            % openAllSpectrometers() returns number of connected
            % spectrometers as a double. Returns -1 in error.
            
            if OD.number_connected_spectrometers == -1 || ...
                    ~isWholeNumber(OD.number_connected_spectrometers)

                error('Omnidriver I/O error');

            end

        end

        function status = checkUSBConnection()

            if OD.number_connected_spectrometers == ...
                    getNumberOfSpectrometersFound()
                
                status = true;
                
            else
                
                status = false;
            end
        end
    end
end


    



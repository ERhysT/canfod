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
            
            try

                OD.wrapper = com.oceanoptics.omnidriver.api.wrapper.Wrapper();
                
            catch
                
                error(['The OceanOptics Inc. OmniDriver was not detected as installed on this computer.Please install the OmniDriver. If the OmniDriver is installed, ensure that the Java archive (OmniDriver.jar) is in the MATLAB classpath. The OmniDriver can be added to the static path by editing $MATLABROOT/toolbox/local/classpath.txt and $MATLABROOT/toolbox/local/librarypath.txt. Alternatively, the OmniDriver can be installed on the dynamic path using the static method addOmniDriverToClasspath() from this class.']);

            end
            
            OD.api_version = OD.wrapper.getApiVersion();
            OD.build_number = OD.wrapper.getBuildNumber();

            OD.number_connected_spectrometers = ...
                OD.wrapper.openAllSpectrometers();
            
            % openAllSpectrometers() returns number of connected
            % spectrometers as a double. Returns -1 in error.
            
            if OD.number_connected_spectrometers == -1 || ...
                    ~isWholeNumber(OD.number_connected_spectrometers)

                error('OmniDriver I/O error');

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

    methods (Static = true)
        
        function addOmniDriverToClasspath()
        % Open gui dialoge for navigation to the OmniDriver Directory

            [file, path] = uigetfile('*.jar');
            
            if filename == 0            % close button pressed
                return
            end
            
            javaaddpath(strcat(path, file));
            
        end
    end
end


    



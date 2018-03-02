classdef HighSecurityFeature < handle
    
    properties (Access = ?Spectrometer)

        omniDriver OmniDriver                      % omnidriver Java wrapper
    
    end

    properties
        n_connected_spectrometers
        connected_spectrometer = struct('model', 'N/A', ...
                                        'serial_number', 0 ...
                                        'id_number', ...)
    end
    
    methods (Access = private)

        initialiseOmnidriver(HSF)

    end
    

    methods (Access = public)
        
        function HSF = HighSecurityFeature()
        % Constructor Method
            
            OD = OmniDriver();

            S = Spectrometer(OD);

        end
 
        function getSpectralMeasurement()
        % Make a spectrometer measurement at the required measurement parameters

            HSF.aquireSpectrometer();
            HSF.getUserSpectrometerParameters();
            HSF.setUserSpectromenterParameters();
            HSF.takeBackgroundMeasurement();
            HSF.takeHSFMeasurement();
            
        end
        
        function validateSpectralMeasurement()
        % Determine if a spectral measurement corresponds to a genuine article

            HSF.getSpectralTest();
            HSF.applySpectralTest();
            
        end
        
        function saveResults()

            convertSpectralObjectToText();
            getSpectralArchiveLocation();
            saveTextInArchive();
            
        end
        
        function loadResults()

            getSpectralArchiveLocation();
            importTextFile();
            convertTextToSpectralObject();
            loadSpectralObject();
            
        end

        function printResults()
            
            generateReportFromResults();
            printReport();
            
        end
        
        function delete()
            
            closeOpenFiles();
            disconnectOmnidriver();
            
        end

    end

   methods (Static = true)
       
       function addOmniDriverToClasspath()
       % Open dialoge for navigation to the OmniDriver Directory

       end
       
       function isOmniDriverInClasspath()
       % Check that OmniDriver.jar is in the class path
       end
           
   end
   

end
        
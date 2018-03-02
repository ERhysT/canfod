function [OD, S] = HighSecurityFeature()
    
    function validateSpectralMeasurement()
    % Determine if a spectral measurement corresponds to a genuine article

        getSpectralTest();
        applySpectralTest();
        
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
    
    function disconnect()
        
        closeOpenFiles();
        disconnectOmnidriver();
        
    end

    % Main

    OD = OmniDriver();

    S = Spectrometer(OD);

    aquireSpectrometer();
    getUserSpectrometerParameters();
    setUserSpectromenterParameters();
    takeBackgroundMeasurement();
    takeHSFMeasurement();

    disconnect

end

wrapper = canfodInit();
canfodSetParam(wrapper);
spectrum = canfodAquire(wrapper);
close all;

f = figure('Visiable', 'off','Position', [360,500,450,285]);

%plot(spectrum);
canfodClose(wrapper);
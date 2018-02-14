wrapper = canfodInit();
canfodSetParam(wrapper);
spectrum = canfodAquire(wrapper);
close all;
plot(spectrum);
canfodClose(wrapper);
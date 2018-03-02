[wrapper, n] = canfodInit();

[models] = canfodShowSpectrometers(wrapper, n);

[id] = canfodSelectSpectrometer(wrapper, n);

canfodSetParam(wrapper);



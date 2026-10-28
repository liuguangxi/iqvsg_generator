% Create a 1 MHz tone at 80 MS/s with 100,000 complex samples.
fs = 80e6;
count = 100000;
f_tone = 1e6;
n = (0:count-1).';
iq = exp(1j * 2*pi * f_tone * n / fs);

write_iqvsg('tone_1MHz.iqvsg', iq, fs);
disp('Created tone_1MHz.iqvsg');

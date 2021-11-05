function [psd_output] = PSD(psd_input)

FS=500;
dataPSD = psd_input;
nfft = 2^nextpow2(length(dataPSD));
Pxx = abs(fft(dataPSD,nfft)).^2/length(dataPSD)/FS;
psd_output = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',FS);  
end
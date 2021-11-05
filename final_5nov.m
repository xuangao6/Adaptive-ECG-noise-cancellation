% XUAN GAO MILLA EE4C03 ECG ADAPTIVE NOISE CANCELLING ASSIGNMENT

clc
clear all
load('ECG_database.mat')     % load data

% Clean ECG
figure
Data1 = Data1/200;
plot(Data1);
xlabel('Samples(n)');
ylabel('Amplitude(mV)'); ylim([-1 1]);
title('Clean ECG Signals');

WN_data = WN_data/200;
wn = wn/200;
BWN_data = BWN_data/200;
bwn = bwn/200;
EMN_data = EMN_data/200;
emn = emn/200;
MAN_data = MAN_data/200;
man = man/200;

datalength = 5000;
fs = 500;
fn = 50;
pli(:)=0;
for i=1:datalength
    pli(:,i) = 0.1*sin(2*pi*fn*i/fs);
end
PLI_data = (Data1 + pli);

%------------------------LMS ALGORITHM-------------------------
% Powerline Interference Noise
order =20;
beta = 0.01;
x = PLI_data;
x_ref = pli;
[y_pli_lms,wts_pli_lms,err_pli_lms] = LMS(x_ref,x,order,beta);
[PSD_PLI_lms] = PSD(err_pli_lms);
[PSD_PLI] = PSD(PLI_data);
%hold on
%plot(PSD_PLI_lms); legend ('LMS');
%figure
% hold on
%plot(Hpsd); legend ('PLI unfiltered');
% plot(PSD_PLI_lms); legend ('LMS');
%hold(PSD_PLI_lms,'on'); legend ('LMS');


% White Gaussian Noise
order =5;
beta = 0.01;
x = WN_data;
x_ref = wn;
[y_wn_lms,wts_wn_lms,err_wn_lms] = LMS(x_ref,x,order,beta);

% baseline wander noises
order =5;
beta = 0.02;
x = BWN_data;
x_ref = bwn;
[y_bwn_lms,wts_bwn_lms,err_bwn_lms] = LMS(x_ref,x,order,beta);

% electrode movement noise
order =12;
beta = 0.015;
x_ref = emn;
x = EMN_data;
[y_emn_lms,wts_emn_lms,err_emn_lms] = LMS(x_ref,x,order,beta);
 
% muscle artifacts
order =12;
beta = 0.2;
x_ref = man;
x = MAN_data;
[y_ma_lms,wts_ma_lms,err_ma_lms] = LMS(x_ref,x,order,beta);

%------------------------NLMS ALGORITHM------------------------
% Powerline Interference Noise
order =5;
beta = 0.002;
x = PLI_data;
x_ref = pli;
[y_pli_nlms,wts_pli_nlms,err_pli_nlms] = NLMS(x_ref,x,order,beta);
[PSD_PLI_nlms] = PSD(err_pli_nlms);

% White Gaussian Noise
order =5;
beta = 0.002;
x = WN_data;
x_ref = wn;
[y_wn_nlms,wts_wn_nlms,err_wn_nlms] = NLMS(x_ref,x,order,beta);

% baseline wander noises
order =5;
beta = 0.02;
x = BWN_data;
x_ref = bwn;
[y_bwn_nlms,wts_bwn_nlms,err_bwn_nlms] = NLMS(x_ref,x,order,beta);

% electrode movement noise
order =5;
beta = 0.02;
x_ref = emn;
x = EMN_data;
[y_emn_nlms,wts_emn_nlms,err_emn_nlms] = NLMS(x_ref,x,order,beta);

% muscle artifacts
order =12;
beta = 0.06;
x_ref = man;
x = MAN_data;
[y_ma_nlms,wts_ma_nlms,err_ma_nlms] = NLMS(x_ref,x,order,beta);

% ------------------------RLS ALGORITHM-------------------------
% Powerline Interference Noise
x = PLI_data;
x_ref = pli;
lambda = 0.9999;
order = 8;
[y_pli_rls,wts_pli_rls,err_pli_rls] = RLS(x_ref,x,order,lambda);
[PSD_PLI_rls] = PSD(err_pli_rls);

% White Gaussian Noise
x = WN_data;
x_ref = wn;
lambda = 0.9999;
order = 8;
[y_wn_rls,wts_wn_rls,err_wn_rls] = RLS(x_ref,x,order,lambda);

% baseline wander noises
x = BWN_data;
x_ref = bwn;
lambda = 0.99;
order = 8;
[y_bwn_rls,wts_bwn_rls,err_bwn_rls] = RLS(x_ref,x,order,lambda);

% electrode movement noise
x = EMN_data;
x_ref = emn;
lambda = 0.99;
order = 8;
[y_emn_rls,wts_emn_rls,err_emn_rls] = RLS(x_ref,x,order,lambda);

% muscle artifacts
x = MAN_data;
x_ref = man;
lambda = 0.99999999999999;
order = 1;
[y_ma_rls,wts_ma_rls,err_ma_rls] = RLS(x_ref,x,order,lambda);

%---------------------------SNR Calculation------------------%
% SNR
snr_pli_new_lms = snr(Data1, Data1-err_pli_lms');
snr_pli_new_nlms = snr(Data1, Data1-err_pli_nlms');
snr_pli_new_rls = snr(Data1, Data1-err_pli_rls');
snr_pli_old = snr(Data1, pli);
imp_snr_pli_lms = abs(snr_pli_old - snr_pli_new_lms);
imp_snr_pli_nlms = abs(snr_pli_old - snr_pli_new_nlms);
imp_snr_pli_rls = abs(snr_pli_old - snr_pli_new_rls) ;

snr_wn_new_lms = snr(Data1, Data1-err_wn_lms');
snr_wn_new_nlms = snr(Data1, Data1-err_wn_nlms');
snr_wn_new_rls = snr(Data1, Data1-err_wn_rls');
snr_wn_old = snr(Data1, wn);
imp_snr_wn_lms = abs(snr_wn_old - snr_wn_new_lms);
imp_snr_wn_nlms = abs(snr_wn_old - snr_wn_new_nlms);
imp_snr_wn_rls = abs(snr_wn_old - snr_wn_new_rls) ;
 
snr_bwn_new_lms = snr(Data1, Data1-err_bwn_lms');
snr_bwn_new_nlms = snr(Data1, Data1-err_bwn_nlms');
snr_bwn_new_rls = snr(Data1, Data1-err_bwn_rls');
snr_bwn_old = snr(Data1, bwn);
imp_snr_bwn_lms = abs(snr_bwn_old - snr_bwn_new_lms);
imp_snr_bwn_nlms = abs(snr_bwn_old - snr_bwn_new_nlms) ;
imp_snr_bwn_rls = abs(snr_bwn_old - snr_bwn_new_rls) ;
 
snr_emn_new_lms = snr(Data1, Data1-err_emn_lms');
snr_emn_new_nlms = snr(Data1, Data1-err_emn_nlms');
snr_emn_new_rls = snr(Data1, Data1-err_emn_rls');
snr_emn_old = snr(Data1, emn);
imp_snr_emn_lms = abs(snr_emn_old - snr_emn_new_lms);
imp_snr_emn_nlms = abs(snr_emn_old - snr_emn_new_nlms);
imp_snr_emn_rls = abs(snr_emn_old - snr_emn_new_rls);
 
snr_ma_new_lms = snr(Data1, Data1-err_ma_lms');
snr_ma_new_nlms = snr(Data1, Data1-err_ma_nlms');
snr_ma_new_rls = snr(Data1, Data1-err_ma_rls');
snr_ma_old = snr(Data1, man);
imp_snr_ma_lms = abs(snr_ma_old - snr_ma_new_lms);
imp_snr_ma_nlms = abs(snr_ma_old - snr_ma_new_nlms) ;
imp_snr_ma_rls = abs(snr_ma_old - snr_ma_new_rls) ;
 
% MSE
mse_pli_nlms = (1/5000)*sum((Data1-err_pli_nlms').^2);
mse_wn_nlms = (1/5000)*sum((Data1-err_wn_nlms').^2);
mse_bwn_nlms = (1/5000)*sum((Data1-err_bwn_nlms').^2);
mse_emn_nlms = (1/5000)*sum((Data1-err_emn_nlms').^2);
mse_ma_nlms = (1/5000)*sum((Data1-err_ma_nlms').^2);
 
mse_pli_lms = (1/5000)*sum((Data1-err_pli_lms').^2);
mse_wn_lms = (1/5000)*sum((Data1-err_wn_lms').^2);
mse_bwn_lms = (1/5000)*sum((Data1-err_bwn_lms').^2);
mse_emn_lms = (1/5000)*sum((Data1-err_emn_lms').^2);
mse_ma_lms = (1/5000)*sum((Data1-err_ma_lms').^2);
 
mse_pli_rls = (1/5000)*sum((Data1-err_pli_rls').^2);
mse_wn_rls = (1/5000)*sum((Data1-err_wn_rls').^2); 
mse_bwn_rls = (1/5000)*sum((Data1-err_bwn_rls').^2);
mse_emn_rls = (1/5000)*sum((Data1-err_emn_rls').^2);
mse_ma_rls = (1/5000)*sum((Data1-err_ma_rls').^2);

% PRD
prd_pli_nlms = sqrt((1/5000)*sum((Data1-err_pli_nlms').^2))*100;
prd_wn_nlms = sqrt((1/5000)*sum((Data1-err_wn_nlms').^2))*100;
prd_bwn_nlms = sqrt((1/5000)*sum((Data1-err_bwn_nlms').^2))*100;
prd_emn_nlms = sqrt((1/5000)*sum((Data1-err_emn_nlms').^2))*100;
prd_ma_nlms = sqrt((1/5000)*sum((Data1-err_ma_nlms').^2))*100;

prd_pli_lms = sqrt((1/5000)*sum((Data1-err_pli_lms').^2))*100;
prd_wn_lms = sqrt((1/5000)*sum((Data1-err_wn_lms').^2))*100;
prd_bwn_lms = sqrt((1/5000)*sum((Data1-err_bwn_lms').^2))*100;
prd_emn_lms = sqrt((1/5000)*sum((Data1-err_emn_lms').^2))*100;
prd_ma_lms = sqrt((1/5000)*sum((Data1-err_ma_lms').^2))*100;

prd_pli_rls = sqrt((1/5000)*sum((Data1-err_pli_rls').^2))*100;
prd_wn_rls = sqrt((1/5000)*sum((Data1-err_wn_rls').^2))*100;
prd_bwn_rls = sqrt((1/5000)*sum((Data1-err_bwn_rls').^2))*100;
prd_emn_rls = sqrt((1/5000)*sum((Data1-err_emn_rls').^2))*100;
prd_ma_rls = sqrt((1/5000)*sum((Data1-err_ma_rls').^2))*100;

%---------------------------PLOTS----------------------------%
figure
subplot(4,1,1); plot(PLI_data); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('Corrupted ECG Signal with Powerline Interference Noise');
subplot(4,1,2); plot(err_pli_lms); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('LMS Filter Output signal');
subplot(4,1,3); plot(err_pli_nlms); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('NLMS Filter Output signal');
subplot(4,1,4); plot(err_pli_rls); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('RLS Filter Output signal');

figure
subplot(4,1,1); plot(WN_data); ylim([-2 2]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('Corrupted ECG Signal with White Gaussian Noise');
subplot(4,1,2); plot(err_wn_lms); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('LMS Filter Output signal');
subplot(4,1,3); plot(err_wn_nlms); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('NLMS Filter Output signal');
subplot(4,1,4); plot(err_wn_rls); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('RLS Filter Output signal');

figure
subplot(4,1,1); plot(BWN_data); ylim([-3 3]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('Corrupted ECG Signal with Baseline Wander Noise');
subplot(4,1,2); plot(err_bwn_lms); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('LMS Filter Output signal');
subplot(4,1,3); plot(err_bwn_nlms); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('NLMS Filter Output signal');
subplot(4,1,4); plot(err_bwn_rls); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('RLS Filter Output signal');

figure
subplot(4,1,1); plot(EMN_data); ylim([-3 3]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('Corrupted ECG Signal with Electrode Movement Noise');
subplot(4,1,2); plot(err_emn_lms); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('LMS Filter Output signal');
subplot(4,1,3); plot(err_emn_nlms); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('NLMS Filter Output signal');
subplot(4,1,4); plot(err_emn_rls); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('RLS Filter Output signal');

figure
subplot(4,1,1); plot(MAN_data); ylim([-2 2]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('Corrupted ECG Signal with Muscle Artifacts Noise');
subplot(4,1,2); plot(err_ma_lms); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('LMS Filter Output signal');
subplot(4,1,3); plot(err_ma_nlms); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('NLMS Filter Output signal');
subplot(4,1,4); plot(err_ma_rls); ylim([-1 1]);
xlabel('Samples(n)');
ylabel('Amplitude(mV)');
title('RLS Filter Output signal');

figure
subplot(2,2,1);
plot(PSD_PLI); legend ('PLI unfiltered');
title('Power Spectrum Density of the PLI unfiltered signal');
subplot(2,2,2);
plot(PSD_PLI_lms); legend ('PLI filtered by LMS');
title('Power Spectrum Density of the PLI filtered signal by LMS');
subplot(2,2,3);
plot(PSD_PLI_nlms); legend ('PLI filtered by NLMS');
title('Power Spectrum Density of the PLI filtered signal by NLMS');
subplot(2,2,4);
plot(PSD_PLI_rls); legend ('PLI filtered by RLS');
title('Power Spectrum Density of the PLI filtered signal by RLS');


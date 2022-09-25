clc;
clear all;
close all;

%% OFDM

OFDM_high=load('OFDM_NOMA_high.mat');
OFDM_low=load('OFDM_NOMA_low.mat');

%% FBMC

FBMC_high=load('FBMC_NOMA_high.mat');
FBMC_low=load('FBMC_NOMA_low.mat');

%% UFMC

UFMC_high=load('UFMC_NOMA_high.mat');
UFMC_low=load('UFMC_NOMA_low.mat');

%% Performances

%High interferences
figure,
plot(OFDM_high.snr_dB,OFDM_high.c1NOMA,'b');
hold on
plot(OFDM_high.snr_dB,FBMC_high.c1NOMA,'r');
plot(OFDM_high.snr_dB,UFMC_high.c1NOMA,'k');
title('NOMA combined with waveforms: High Interferences');
xlabel('SINR [dB]');
ylabel('Capacity [bit/s/Hz]');
legend('OFDM','FBMC','UFMC');
grid on

%Low interferences
figure,
plot(OFDM_high.snr_dB,OFDM_low.c1NOMA,'b');
hold on
plot(OFDM_high.snr_dB,FBMC_low.c1NOMA,'r');
plot(OFDM_high.snr_dB,UFMC_low.c1NOMA,'k');
title('NOMA combined with waveforms: Low Interferences');
xlabel('SINR [dB]');
ylabel('Capacity [bit/s/Hz]');
legend('OFDM','FBMC','UFMC');
grid on
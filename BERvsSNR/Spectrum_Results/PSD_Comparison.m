clc;
clear all;
close all;

%% Parameters
Sampling_rate=15e3*14*14;
Subcarriers=12;
Subcarrier_spacing=15e3;
IntermediateSubcarrier=87;

%% Loading

OFDM = load('OFDM_Spectrum.mat');
FBMC = load('FBMC_Spectrum.mat');
UFMC = load('UFMC_Spectrum.mat');

%% Plot

% Normalize over energy
OFDM.PSD  = OFDM.PSD/(sum(OFDM.PSD)*Sampling_rate/length(OFDM.PSD));
FBMC.PSD  = FBMC.PSD/(sum(FBMC.PSD)*Sampling_rate/length(FBMC.PSD));
UFMC.PSD  = UFMC.PSD/(sum(UFMC.PSD)*Sampling_rate/length(UFMC.PSD));

% Normalize to 0dB
NormalizationFactor = max([FBMC.PSD]);
OFDM.PSD  = OFDM.PSD/NormalizationFactor;
FBMC.PSD  = FBMC.PSD/NormalizationFactor;
UFMC.PSD  = UFMC.PSD/NormalizationFactor;

figure(),
plot(OFDM.Normalized_frequency/Subcarrier_spacing-IntermediateSubcarrier-ceil(Subcarriers/2)+1/2,10*log10(OFDM.PSD),'r');
hold on,
plot(FBMC.Normalized_frequency/Subcarrier_spacing-IntermediateSubcarrier-ceil(Subcarriers/2)+1/2,10*log10(FBMC.PSD),'k');
plot(UFMC.Normalized_frequency/Subcarrier_spacing-IntermediateSubcarrier-ceil(Subcarriers/2)+1/2,10*log10(UFMC.PSD),'b');
ylim([-350 4]);
xlim([-50 50]);
xlabel('Normalized Frequency, f/F');
ylabel('Power Spectral Density [dB]');
title('Spectrum Comparison');
legend('OFDM','FBMC','UFMC');
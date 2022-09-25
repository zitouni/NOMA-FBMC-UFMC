clc;
clear all;
close all;

%% OFDM

% Rayleigh
OFDM_R1=load('OFDM_Calculation_Rayleigh_Velocity80_Modulation4QAM.mat');
OFDM_R2=load('OFDM_Calculation_Rayleigh_Velocity80_Modulation16QAM.mat');
OFDM_R1_Sim=load('OFDM_Simulation_Rayleigh_Velocity80_Modulation4QAM.mat');
OFDM_R2_Sim=load('OFDM_Simulation_Rayleigh_Velocity80_Modulation16QAM.mat');

% Nakagami
OFDM_N1=load('OFDM_Calculation_Nakagami_ShapeParameter10_Velocity80_Modulation4QAM.mat');
OFDM_N2=load('OFDM_Calculation_Nakagami_ShapeParameter10_Velocity80_Modulation16QAM.mat');
OFDM_N3=load('OFDM_Calculation_Nakagami_ShapeParameter0.5_Velocity80_Modulation4QAM.mat');
OFDM_N4=load('OFDM_Calculation_Nakagami_ShapeParameter0.5_Velocity80_Modulation16QAM.mat');

%% FBMC

% Rayleigh
FBMC_R1=load('FBMC_Calculation_Rayleigh_Velocity80_Modulation4QAM.mat');
FBMC_R2=load('FBMC_Calculation_Rayleigh_Velocity80_Modulation16QAM.mat');
FBMC_R1_Sim=load('FBMC_Simulation_Rayleigh_Velocity80_Modulation4QAM.mat');
FBMC_R2_Sim=load('FBMC_Simulation_Rayleigh_Velocity80_Modulation16QAM.mat');

% Nakagami
FBMC_N1=load('FBMC_Calculation_Nakagami_ShapeParameter10_Velocity80_Modulation4QAM.mat');
FBMC_N2=load('FBMC_Calculation_Nakagami_ShapeParameter10_Velocity80_Modulation16QAM.mat');
FBMC_N3=load('FBMC_Calculation_Nakagami_ShapeParameter0.5_Velocity80_Modulation4QAM.mat');
FBMC_N4=load('FBMC_Calculation_Nakagami_ShapeParameter0.5_Velocity80_Modulation16QAM.mat');
% FBMC_N1_Sim=load('FBMC_Simulation_Nakagami_ShapeParameter10_Velocity80_Modulation4QAM.mat');
% FBMC_N2_Sim=load('FBMC_Simulation_Nakagami_ShapeParameter10_Velocity80_Modulation16QAM.mat');
% FBMC_N3_Sim=load('FBMC_Simulation_Nakagami_ShapeParameter0.5_Velocity80_Modulation4QAM.mat');
% FBMC_N4_Sim=load('FBMC_Simulation_Nakagami_ShapeParameter0.5_Velocity80_Modulation16QAM.mat');

%% UFMC

% Rayleigh
UFMC_R1=load('UFMC_Calculation_Rayleigh_Velocity80_Modulation4QAM.mat');
UFMC_R2=load('UFMC_Calculation_Rayleigh_Velocity80_Modulation16QAM.mat');
UFMC_R1_Sim=load('UFMC_Simulation_Rayleigh_Velocity80_Modulation4QAM.mat');
UFMC_R2_Sim=load('UFMC_Simulation_Rayleigh_Velocity80_Modulation16QAM.mat');

% Nakagami
UFMC_N1=load('UFMC_Calculation_Nakagami_ShapeParameter10_Velocity80_Modulation4QAM.mat');
UFMC_N2=load('UFMC_Calculation_Nakagami_ShapeParameter10_Velocity80_Modulation16QAM.mat');
UFMC_N3=load('UFMC_Calculation_Nakagami_ShapeParameter0.5_Velocity80_Modulation4QAM.mat');
UFMC_N4=load('UFMC_Calculation_Nakagami_ShapeParameter0.5_Velocity80_Modulation16QAM.mat');


%% PLOT OFDM

%Flag figures
flagRayleighCalculation=0;
flagNakagamiCalculation=0;
flagRayleighCalcSim=0;
flagRayleighNakagamiShapeParametersCalculation4QAM=1;
flagRayleighNakagamiShapeParametersCalculation16QAM=0;

%Comparison Calculation
if flagRayleighCalculation
    figure,
    semilogy(OFDM_R1.snr_dB,OFDM_R1.BEP,'r');
    hold on
    semilogy(OFDM_R2.snr_dB,OFDM_R2.BEP,'b');
    axis([-6 30 1/1000 1]);
    grid on
    title('OFDM: Rayleigh model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('4-QAM','16-QAM');
end
if flagNakagamiCalculation
    figure,
    semilogy(OFDM_N1.snr_dB,OFDM_N1.BEP,'r');
    hold on
    semilogy(OFDM_N2.snr_dB,OFDM_N2.BEP,'b');
    axis([-6 30 1/1000 1]);
    grid on
    title('OFDM: Nakagami model: Velocity=80 Km/h : Shape Parameter=10')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('4-QAM','16-QAM');
end
%Comparison simulations
if flagRayleighCalcSim
    figure,
    semilogy(OFDM_R1.snr_dB,OFDM_R1.BEP,'r');
    hold on
    semilogy(OFDM_R1_Sim.snr_dB,OFDM_R1_Sim.meanBER,'o r');
    semilogy(OFDM_R2.snr_dB,OFDM_R2.BEP,'b');
    semilogy(OFDM_R2_Sim.snr_dB,OFDM_R2_Sim.meanBER,'o b');
    axis([-6 30 1/1000 1]);
    grid on
    title('OFDM: Rayleigh model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('4-QAM','4-QAM Simulation','16-QAM','16-QAM Simulation');
end
%Comparison Models
%Rayleigh-Nakagami(4QAM)
if flagRayleighNakagamiShapeParametersCalculation4QAM
    figure,
    semilogy(OFDM_R1.snr_dB,OFDM_R1.BEP,'r');
    hold on
    semilogy(OFDM_N1.snr_dB,OFDM_N1.BEP,'b');
    semilogy(OFDM_N3.snr_dB,OFDM_N3.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('OFDM: QPSK: Comparison Rayleigh and Nakagami models')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('Rayleigh','Nakagami.ShapeParameter=10','Nakagami.ShapeParameter=0.5');
end
%Rayleigh-Nakagami(16QAM)
if flagRayleighNakagamiShapeParametersCalculation16QAM
    figure,
    semilogy(OFDM_R2.snr_dB,OFDM_R2.BEP,'r');
    hold on
    semilogy(OFDM_N2.snr_dB,OFDM_N2.BEP,'b');
    semilogy(OFDM_N4.snr_dB,OFDM_N4.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('OFDM: 16QAM: Comparison Rayleigh and Nakagami models')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('Rayleigh','Nakagami.ShapeParameter=10','Nakagami.ShapeParameter=0.5');
end

%% PLOT FBMC

%Flag figures
flagRayleighCalculation=0;
flagNakagamiCalculation=0;
flagRayleighCalcSim=0;
flagRayleighNakagamiShapeParametersCalculation4QAM=0;
flagRayleighNakagamiShapeParametersCalculation16QAM=0;

%Comparison Calculation
if flagRayleighCalculation
    figure,
    semilogy(FBMC_R1.snr_dB,FBMC_R1.BEP,'r');
    hold on
    semilogy(FBMC_R2.snr_dB,FBMC_R2.BEP,'b');
    axis([-6 30 1/1000 1]);
    grid on
    title('FBMC: Rayleigh model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('4-QAM','16-QAM');
end
if flagNakagamiCalculation
    figure,
    semilogy(FBMC_N1.snr_dB,FBMC_N1.BEP,'r');
    hold on
    semilogy(FBMC_N2.snr_dB,FBMC_N2.BEP,'b');
    axis([-6 30 1/1000 1]);
    grid on
    title('FBMC: Nakagami model: Velocity=80 Km/h: Shape Parameter=10')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('4-QAM','16-QAM');
end
%Comparison Simulations
if flagRayleighCalcSim
    figure,
    semilogy(FBMC_R1.snr_dB,FBMC_R1.BEP,'r');
    hold on
    semilogy(FBMC_R1_Sim.snr_dB,FBMC_R1_Sim.meanBER,'o r');
    semilogy(FBMC_R2.snr_dB,FBMC_R2.BEP,'b');
    semilogy(FBMC_R2_Sim.snr_dB,FBMC_R2_Sim.meanBER,'o b');
    axis([-6 30 1/1000 1]);
    grid on
    title('FBMC: Rayleigh model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('4-QAM','4-QAM Simulation','16-QAM','16-QAM Simulation');
end
%Comparison Models
%Rayleigh-Nakagami(4QAM)
if flagRayleighNakagamiShapeParametersCalculation4QAM
    figure,
    semilogy(FBMC_R1.snr_dB,FBMC_R1.BEP,'r');
    hold on
    semilogy(FBMC_N1.snr_dB,FBMC_N1.BEP,'b');
    semilogy(FBMC_N3.snr_dB,FBMC_N3.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('FBMC: 4QAM: Comparison Rayleigh and Nakagami models')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('Rayleigh','Nakagami.ShapeParameter=10','Nakagami.ShapeParameter=0.5');
end
%Rayleigh-Nakagami(16QAM)
if flagRayleighNakagamiShapeParametersCalculation16QAM
    figure,
    semilogy(FBMC_R2.snr_dB,FBMC_R2.BEP,'r');
    hold on
    semilogy(FBMC_N2.snr_dB,FBMC_N2.BEP,'b');
    semilogy(FBMC_N4.snr_dB,FBMC_N4.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('FBMC: 16QAM: Comparison Rayleigh and Nakagami models')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('Rayleigh','Nakagami.ShapeParameter=10','Nakagami.ShapeParameter=0.5');
end

%% PLOT UFMC

%Flag figures
flagRayleighCalculation=0;
flagNakagamiCalculation=0;
flagRayleighCalcSim=0;
flagRayleighNakagamiShapeParametersCalculation4QAM=0;
flagRayleighNakagamiShapeParametersCalculation16QAM=0;

%Comparison Calculation
if flagRayleighCalculation
    figure,
    semilogy(UFMC_R1.snr_dB,UFMC_R1.BEP,'r');
    hold on
    semilogy(UFMC_R2.snr_dB,UFMC_R2.BEP,'b');
    axis([-6 30 1/1000 1]);
    grid on
    title('UFMC: Rayleigh model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('4-QAM','16-QAM');
end
if flagNakagamiCalculation
    figure,
    semilogy(UFMC_N1.snr_dB,UFMC_N1.BEP,'r');
    hold on
    semilogy(UFMC_N2.snr_dB,UFMC_N2.BEP,'b');
    axis([-6 30 1/1000 1]);
    grid on
    title('UFMC: Nakagami model: Velocity=80 Km/h: Shape parameter=10')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('4-QAM','16-QAM');
end
%Comparison Simulations
if flagRayleighCalcSim
    figure,
    semilogy(UFMC_R1.snr_dB,UFMC_R1.BEP,'r');
    hold on
    semilogy(UFMC_R1_Sim.snr_dB,UFMC_R1_Sim.meanBER,'o r');
    semilogy(UFMC_R2.snr_dB,UFMC_R2.BEP,'b');
    semilogy(UFMC_R2_Sim.snr_dB,UFMC_R2_Sim.meanBER,'o b');
    axis([-6 30 1/1000 1]);
    grid on
    title('UFMC: Rayleigh model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('4-QAM','4-QAM Simulation','16-QAM','16-QAM Simulation');
end
%Comparison Models
%Rayleigh-Nakagami(4QAM)
if flagRayleighNakagamiShapeParametersCalculation4QAM
    figure,
    semilogy(UFMC_R1.snr_dB,UFMC_R1.BEP,'r');
    hold on
    semilogy(UFMC_N1.snr_dB,UFMC_N1.BEP,'b');
    semilogy(UFMC_N3.snr_dB,UFMC_N3.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('UFMC: 4QAM: Comparison Rayleigh and Nakagami models')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('Rayleigh','Nakagami.ShapeParameter=10','Nakagami.ShapeParameter=0.5');
end
%Rayleigh-Nakagami(16QAM)
if flagRayleighNakagamiShapeParametersCalculation16QAM
    figure,
    semilogy(UFMC_R2.snr_dB,UFMC_R2.BEP,'r');
    hold on
    semilogy(UFMC_N2.snr_dB,UFMC_N2.BEP,'b');
    semilogy(UFMC_N4.snr_dB,UFMC_N4.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('UFMC: 16QAM: Comparison Rayleigh and Nakagami models')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('Rayleigh','Nakagami.ShapeParameter=10','Nakagami.ShapeParameter=0.5');
end

%% PLOT COMPARISON

%Flag figures
flagRayleigh4QAM=1;
flagNakagami4QAMShapeParameter05=1;
flagNakagami4QAMShapeParameter10=1;
flagRayleigh16QAM=1;
flagNakagami16QAMShapeParameter05=1;
flagNakagami16QAMShapeParameter10=1;

%Rayleigh 4QAM
if flagRayleigh4QAM
    figure,
    semilogy(OFDM_R1.snr_dB,OFDM_R1.BEP,'r');
    hold on
    semilogy(FBMC_R1.snr_dB,FBMC_R1.BEP,'b');
    semilogy(UFMC_R1.snr_dB,UFMC_R1.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('QPSK: Rayleigh model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('OFDM','FBMC','UFMC');
end

%Nakagami 4QAM-Shape parameter=0.5
if flagNakagami4QAMShapeParameter10
    figure,
    semilogy(OFDM_N3.snr_dB,OFDM_N3.BEP,'r');
    hold on
    semilogy(FBMC_N3.snr_dB,FBMC_N3.BEP,'b');
    semilogy(UFMC_N3.snr_dB,UFMC_N3.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('4QAM: Nakagami model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('OFDM.ShapeParameter=0.5','FBMC.ShapeParameter=0.5','UFMC.ShapeParameter=0.5');
end

%Nakagami 4QAM
if flagNakagami4QAMShapeParameter10
    figure,
    semilogy(OFDM_N1.snr_dB,OFDM_N1.BEP,'r');
    hold on
    semilogy(FBMC_N1.snr_dB,FBMC_N1.BEP,'b');
    semilogy(UFMC_N1.snr_dB,UFMC_N1.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('4QAM: Nakagami model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('OFDM.ShapeParameter=10','FBMC.ShapeParameter=10','UFMC.ShapeParameter=10');
end

%Rayleigh 16QAM
if flagRayleigh16QAM
    figure,
    semilogy(OFDM_R2.snr_dB,OFDM_R2.BEP,'r');
    hold on
    semilogy(FBMC_R2.snr_dB,FBMC_R2.BEP,'b');
    semilogy(UFMC_R2.snr_dB,UFMC_R2.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('16QAM: Rayleigh model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('OFDM','FBMC','UFMC');
end

%Nakagami 16QAM-Shape parameter=0.5
if flagNakagami16QAMShapeParameter05
    figure,
    semilogy(OFDM_N4.snr_dB,OFDM_N4.BEP,'r');
    hold on
    semilogy(FBMC_N4.snr_dB,FBMC_N4.BEP,'b');
    semilogy(UFMC_N4.snr_dB,UFMC_N4.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('16QAM: Nakagami model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('OFDM.ShapeParameter=0.5','FBMC.ShapeParameter=0.5','UFMC.ShapeParameter=0.5');
end

%Nakagami 16QAM-Shape parameter=10
if flagNakagami16QAMShapeParameter10
    figure,
    semilogy(OFDM_N2.snr_dB,OFDM_N2.BEP,'r');
    hold on
    semilogy(FBMC_N2.snr_dB,FBMC_N2.BEP,'b');
    semilogy(UFMC_N2.snr_dB,UFMC_N2.BEP,'k');
    axis([-6 30 1/1000 1]);
    grid on
    title('16QAM: Nakagami model: Velocity=80 Km/h')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('OFDM.ShapeParameter=10','FBMC.ShapeParameter=10','UFMC.ShapeParameter=10');
end
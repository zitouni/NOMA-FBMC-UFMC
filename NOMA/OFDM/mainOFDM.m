clc;
clear all;
close all;


%Modulation order
Mod=16;
[symmap,bitmap]=Constellation(Mod);
%OFDM object creation
str=OFDM();   
NSamples=str.NSamples;
%Matrices
G=TXMatrix(str);    %TX Matrix                                                        
Q=RXMatrix(str,G);  %RX Matrix
Q=Q';
NormFactor = sqrt(Q(:,1)'*Q(:,1));
G = G*NormFactor;
Q = Q/NormFactor;
%We are interested only on the middle position of the matrices
MidPosition = ceil(str.Subcarriers/2)+(str.Subcarriers)*(ceil(str.Symbols/2)-1);
qlk = Q(:,MidPosition);
glk = G(:,MidPosition);

%Time axis needed for the frequency shift of the other signals
t=[0:str.NSamples-1]*str.Sampling_time;
t=t';

%Simulation parameters
snr_dB=0:2:30;   %SNR vector
Pn_vector = 10.^(-snr_dB/10);
MonteCarlo=1000;
Spacing=12;     %Given in subcarrier

%Power domain Multiplexing
PowerLevel1=1;
PowerLevel2=4;
PowerLevel3=16;
Ptx1=sqrt(PowerLevel1);
Ptx2=sqrt(PowerLevel2);
Ptx3=sqrt(PowerLevel3);

%Simulation
for k=1:length(snr_dB)
    PSD = zeros(str.NSamples,1);
    PSD1 = zeros(str.NSamples,1);
    PSD2 = zeros(str.NSamples,1);
    PSD3 = zeros(str.NSamples,1);
    for rep=1:MonteCarlo
        
        %Transmitter
        %Bit stream
        stream1=randi([0 1],str.Subcarriers*str.Symbols*log2(Mod),1);
        stream2=randi([0 1],str.Subcarriers*str.Symbols*log2(Mod),1);
        stream3=randi([0 1],str.Subcarriers*str.Symbols*log2(Mod),1);
        %Symbol stream
        symbols1=Ptx1*Bit_to_Symbol(symmap,stream1,Mod);
        symbols2=Ptx2*Bit_to_Symbol(symmap,stream2,Mod);
        symbols3=Ptx3*Bit_to_Symbol(symmap,stream3,Mod);
        %Symbols are shaped like a LTE grid (12 subcarriersX14 OFDM symbols)
        LTEgrid1=reshape(symbols1,str.Subcarriers,str.Symbols);
        LTEgrid2=reshape(symbols2,str.Subcarriers,str.Symbols);
        LTEgrid3=reshape(symbols3,str.Subcarriers,str.Symbols);

        %Scatterplots
%         scatterplot(symbols1);
%         scatterplot(symbols2);
%         scatterplot(symbols3);
%         scatterplot(symbols1+symbols2+symbols3);
        
        %OFDM modulation
        s1=OFDMModulation(str,LTEgrid1)*NormFactor;
        s2=OFDMModulation(str,LTEgrid2)*NormFactor;
        s3=OFDMModulation(str,LTEgrid3)*NormFactor.*exp(1i*2*pi*str.Subcarrier_spacing*Spacing*t);
        s=s1+s2+s3; 
        
        %GetPSD
        PSD1  = PSD1  + abs(fftshift(ifft(s1))).^2;
        PSD2  = PSD2  + abs(fftshift(ifft(s2))).^2;
        PSD3  = PSD3  + abs(fftshift(ifft(s3))).^2;
        PSD = PSD + abs(fftshift(ifft(s))).^2; 

        %Channel model
        H=1;    %Perfect channel

        %Received signal without noise
        r_no=H*s;
        r_no1=H*s1;
        r_no2=H*s2;
        r_no3=H*s3;

        %Receiver
        %Simulate noise
        Pn = Pn_vector(k);
        n = sqrt(Pn/2)*(randn(NSamples,1)+1j*randn(NSamples,1));  

        %Add noise+equalization
        r=r_no/H+n;
        r1=r_no1/H+n;
        r2=r_no2/H+n;
        r3=r_no3/H+n;

        %Demodulation
        rx_LTEgrid3=OFDMDemodulation(str,r3)/NormFactor;
        rx_LTEgrid3_rs=reshape(rx_LTEgrid3,length(symbols3),1);
        %scatterplot(rx_LTEgrid3_rs);
        rx_LTEgrid2=OFDMDemodulation(str,r2)/NormFactor;
        rx_LTEgrid2_rs=reshape(rx_LTEgrid2,length(symbols2),1);
        %scatterplot(rx_LTEgrid2_rs);
        rx_LTEgrid_tot=OFDMDemodulation(str,r)/NormFactor;
        rx_LTEgrid1=rx_LTEgrid_tot-rx_LTEgrid3-rx_LTEgrid2;
        rx_LTEgrid1_rs=reshape(rx_LTEgrid1,length(symbols1),1);
        %scatterplot(rx_LTEgrid1_rs);
    end
    
    %Montecarlo normalization
    PSD  = PSD/MonteCarlo;
    PSD1  = PSD1/MonteCarlo;
    PSD2  = PSD2/MonteCarlo;
    PSD3  = PSD3/MonteCarlo;
    
    %INTERFERENCE COMPUTATION
    %X=1:length(PSD1);
    X=1042:1214;            %Indices of samples representing the frequency channel
    X1=1214:1386;
    P_int=trapz(X1,PSD3(1214:1386));
    P1=trapz(X,PSD1(1042:1214));
    P2=trapz(X,PSD2(1042:1214));
    P3=trapz(X,PSD3(1042:1214));
    

    frequency_OFDM = (3.60008e9*str.NSamples *str.Sampling_time-str.NSamples/2:3.60008e9*str.NSamples *str.Sampling_time+str.NSamples/2-1)/(str.NSamples *str.Sampling_time); 
    %Signal Bandwidth Computation
    b1=powerbw(PSD1, frequency_OFDM);
    b2=powerbw(PSD2, frequency_OFDM);
    b3=powerbw(PSD3, frequency_OFDM);
    b=2*b1; %2 is the number of NOMA users
    
    %Capacity SINR
    c1NOMA(k)=b*log2(1+P1/(Pn_vector(k)+P_int));
    c1OMA(k)=b1*log2(1+P1/(Pn_vector(k)+P_int));
    
end

%Save
saveFlag=0;
if saveFlag
    FileName = ['.\Results\OFDM_NOMA_low.mat'];
    save(FileName,...
          'snr_dB', ...
          'c1NOMA', ...
          'c1OMA');
end

%PSD plot
flagPSD=1;
if flagPSD
    figure,
    plot( frequency_OFDM /10e8 , 10*log10(PSD1) ,'b')
    %powerbw(PSD1, frequency_OFDM);
    hold on
    plot( frequency_OFDM/10e8  , 10*log10(PSD2) ,'r');
    plot( frequency_OFDM/10e8  , 10*log10(PSD3) ,'k');
    title('NOMA with OFDM waveforms');
    xlabel('Frequency [GHz]');
    ylabel('PSD [dB/Hz]');
    legend('Signal 1', 'Signal 2', 'Signal 3');
    axis([frequency_OFDM(1)/10e8 frequency_OFDM(length(frequency_OFDM/10e8))/10e8 -100 0]);
end

%NOMA vs. OMA
figure,
plot(snr_dB,c1NOMA,'b');
hold on
plot(snr_dB,c1OMA,'r');
title('NOMA vs. OMA');
xlabel('SNR [dB]');
ylabel('Capacity [bit/s/Hz]');
legend('NOMA','OMA');
grid on
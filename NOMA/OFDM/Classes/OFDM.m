classdef OFDM
    properties (SetAccess = private)
        
        %OFDM parameters
        Subcarriers
        Symbols
        Subcarrier_spacing
        Sampling_rate
        Sampling_time

        %Intermediate frequency
        IF   %*

        %Guard period
        ZeroGP_length
        ZeroGP

        %Cyclic prefix
        CP_length
        CP
        
        %Time spacing
        Time_spacing
        Physical_TS

        %FFT and samples
        NSamples
        FFT

        %Normalization Factor
        Norm
    end
    methods
        function OFDM_object = OFDM ()
%             ResourceGrid = LTEGrid();       %Data symbols
%             dim=size(ResourceGrid);
            OFDM_object.Sampling_rate=15e3*14*14;%OFDM_object.Subcarriers*OFDM_object.Symbols;
            OFDM_object.Subcarriers=12;     
            OFDM_object.Symbols=14;
            OFDM_object.Subcarrier_spacing=15*10^3;

            OFDM_object.Sampling_time=1/OFDM_object.Sampling_rate;

            %Intermediate frequency
            OFDM_object.IF=0;   %*

            %Guard period
            OFDM_object.ZeroGP_length=0;%0.000183333333333333;
            OFDM_object.ZeroGP=round(OFDM_object.ZeroGP_length*OFDM_object.Sampling_rate);      %Samples in Zero Guard Period

            %Cyclic prefix
            OFDM_object.CP_length=0;
            OFDM_object.CP=round(OFDM_object.CP_length*OFDM_object.Sampling_rate);      %Samples of cyclic prefix

            %Time spacing
            OFDM_object.Time_spacing=round(OFDM_object.Sampling_rate/OFDM_object.Subcarrier_spacing)+OFDM_object.CP;
            OFDM_object.Physical_TS=OFDM_object.Time_spacing*OFDM_object.Sampling_time;

            %FFT and samples
            OFDM_object.NSamples=OFDM_object.Symbols*OFDM_object.Time_spacing+2*OFDM_object.ZeroGP;
            OFDM_object.FFT=round(OFDM_object.Sampling_rate/OFDM_object.Subcarrier_spacing);        %How many samples per subcarrier

            %Normalization Factor
            OFDM_object.Norm=sqrt(OFDM_object.Sampling_rate^2/(OFDM_object.Subcarrier_spacing^2*OFDM_object.Subcarriers));
        end
    end
end
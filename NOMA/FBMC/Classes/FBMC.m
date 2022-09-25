classdef FBMC
    properties
        
        %FBMC parameters
        Subcarriers
        Symbols
        Subcarrier_spacing
        Sampling_rate
        Sampling_time
        
        %Intermediate frequency
        IF
        
        %Overlapping factor
        Overlapping_factor
        Frequency_spacing
                
        %Phase shift
        Phase_shift
        Initial_phase_shift
                
        %Time spacing
        Time_spacing
        Physical_TS
        
        %Prototype filter
        Prototype_filter_time
        Prototype_filter_frequency
        
        %Number of samples
        NSamples
        
        %Index after the IFFT
        IndPostIFFT
        
        %Normalization factor
        Norm
    end
    methods
        function FBMC_object = FBMC()
            
            %FBMC parameters
            FBMC_object.Subcarriers=12;
            FBMC_object.Symbols=14;
            FBMC_object.Subcarrier_spacing=15*10^3;
            FBMC_object.Sampling_rate=15e3*14*14;
            FBMC_object.Sampling_time=1/FBMC_object.Sampling_rate;
            
            %Intermediate frequency
            FBMC_object.IF=0;
            
            %Overlapping factor
            FBMC_object.Overlapping_factor=6;
            FBMC_object.Frequency_spacing = FBMC_object.Overlapping_factor;
            
            %Phase shift
            FBMC_object.Initial_phase_shift=0;
            [m,n]=meshgrid(0:FBMC_object.Symbols-1,0:FBMC_object.Subcarriers-1);         
            FBMC_object.Phase_shift = exp(1j*pi/2*(n+m))*exp(1j*FBMC_object.Initial_phase_shift);
            
            %Time spacing
            FBMC_object.Time_spacing= FBMC_object.Sampling_rate/(2*FBMC_object.Subcarrier_spacing); 
            FBMC_object.Physical_TS = FBMC_object.Time_spacing*FBMC_object.Sampling_time;
            
            %Prototype filter
            FBMC_object.Prototype_filter_time = PrototypeFilter_Hermite(FBMC_object.Physical_TS*2,FBMC_object.Sampling_time,FBMC_object.Overlapping_factor/2);     
            FBMC_object.Prototype_filter_frequency= FBMC_object.Sampling_time*real(fft(circshift(FBMC_object.Prototype_filter_time,length(FBMC_object.Prototype_filter_time)/2)));  
            FBMC_object.Prototype_filter_frequency(abs(FBMC_object.Prototype_filter_frequency)./FBMC_object.Prototype_filter_frequency(1)<10^-14)=0;    %Truncation of filter in frequency domain

            %Number of samples
            FBMC_object.NSamples = length(FBMC_object.Prototype_filter_time)+(FBMC_object.Symbols-1)*FBMC_object.Time_spacing;
            
            %Index after the IFFT
            IndPostIFFT =[ones(length(FBMC_object.Prototype_filter_time),FBMC_object.Symbols);zeros(FBMC_object.Time_spacing*(FBMC_object.Symbols-1),FBMC_object.Symbols)];
            for k = 1:FBMC_object.Symbols
               IndPostIFFT(:,k) = circshift(IndPostIFFT(:,k),(k-1)*FBMC_object.Time_spacing);
            end
            FBMC_object.IndPostIFFT = logical(IndPostIFFT);
            
            %Normalization factor
            FBMC_object.Norm = sqrt(FBMC_object.Sampling_rate^2/FBMC_object.Subcarrier_spacing^2*FBMC_object.Physical_TS/FBMC_object.Subcarriers);
        end
    end
end
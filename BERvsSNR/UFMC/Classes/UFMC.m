classdef UFMC
    properties (SetAccess = private)
        
        %UFMC parameters
        Subcarriers
        Subcarriers_per_subBlock_TX
        Subcarriers_per_subBlock_RX
        NSubBlocks_TX
        NSubBlocks_RX
        Symbols
        Subcarrier_spacing
        Sampling_rate
        Sampling_time
        
        %Intermediate frequency
        IF

        %Filters length
        Physical_filter_length_TX
        Physical_filter_length_RX
        Physical_filter_length_ZP
        Filter_length_TX
        Filter_length_RX
        Filter_length_ZP
        
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

        %Filter equalizer
        Filter_equalizer_TX
        Filter_equalizer_RX
        
        %Filter impulse response
        Filter_impulseResponse_TX
        Filter_impulseResponse_RX
        
        %Normalization Factor
        Norm
    end
    
    methods
        function UFMC_object = UFMC ()
            
            UFMC_object.Sampling_rate=15e3*14*14;%OFDM_object.Subcarriers*OFDM_object.Symbols;
            UFMC_object.Subcarriers=12;     
            UFMC_object.Symbols=14;
            UFMC_object.Subcarrier_spacing=15*10^3;
            UFMC_object.Sampling_time=1/UFMC_object.Sampling_rate;

            %Intermediate frequency
            UFMC_object.IF=0;
            
            %Filters length
            UFMC_object.Physical_filter_length_TX = 1/(14*15e3);  
            UFMC_object.Physical_filter_length_RX = 1/(14*15e3);  
            UFMC_object.Physical_filter_length_ZP = 1/(14*15e3); 

            UFMC_object.Filter_length_TX = round(UFMC_object.Physical_filter_length_TX *UFMC_object.Sampling_rate)+1;
            UFMC_object.Filter_length_RX = round(UFMC_object.Physical_filter_length_RX *UFMC_object.Sampling_rate)+1;
            UFMC_object.Filter_length_ZP = round(UFMC_object.Physical_filter_length_ZP*UFMC_object.Sampling_rate);
            
            UFMC_object.Physical_filter_length_TX = (UFMC_object.Filter_length_TX-1) *UFMC_object.Sampling_time ;
            UFMC_object.Physical_filter_length_RX = (UFMC_object.Filter_length_RX-1) *UFMC_object.Sampling_time;
            UFMC_object.Physical_filter_length_ZP = UFMC_object.Filter_length_ZP *UFMC_object.Sampling_time;
            
            %Guard period
            UFMC_object.ZeroGP_length=0;
            UFMC_object.ZeroGP=round(UFMC_object.ZeroGP_length*UFMC_object.Sampling_rate);      %Samples in Zero Guard Period

            %Cyclic prefix
            UFMC_object.CP_length=0;  
            UFMC_object.CP=round(UFMC_object.CP_length*UFMC_object.Sampling_rate);      %Samples of cyclic prefix

            %Time spacing
            UFMC_object.Time_spacing  = round(UFMC_object.Sampling_rate/UFMC_object.Subcarrier_spacing)+UFMC_object.CP+UFMC_object.Filter_length_ZP;     
            UFMC_object.Physical_TS = UFMC_object.Time_spacing*UFMC_object.Sampling_time;  

            %FFT and samples
            UFMC_object.NSamples=(UFMC_object.Symbols*UFMC_object.Time_spacing)+2*UFMC_object.ZeroGP+UFMC_object.Filter_length_TX-1;  
            UFMC_object.FFT=round(UFMC_object.Sampling_rate/UFMC_object.Subcarrier_spacing);        %How many samples per subcarrier

            %Normalization Factor
            UFMC_object.Norm=sqrt(UFMC_object.FFT^2/UFMC_object.Subcarriers);
            
            
            if mod(UFMC_object.FFT,2)==0
                Filter_TX_time = chebwin(UFMC_object.Filter_length_TX,60).*exp(1j*2*pi*(0:UFMC_object.Filter_length_TX-1).'/UFMC_object.FFT*0.5);
                Filter_RX_time = chebwin(UFMC_object.Filter_length_RX,60).*exp(1j*2*pi*(0:UFMC_object.Filter_length_RX-1).'/UFMC_object.FFT*0.5);
            else
                Filter_TX_time = chebwin(UFMC_object.Filter_length_TX,60);
                Filter_RX_time = chebwin(UFMC_object.Filter_length_RX,60);
            end
            
            Filter_TX_frequency = fft(Filter_TX_time,UFMC_object.FFT);
            Desired_subcarriers_per_subBlock_TX = sum(abs(Filter_TX_frequency)>0.88*max(abs(Filter_TX_frequency)));
            Filter_RX_frequency = fft(Filter_RX_time,UFMC_object.FFT);
            Desired_subcarriers_per_subBlock_RX = sum(abs(Filter_RX_frequency)>0.88*max(abs(Filter_RX_frequency)));            
 
            % Find a valid sub block length. That is, how many subcarriers
            % are used for the sub filtering
            FactorSubcarriers = factor(UFMC_object.Subcarriers);      
            Conversion_to_binary = dec2bin(0:(2^length(FactorSubcarriers))-1)-'0';
            RepmatFactor = repmat(FactorSubcarriers,size(Conversion_to_binary,1),1);
            RepmatFactor(Conversion_to_binary==0) = 1;
            SubBlock_sizes = unique(prod(RepmatFactor,2));
            
            [~,size1] = min(abs(SubBlock_sizes - Desired_subcarriers_per_subBlock_TX));
            UFMC_object.Subcarriers_per_subBlock_TX = SubBlock_sizes(size1);
            [~,size2] = min(abs(SubBlock_sizes - Desired_subcarriers_per_subBlock_RX));
            UFMC_object.Subcarriers_per_subBlock_RX = SubBlock_sizes(size2);           
                        
            % Final transmit filter per sub block
            UFMC_object.NSubBlocks_TX = ceil(UFMC_object.Subcarriers/UFMC_object.Subcarriers_per_subBlock_TX);
            Total_filter_TX = nan(UFMC_object.FFT,UFMC_object.NSubBlocks_TX);
            for k = 1:UFMC_object.NSubBlocks_TX
                Total_filter_TX(:,k) = ifft(circshift(Filter_TX_frequency,[ceil(UFMC_object.Subcarriers_per_subBlock_TX/2)-1+UFMC_object.IF+(k-1)*UFMC_object.Subcarriers_per_subBlock_TX 0]));
            end
            UFMC_object.Filter_impulseResponse_TX = Total_filter_TX(1:UFMC_object.Filter_length_TX,:);
            
            % Final receive filter per sub block
            UFMC_object.NSubBlocks_RX = ceil(UFMC_object.Subcarriers/UFMC_object.Subcarriers_per_subBlock_RX);
            Total_filter_RX = nan(UFMC_object.FFT,UFMC_object.NSubBlocks_RX);
            for k = 1:UFMC_object.NSubBlocks_RX
                Total_filter_RX(:,k) = ifft(circshift(Filter_RX_frequency,[ceil(UFMC_object.Subcarriers_per_subBlock_RX/2)-1+UFMC_object.IF+(k-1)*UFMC_object.Subcarriers_per_subBlock_RX 0]));
            end
            UFMC_object.Filter_impulseResponse_RX = Total_filter_RX(1:UFMC_object.Filter_length_RX,:);         
          

            % Consider only the first subblock, all others are the same
            FilterTransferFunctionTX = fft([UFMC_object.Filter_impulseResponse_TX(:,1);zeros(UFMC_object.FFT-UFMC_object.Filter_length_TX,1)]);
            FilterTransferFunctionRX = fft([UFMC_object.Filter_impulseResponse_RX(:,1);zeros(UFMC_object.FFT-UFMC_object.Filter_length_RX,1)]);
  
            UFMC_object.Filter_equalizer_TX = 1./FilterTransferFunctionTX(UFMC_object.IF+(1:UFMC_object.Subcarriers_per_subBlock_TX));
            UFMC_object.Filter_equalizer_RX  = 1./FilterTransferFunctionRX(UFMC_object.IF+(1:UFMC_object.Subcarriers_per_subBlock_RX));
            
            % Change normalization factor in order to account for the filter!
            TXMatrix1OFDMSymbolTemp = ifft(diag(circshift([UFMC_object.Filter_equalizer_TX;zeros(UFMC_object.FFT-UFMC_object.Subcarriers_per_subBlock_TX,1)],[UFMC_object.IF,0])))*UFMC_object.Norm;
            TXMatrix1OFDMSymbolTemp = conv2([0*TXMatrix1OFDMSymbolTemp(end-UFMC_object.CP-UFMC_object.Filter_length_ZP+1:end,:);TXMatrix1OFDMSymbolTemp],UFMC_object.Filter_impulseResponse_TX(:,1));
            FilterPowerNormalization = 1/(sum(sum(abs(TXMatrix1OFDMSymbolTemp).^2,2))/(UFMC_object.FFT+UFMC_object.CP+UFMC_object.Filter_length_ZP));
            UFMC_object.Norm = UFMC_object.Norm*sqrt(FilterPowerNormalization/UFMC_object.NSubBlocks_TX);
                   
        end
    end
end
 function Demodulated = UFMCDemodulation(UFMC_object, RXSignal)
    for k = 1: UFMC_object.NSubBlocks_RX
        SubblockIndices = (1:UFMC_object.Subcarriers_per_subBlock_RX)+(k-1)*UFMC_object.Subcarriers_per_subBlock_RX;

        RXSignal_PostFilter = conv(RXSignal,UFMC_object.Filter_impulseResponse_RX(:,k));
        FilterLengthMinusFilterCPHalf = max([floor((UFMC_object.Filter_length_TX+UFMC_object.Filter_length_RX-UFMC_object.Filter_length_ZP)/2)-1 0]);
        RXSignal_reshaped = reshape(RXSignal_PostFilter((UFMC_object.ZeroGP+1+FilterLengthMinusFilterCPHalf):(end-UFMC_object.ZeroGP-UFMC_object.Filter_length_TX-UFMC_object.Filter_length_RX+2+FilterLengthMinusFilterCPHalf)),UFMC_object.Time_spacing,UFMC_object.Symbols);        

            RXSignal_reshaped_beforeFFT = RXSignal_reshaped(ceil(UFMC_object.Filter_length_ZP/2)+UFMC_object.CP +(1:UFMC_object.FFT),:)+...
               [RXSignal_reshaped(end-floor(UFMC_object.Filter_length_ZP/2)+1:end,:);
                zeros(UFMC_object.FFT-UFMC_object.Filter_length_ZP-UFMC_object.CP,UFMC_object.Symbols);...
                RXSignal_reshaped(1:ceil(UFMC_object.Filter_length_ZP/2)+UFMC_object.CP,:)...
               ];
            RX_Temp = fft(circshift(RXSignal_reshaped_beforeFFT,[ceil(UFMC_object.Filter_length_ZP/2)+FilterLengthMinusFilterCPHalf+UFMC_object.CP 0]));

        Demodulated(SubblockIndices,:) = RX_Temp(UFMC_object.IF+SubblockIndices,:)/(UFMC_object.Norm).*repmat(UFMC_object.Filter_equalizer_RX,1,UFMC_object.Symbols);           
    end           
end
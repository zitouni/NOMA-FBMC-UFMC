function[OFDM_signal]=OFDMModulation(OFDM_object,resourceGrid)

    FFT_Matrix=zeros(OFDM_object.FFT,OFDM_object.Symbols);
    FFT_Matrix(OFDM_object.IF+(1:OFDM_object.Subcarriers),:) = resourceGrid*OFDM_object.Norm;
    OFDM_noCP=ifft(FFT_Matrix);
    OFDM_signal=[zeros(OFDM_object.ZeroGP,1); reshape([OFDM_noCP(end-OFDM_object.CP+1:end,:);OFDM_noCP],OFDM_object.Time_spacing*OFDM_object.Symbols,1);...
        zeros(OFDM_object.ZeroGP,1)];

end
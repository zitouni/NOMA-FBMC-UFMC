function[TX]=TXMatrix(OFDM_object)  %,res
    %Matrix_basic=res;
    Matrix_basic=zeros(OFDM_object.Subcarriers,OFDM_object.Symbols);
    for k=1:OFDM_object.Subcarriers
        Matrix_basic(k)=1;
        TX1(:,k)=OFDMModulation(OFDM_object,Matrix_basic);
        Matrix_basic(k)=0;
    end
    for k=1:OFDM_object.Symbols
        TX(:,(1:OFDM_object.Subcarriers)+(k-1)*OFDM_object.Subcarriers)=circshift(TX1,[(k-1)*OFDM_object.Time_spacing,0]);
    end
end
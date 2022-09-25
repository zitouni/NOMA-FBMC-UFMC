function[TX]=TXMatrix(FBMC_object)  %,res
    %Matrix_basic=res;
    Matrix_basic=zeros(FBMC_object.Subcarriers,FBMC_object.Symbols);
    for k=1:FBMC_object.Subcarriers
        Matrix_basic(k)=1;
        TX1(:,k)=FBMCModulation(FBMC_object,Matrix_basic);
        Matrix_basic(k)=0;
    end
    for k=1:FBMC_object.Symbols
        TX(:,(1:FBMC_object.Subcarriers)+(k-1)*FBMC_object.Subcarriers)=circshift(TX1,[(k-1)*FBMC_object.Time_spacing,0])*1j^(k-1);
    end
end
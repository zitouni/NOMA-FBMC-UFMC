function TX = TXMatrix(UFMC_object)            
    TX=zeros(UFMC_object.NSamples,UFMC_object.Subcarriers*UFMC_object.Symbols);
    TX1=zeros(UFMC_object.NSamples,UFMC_object.Subcarriers);
    Matrix_basic = zeros(UFMC_object.Subcarriers, UFMC_object.Symbols);
    for k= 1:UFMC_object.Subcarriers
        Matrix_basic(k)=1;
        TX1(:,k) = UFMCModulation(UFMC_object,Matrix_basic);
        Matrix_basic(k)=0;
    end
    for k=1:UFMC_object.Symbols
        TX(:,(1:UFMC_object.Subcarriers)+(k-1)*UFMC_object.Subcarriers)=circshift(TX1,[(k-1)*UFMC_object.Time_spacing,0]);
    end
end
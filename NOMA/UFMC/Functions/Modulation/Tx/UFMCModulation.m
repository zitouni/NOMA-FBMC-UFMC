function UFMC_Signal = UFMCModulation(UFMC_object,ResourceGrid)
            
            UFMC_Signal = zeros(UFMC_object.NSamples,UFMC_object.NSubBlocks_TX);
            for k = 1: UFMC_object.NSubBlocks_TX
                Data_Temp = zeros(UFMC_object.FFT,UFMC_object.Symbols);
                SubblockIndices = (1:UFMC_object.Subcarriers_per_subBlock_TX)+(k-1)*UFMC_object.Subcarriers_per_subBlock_TX;
                Data_Temp(UFMC_object.IF+SubblockIndices,:) =  bsxfun(@times,ResourceGrid(SubblockIndices,:),UFMC_object.Filter_equalizer_TX)*UFMC_object.Norm;
                UFMC_NoCP = ifft(Data_Temp);
                TX_Temp = [zeros(UFMC_object.ZeroGP,1);reshape([UFMC_NoCP;zeros(UFMC_object.Filter_length_ZP+UFMC_object.CP,UFMC_object.Symbols)],UFMC_object.Time_spacing*UFMC_object.Symbols,1);zeros(UFMC_object.ZeroGP,1)];                    
                UFMC_Signal(:,k) = conv(TX_Temp,UFMC_object.Filter_impulseResponse_TX(:,k));
            end
            UFMC_Signal = sum(UFMC_Signal,2);
end
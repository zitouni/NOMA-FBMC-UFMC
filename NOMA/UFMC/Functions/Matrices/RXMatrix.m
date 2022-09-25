function RX = RXMatrix(UFMC_object)           
    RX = zeros(UFMC_object.Subcarriers*UFMC_object.Symbols,UFMC_object.NSamples);
    for k = 1:UFMC_object.NSamples
        temp_signal = zeros(UFMC_object.NSamples,1);
        temp_signal(k) = 1;
        RX(:,k) = reshape(UFMCDemodulation(UFMC_object,temp_signal),[],1);
    end
end
  function Demodulated = FBMCDemodulation(FBMC_object,RXSignal)
  
     RXSignal_repeated = repmat(RXSignal,[1 FBMC_object.Symbols]);
     RXGrid = reshape(RXSignal_repeated(FBMC_object.IndPostIFFT),[length(FBMC_object.Prototype_filter_time) FBMC_object.Symbols]);
     FrequencyGeneration = zeros(size(FBMC_object.Prototype_filter_frequency,1),FBMC_object.Subcarriers);
     for k=1:FBMC_object.Subcarriers
         FrequencyGeneration(:,k) = circshift(FBMC_object.Prototype_filter_frequency,FBMC_object.Frequency_spacing*(k-1+FBMC_object.IF/FBMC_object.Subcarrier_spacing));
     end 
     FrequencyGeneration = FrequencyGeneration*sqrt(1/FBMC_object.Subcarriers*FBMC_object.Physical_TS)*FBMC_object.Sampling_rate;
     FrequencyDomain = fft(circshift(RXGrid,[length(FBMC_object.Prototype_filter_time)/2 0]));           
     Demodulated = (FrequencyGeneration'*FrequencyDomain).*conj(FBMC_object.Phase_shift)*(FBMC_object.Subcarriers*FBMC_object.Subcarrier_spacing)/(FBMC_object.Sampling_rate^2*FBMC_object.Physical_TS*FBMC_object.Frequency_spacing);

  end
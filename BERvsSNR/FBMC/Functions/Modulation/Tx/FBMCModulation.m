function FBMC_signal = FBMCModulation(FBMC_object,ResourceGrid)
                            
         FBMC_signal = zeros(size(FBMC_object.IndPostIFFT));      
         % Include also the design in the frequency domain because it provides a better understanding of FBMC, but is less efficient!
         SignalGeneration_inFrequency = zeros(size(FBMC_object.Prototype_filter_frequency,1),FBMC_object.Subcarriers);
         for k=1:FBMC_object.Subcarriers
             SignalGeneration_inFrequency(:,k) = circshift(FBMC_object.Prototype_filter_frequency,FBMC_object.Frequency_spacing*(k-1+FBMC_object.IF/FBMC_object.Subcarrier_spacing));
         end 
         SignalGeneration_inFrequency = SignalGeneration_inFrequency*sqrt(1/FBMC_object.Subcarriers*FBMC_object.Physical_TS)*FBMC_object.Sampling_rate;
         Signal_inFrequency = SignalGeneration_inFrequency*(ResourceGrid.*FBMC_object.Phase_shift);      
         FBMC_signal(FBMC_object.IndPostIFFT) = circshift(ifft(Signal_inFrequency),[-length(FBMC_object.Prototype_filter_time)/2 0]);
         FBMC_signal = sum(FBMC_signal,2);           
end
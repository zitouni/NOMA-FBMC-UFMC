function[RX]=RXMatrix(OFDM_object,TX)  %,res
    RX= TX'*(OFDM_object.Subcarriers*OFDM_object.Subcarrier_spacing/(OFDM_object.Sampling_rate));   
end
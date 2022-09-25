function[RX]=RXMatrix(FBMC_object,TX)  %,res
    RX = TX'*(FBMC_object.Subcarriers/(FBMC_object.Sampling_rate*FBMC_object.Physical_TS));   
end
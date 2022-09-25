function [Demodulated]=OFDMDemodulation(OFDM_object,RXSignal)
         RXSignal_Grid = reshape(RXSignal((OFDM_object.ZeroGP+1):(end-OFDM_object.ZeroGP)),OFDM_object.Time_spacing,OFDM_object.Symbols);
         RXSymbols = fft(RXSignal_Grid(OFDM_object.CP+1:end,:));
         Demodulated = RXSymbols(OFDM_object.IF+(1:OFDM_object.Subcarriers),:)/(OFDM_object.Norm);
end
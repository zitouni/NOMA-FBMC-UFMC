function BEP = BEP_DoublyFlat(snr_dB,SymbolMapping,BitMapping,DecisionRegions)
    BEP = nan(length(snr_dB),1);
    for k = 1:length(snr_dB)
        NoisePower = 10^(-snr_dB(k)/10);
        Prob_matrix = nan(size(SymbolMapping,1),size(SymbolMapping,1));
        for col = 1:size(SymbolMapping,1)
            symb = SymbolMapping(col);
            est_y2 = abs(symb).^2+NoisePower;
            est_h2 = 1;
            est_yh = symb;
            Prob_matrix(:,col)=Compute_rectangularRegionProb(est_y2,est_h2,est_yh,DecisionRegions(:,1),DecisionRegions(:,2),DecisionRegions(:,3),DecisionRegions(:,4));
        end 
        Error_prob = nan(2,size(BitMapping,2));
        for k_bit= 1:size(BitMapping,2)
            for binary_vec = [0 1]
                index_x = (BitMapping(:,k_bit)==binary_vec);
                Error_prob(binary_vec+1,k_bit) = mean(sum(Prob_matrix(not(index_x),index_x)));
            end   
        end
        BEP(k) = mean(mean(Error_prob));
    end
end

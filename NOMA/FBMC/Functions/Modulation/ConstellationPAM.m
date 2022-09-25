function [SymbolMapping,BitMapping]= ConstellationPAM(modOrder)   
    BitMapping = [ones(modOrder/2,1);zeros(modOrder/2,1)];
    for k = 2:log2(modOrder)
        temp = BitMapping(1:2:end,k-1);
        BitMapping(:,k) = [temp;temp(end:-1:1)];
    end
    SymbolMapping = (2*(1:modOrder)-modOrder-1).';
    SymbolMapping = SymbolMapping/sqrt(mean(abs(SymbolMapping).^2));
end
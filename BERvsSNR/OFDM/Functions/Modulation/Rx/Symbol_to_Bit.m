    function EstimatedBitStream = Symbol_to_Bit(SymbolMapping,BitMapping,EstimatedDataSymbols,ModulationOrder)

        EstimatedDataSymbols = EstimatedDataSymbols(:);
        
        % efficient for small modulation orders (<= 64)
        
        [~,b] =min(abs((repmat(EstimatedDataSymbols,1,ModulationOrder)-repmat((SymbolMapping).',size(EstimatedDataSymbols,1),1)).'));
        EstimatedBitStream = BitMapping(b(:),:).';
        EstimatedBitStream = EstimatedBitStream(:);         
    end
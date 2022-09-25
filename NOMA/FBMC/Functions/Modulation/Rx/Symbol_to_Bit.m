    function EstimatedBitStream = Symbol_to_Bit(SymbolMapping,BitMapping,EstimatedDataSymbols,ModulationOrder)

        EstimatedDataSymbols = EstimatedDataSymbols(:);
        
        % only efficient for small modulation orders, i.e., <= 64
        % maybe rewrite it
        [~,b] =min(abs((repmat(EstimatedDataSymbols,1,ModulationOrder)-repmat((SymbolMapping).',size(EstimatedDataSymbols,1),1)).'));
        EstimatedBitStream = BitMapping(b(:),:).';
        EstimatedBitStream = EstimatedBitStream(:);         
    end
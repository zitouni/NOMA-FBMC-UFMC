function Symbols = Bit_to_Symbol(Mapping,BitStream,ModulationOrder)
        Symbols = Mapping(bi2de(reshape(BitStream,log2(ModulationOrder),[])')+1);            
end
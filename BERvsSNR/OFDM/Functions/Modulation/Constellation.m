function [SymbolMapping,BitMapping]= Constellation(modOrder)

pattern=[zeros(sqrt(modOrder)/2,1);ones(sqrt(modOrder)/2,1)];
for k=2:log2(sqrt(modOrder))
    temp=pattern(1:2:end,k-1);
    pattern(:,k)=[temp;temp(end:-1:1)];
end
Symbol_vec=-sqrt(modOrder)+1:2:sqrt(modOrder);
[rows,columns]=meshgrid(Symbol_vec,Symbol_vec);
SymbolMapping=rows(:)+1i*columns(:);

BitMapping=false(modOrder,log2(modOrder));
for k =Symbol_vec
    BitMapping(rows(:)==k,2:2:end)=pattern;
    BitMapping(columns(:)==k,1:2:end)=pattern;
end

[~,order] = sort(bi2de(BitMapping));
BitMapping=BitMapping(order,:);
SymbolMapping=SymbolMapping(order);
SymbolMapping=SymbolMapping/sqrt(mean(abs(SymbolMapping).^2));
        
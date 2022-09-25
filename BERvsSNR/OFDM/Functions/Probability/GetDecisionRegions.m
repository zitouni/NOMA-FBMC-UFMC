function DecisionRegions = GetDecisionRegions(SymbolMapping)   

HalfDecisionInterval = min(abs(real(SymbolMapping)));
th_left=real(SymbolMapping)- HalfDecisionInterval;
th_right=real(SymbolMapping)+ HalfDecisionInterval;
th_down=imag(SymbolMapping)- HalfDecisionInterval;
th_up=imag(SymbolMapping)+ HalfDecisionInterval;
DecisionRegions = [th_left th_right th_down th_up];
min_left=min(th_left);
for k=1:length(DecisionRegions(:,1))
    if DecisionRegions(k,1)==min_left
        DecisionRegions(k,1)=-inf;
    end
end
max_right=max(th_right);
for k=1:length(DecisionRegions(:,2))
    if DecisionRegions(k,2)==max_right
        DecisionRegions(k,2)=+inf;
    end
end
min_down=min(th_down);
for k=1:length(DecisionRegions(:,3))
    if DecisionRegions(k,3)==min_down
        DecisionRegions(k,3)=-inf;
    end
end
max_up=max(th_up);
for k=1:length(DecisionRegions(:,4))
    if DecisionRegions(k,4)==max_up
        DecisionRegions(k,4)=+inf;
    end
end

end
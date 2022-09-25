function CorrelationMatrix =  GetCorrelationMatrix(channel_object,spectrum,ht,PDP_Normalized,NSamples)
  % Calculate the correlation matrix of the vectorized convolution matrix
  IndexTimeCorrelation = bsxfun(@plus,NSamples+(0:(NSamples-1)).',(0:-1:-(NSamples-1)));
  TimeCorrelation =  GetTimeCorrelation(channel_object,spectrum,NSamples);
  CorrelationMatrixOrdered = (...
    repmat(TimeCorrelation(IndexTimeCorrelation),[size(PDP_Normalized,1) 1]).*...
    kron(sparse(PDP_Normalized),ones(size(IndexTimeCorrelation))));
  IndexCorrMatrixConv = bsxfun(@plus,(1:(NSamples+1):NSamples^2).',(0:1:(size(ht,2)-1)));
  SplittingFactor = ceil(numel(IndexCorrMatrixConv)*NSamples*8/1e9);
  while mod(NSamples/SplittingFactor,1)
    SplittingFactor = SplittingFactor+1;
  end   
  if SplittingFactor>1
    CorrelationMatrix = sparse(NSamples^2+size(IndexCorrMatrixConv,2)-1,NSamples^2+size(IndexCorrMatrixConv,2)-1);
    Row = repmat(reshape(IndexCorrMatrixConv,[],1),NSamples/SplittingFactor,1);
    for i_split = 1:SplittingFactor
        Index1Temp = (1:NSamples/SplittingFactor)+(i_split-1)*NSamples/SplittingFactor;
        Index2Temp = (1:numel(CorrelationMatrixOrdered)/SplittingFactor)+(i_split-1)*numel(CorrelationMatrixOrdered)/SplittingFactor;

        Column = reshape(kron(IndexCorrMatrixConv(Index1Temp,:).',ones(size(IndexCorrMatrixConv,1),1)),[],1);
        CorrelationMatrix = CorrelationMatrix+...
           sparse(Row,Column,CorrelationMatrixOrdered(Index2Temp),...
           NSamples^2+size(IndexCorrMatrixConv,2)-1,...
           NSamples^2+size(IndexCorrMatrixConv,2)-1);
    end
  else
    CorrelationMatrix = sparse(...
    repmat(reshape(IndexCorrMatrixConv,[],1),NSamples,1),...
    reshape(kron(IndexCorrMatrixConv.',ones(size(IndexCorrMatrixConv,1),1)),[],1),...
    CorrelationMatrixOrdered(:));
  end  
  CorrelationMatrix = CorrelationMatrix(1:NSamples^2,1:NSamples^2);
end
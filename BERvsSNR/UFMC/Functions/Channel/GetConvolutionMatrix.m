function ConvolutionMatrix = GetConvolutionMatrix(h,PDP,NSamples)     

    NOnes = sum(NSamples:-1:(NSamples-length(PDP)+1));
    MappingConvolutionMatrix = nan(NOnes,2);
    for k = 1:length(PDP)
      MappingConvolutionMatrix(sum(NSamples:-1:NSamples-k+2)+(1:NSamples-k+1),:) = [-k+1+(k:NSamples).' (k:NSamples).'];        
    end      
    
    CancelElementsConvolutionMatrix = ones(size(h))==1;
    for k = 1:length((PDP)-1)
       CancelElementsConvolutionMatrix(k,(end-length(PDP)+1+k):end) = false;
    end
    
    ConvolutionMatrix = sparse(MappingConvolutionMatrix(:,2),MappingConvolutionMatrix(:,1),h(CancelElementsConvolutionMatrix),NSamples,NSamples);

end    
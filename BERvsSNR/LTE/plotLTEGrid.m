function [] = plotLTEGrid(resourceGrid)
    resourceGrid=resourceGrid(1:12,:);
    [nsub,nOFDM] = size(resourceGrid);
    plotGrid=zeros(nsub+1,nOFDM+1);
    plotGrid(1:nsub,1:nOFDM)=resourceGrid;
    figure,mesh(abs(plotGrid));
    xlabel('Number of symbols');
    ylabel('Number of subcarriers');
    view(2)
end
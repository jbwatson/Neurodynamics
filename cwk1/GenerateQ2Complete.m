function GenerateQ2Complete

    % Get all downsampled mean firing rates
    rates = DownsampledFiringRates();
    probTotal = zeros(1,20);
    complexityTotal = zeros(1,20);
    
    for i = 1:20
        
        modelRates = squeeze( rates( 1, :, : ) );

        model = load(['Q2Network-', int2str(i), '.mat']);
        
        probTotal(i) = model.layer{1}.prob;
        complexityTotal(i) = getComplexity(modelRates);
        
    end
    
    fig = figure;
    clf
    
    xlabel('Probability');
    ylabel('Complexity');
    title('Dynamically Complexity');
    
    scatter(probTotal,complexityTotal)
    
    drawnow
    
    saveas(fig, 'Q2.fig', 'fig');
        
end

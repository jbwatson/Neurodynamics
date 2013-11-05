function PlotMatricesQ1(prob)

load('Network.mat','layer');

ExToEx = layer{1}.S{1};
InToIn = layer{2}.S{2};
InToEx = layer{1}.S{2};
ExToIn = layer{2}.S{1};

SetColorMap();

fig = figure(1);
clf

subplot(2,2,1)
imagesc(ExToEx);
title('Excitatory to Excitatory');

subplot(2,2,2)
imagesc(ExToIn);
title('Excitatory to Inhibitory');

subplot(2,2,3)
imagesc(-InToEx);
title('Inhibitory to Excitatory');

subplot(2,2,4)
imagesc(-InToIn);
title('Inhibitory to Inhibitory');

drawnow

saveas(fig, ['Q1a-prob', num2str(prob), '.fig'], 'fig' );


end

function SetColorMap()

colorMap = zeros(64,3);
colorMap(1,:) = [1,1,1];

colormap(colorMap);
end


function PlotMatricesQ1()

load('Network.mat','layer');

ExToEx = layer{1}.S{1};
InToIn = layer{2}.S{2};
InToEx = layer{1}.S{2};
ExToIn = layer{2}.S{1};

SetColorMap();

figure(1)
clf

subplot(2,2,1)
imagesc(ExToEx);
title('Excitatory to Excitatory');

subplot(2,2,2)
imagesc(ExToIn);
title('Excitatory to Inhibitory');

subplot(2,2,3)
imagesc(InToEx);
title('Inhibitory to Excitatory');

subplot(2,2,4)
imagesc(InToIn);
title('Inhibitory to Inhibitory');

drawnow


end

function SetColorMap()

map = colormap(gray);

for i = 1:(length(map) / 2)
    temp = map(i,:);
    opposite = length(map) - i + 1;
    map(i,:) = map(opposite , :);
    map(opposite,:) = temp;    
end

colormap(map);

end


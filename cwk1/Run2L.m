function Run2L(prob)
% Simulates two layers (imported from saved file) of Izhikevich neurons


load('Network.mat','layer');

N1 = layer{1}.rows;
M1 = layer{1}.columns;

N2 = layer{2}.rows;
M2 = layer{2}.columns;

Dmax = 21; % maximum propagation delay

Tmax = 1000; % simulation time

Ib = 0; % base current


% Initialise layers
for lr=1:length(layer)
   layer{lr}.v = -65*ones(layer{lr}.rows,layer{lr}.columns);
   layer{lr}.u = layer{lr}.b.*layer{lr}.v;
   layer{lr}.firings = [];
end


% SIMULATE

for t = 1:Tmax
   
   % Display time every 50ms
   if mod(t,50) == 0
      t
   end
   
   % Deliver a constant base current to layer 1
   layer{1}.I = Ib*ones(N1,M1);
   layer{2}.I = zeros(N2,M2);
      
   % Update all the neurons
   for lr=1:length(layer)
      layer = IzNeuronUpdate(layer,lr,t,Dmax);
      randomFires = find(poissrnd(0.001, [1 layer{lr}.rows])>0);
      for item=1:length(randomFires)
          layer{lr}.firings = [layer{lr}.firings ; [t randomFires(item)]];
      end
   end
   
   v1(t,1:N1*M1) = layer{1}.v;
   v2(t,1:N2*M2) = layer{2}.v;
   
   u1(t,1:N1*M1) = layer{1}.u;
   u2(t,1:N2*M2) = layer{2}.u;
      
end


firings1 = layer{1}.firings;
firings2 = layer{2}.firings;

% Add Dirac pulses (mainly for presentation)
if ~isempty(firings1)
   v1(sub2ind(size(v1),firings1(:,1),firings1(:,2))) = 30;
end
if ~isempty(firings2)
   v2(sub2ind(size(v2),firings2(:,1),firings2(:,2))) = 30;
end



% Raster plots of firings

fig2 = figure(2);
clf

subplot(2,1,1)
if ~isempty(firings1)
   plot(firings1(:,1),firings1(:,2),'.')
end
% xlabel('Time (ms)')
xlim([0 Tmax])
ylabel('Neuron number')
ylim([0 N1*M1+1])
set(gca,'YDir','reverse')
title('Population 1 firings')

subplot(2,1,2)
if ~isempty(firings2)
   plot(firings2(:,1),firings2(:,2),'.')
end
xlabel('Time (ms)')
xlim([0 Tmax])
ylabel('Neuron number')
ylim([0 N2*M2+1])
set(gca,'YDir','reverse')
title('Population 2 firings')

% Mean firing rate plot
fig3 = figure(3);
clf
shiftSize = 20;
numShifts = 1000/shiftSize;
moduleTotals = zeros(8, numShifts);


for shift=0:(numShifts-1)
    for firing=1:length(firings1)
        offset = (shift*shiftSize) + 1;
        t = firings1(firing, 1);
        if ismember(t, offset:(offset + shiftSize))
           neuron = firings1(firing,2);
           moduleTotals(ceil(neuron/100), shift + 1) = moduleTotals(ceil(neuron/100), shift + 1) + 1;
        end
    end
end

for module=1:8
    plot(1:numShifts, moduleTotals((module-1)*numShifts+1 : module*numShifts))
    hold all
end
xlabel('Time (ms)')
set(gca, 'XTickLabel', [0:numShifts*2:1000]);
ylabel('Firings (Hz)')
title('Module mean firing rates')

drawnow

saveas(fig2, ['Q1b-prob', num2str(prob), '.fig'], 'fig');
saveas(fig3, ['Q1c-prob', num2str(prob), '.fig'], 'fig');





end
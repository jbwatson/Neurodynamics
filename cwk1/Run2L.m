function Run2L(prob,simTime)
% Simulates two layers (imported from saved file) of Izhikevich neurons


load('Network.mat','layer');

N1 = layer{1}.rows;
M1 = layer{1}.columns;

N2 = layer{2}.rows;
M2 = layer{2}.columns;

Dmax = 21; % maximum propagation delay

Tmax = simTime; % simulation time

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
windowSize = 50;
numShifts = simTime/shiftSize;
buckets = zeros(8, numShifts);

for b = 1:numShifts
    for f = 1:length(firings1)
        fire = firings1(f, 2);
        if (firings1(f) > (b-1)*shiftSize)
            if (firings1(f) <= (b-1)*shiftSize+windowSize)
                buckets(floor((fire-1)/100)+1, b) = buckets(floor((fire-1)/100)+1, b)+1;
            else
                break;
            end
        end
    end
end

for module=1:8
    for b = 1:numShifts
        buckets(module, b) = buckets(module, b)/windowSize;
    end
    plot(1:numShifts, buckets(module, :))
    hold all
   
end

xlabel('Time (ms)')
set(gca, 'XTickLabel', [0:numShifts*2:simTime]);
ylabel('Mean Firing Rate')
title('Module mean firing rates')

drawnow

saveas(fig2, ['Q1b-prob', num2str(prob), '.fig'], 'fig');
saveas(fig3, ['Q1c-prob', num2str(prob), '.fig'], 'fig');





end
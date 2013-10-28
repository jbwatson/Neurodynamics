function GenerateQ1Network( P )
% Generates network of Izhikevich neurons with 1 layer of excitatory
% and 1 layer of inhibitory neurons.

% Parameters
numModules = 8;
numNeuronPerModule = 100;
numConnectPerModule = 1000;

numExcitatory = numModules * numNeuronPerModule;
numInhibitory = 200;


% Start to build dtata structure for network (2x1 cell array)
% Labels
Excitatory = 1;
Inhibitory = 2;

Network{Excitatory}.rows = numExcitatory;
Network{Excitatory}.columns = 1;
Network{Inhibitory}.rows = numInhibitory;
Network{Inhibitory}.columns = 1;

% Build empty connectivity matrices
% layer{i}.S{j} is the connectivity matrix from layer j to layer i
% (same notation as IzNeuronUpdate)
numLayers = length (network);
for i=1:numLayers
   for j=1:numLayers
      Network{i}.S{j} = [];
   end
end

% TODO Exicitatory to Excitatory

% TODO Exicitatory to Inhibitory

% TODO Inhibitory to Excitatory

% TODO Inhibitory to Inhibitory






end


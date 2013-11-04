function GenerateQ1Network( P )

% Parameters
numExModules = 8;
numExPerModule = 100;
numExEdgesPerModule = 1000;
numExTotal = numExModules * numExPerModule;

numInModules = 1;
numInPerModule = 200;
numInTotal = numInPerModule * numInModules;

ExLayer = 1;
InLayer = 2;

% Excitatory to Excitatory

layer{ExLayer}.S{ExLayer} = zeros(numExTotal,numExTotal);
layer{ExLayer}.delay{ExLayer} = randi([0 20], numExTotal);
layer{ExLayer}.factor{ExLayer} = 17;

% For each module make 1000 random connections
for i = 0 : (numExModules - 1)   
    offset = i * numExPerModule;   
    j = 1;
    
    while j < numExEdgesPerModule       
       startNeuron = randi(numExPerModule); 
       endNeuron = randomNeuronExcl( startNeuron, numExPerModule );
       
       if layer{ExLayer}.S{ExLayer}( startNeuron+offset, endNeuron+offset) ~= 1
           layer{ExLayer}.S{ExLayer}( startNeuron+offset, endNeuron+offset) = 1;
           j = j+1;
       end          
    end
end

% For each connection, rewire if needed according to input probability
for i = 1 : numExTotal
    for j = 1 : numExTotal
        
       if layer{ExLayer}.S{ExLayer}(i, j) == 1; 
           
           if rand() < P
               layer{ExLayer}.S{ExLayer}(i, j) = 0;
               newModule = randomModuleExcl( mod( i, numExPerModule ), numExModules );
               newNeuron = randi( numExPerModule );
               layer{ExLayer}.S{ExLayer}(i, ((newModule*numExPerModule) + newNeuron) ) = 1;
           end  
       end
    end
end


% Excitatory to Inhibitory

layer{InLayer}.S{ExLayer} = zeros(numInTotal, numExTotal);
layer{InLayer}.delay{ExLayer} = ones(numInTotal, numExTotal);
layer{InLayer}.factor{ExLayer} = 50;

for i = 1 : numInTotal
   
    connections = zeros(4);
    randomModule = randi(numExModules) - 1;
   
    for j = 1 : 4      
        randNeuron = randi( numExPerModule );
        
        if j > 1
           res = ismember(randNeuron,connections);
           while res(1) == 1
                randNeuron = randi( numExPerModule );
                res = ismember(randNeuron,connections);
           end
        end
        connections(j) = randNeuron;
    end
    
    offset = randomModule * numExPerModule;  
    
    for k = 1 : 4 
        layer{InLayer}.S{ExLayer}( i, offset + connections(k) ) = rand();
    end
    
end

% Inhibitory to Excitatory
layer{ExLayer}.S{InLayer} = -1*rand(numExTotal, numInTotal);
layer{ExLayer}.delay{InLayer} = ones(numExTotal, numInTotal);
layer{ExLayer}.factor{InLayer} = 2;
    
% Inhibitory to Inhibitory
layer{InLayer}.S{InLayer} = -1*rand(numInTotal, numInTotal);
layer{InLayer}.delay{InLayer} = ones(numInTotal, numInTotal);
layer{InLayer}.factor{InLayer} = 1;

save('Network.mat','layer');

end

% Function generates random module between 0 and 7 excluding the input
% module
function randMod = randomModuleExcl( module, numModules )

randMod = module;

while randMod == module
    randMod = randi( numModules ) - 1;
end

end


% Generates a random neuron between 1 and numNeurons excluding currNeuron
function randNeuron = randomNeuronExcl( currNeuron, numNeurons )

randNeuron = currNeuron;

while randNeuron == currNeuron
    randNeuron = randi( numNeurons );
end

end


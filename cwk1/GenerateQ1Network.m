function ExToEx = GenerateQ1Network( P )

% Parameters
numExModules = 8;
numExPerModule = 100;
numExEdgesPerModule = 1000;
numExTotal = numExModules * numExPerModule;

numInModules = 1;
numInPerModule = 200;
numInTotal = numInPerModule * numInModules;

% Generate Connection Matrix for Excitatory->Excitatory connections

ExToEx = zeros(numExTotal,numExTotal);

% For each module make 1000 random connections
for i = 0 : (numExModules - 1)
    
    offset = i * numExPerModule;
    
    j = 1;
    
    while j < numExEdgesPerModule
        
       startNeuron = randi(numExPerModule); 
       endNeuron = randomNeuronExcl( startNeuron, numExPerModule );
       
       if ExToEx( startNeuron+offset, endNeuron+offset) ~= 1
           ExToEx( startNeuron+offset, endNeuron+offset) = 1;
           j = j+1;
       end     
       
    end
    
end

% For each connection, rewire if needed according to input probability
for i = 1 : numExTotal
    for j = 1 : numExTotal
        
       if ExToEx(i, j) == 1; 
           
           if rand() < P
               ExToEx(i, j) = 0;
               newModule = randomModuleExcl( mod( i, numExPerModule ), numExModules );
               newNeuron = randi( numExPerModule );
               ExToEx(i, ((newModule*numExPerModule) + newNeuron) ) = 1;
           end
           
       end
       
    end
end


% Excitatory to Inhibitory 

ExToIn = zeros(numExTotal, numInTotal);

for i = 1 : numInTotal
   
    connections = zeros(4);
    randomModule = randi(numExModules);
    
    for j = 1 : 4
       
        randNeuron = randi( numNeurons );
        
        if j > 1
           res = ismember(randNeuron,connections);
           while res(0) == 0
                randNeuron = randi( numNeurons );
                res = ismember(randNeuron,connections);
           end
        end
        connections(j) = randNeuron;
    end
    
    offset = (randomModule - 1) * numExPerModule;
    
    for k = 1 : 4
       
        ExToIn( offset + connections(k), i) = rand();
        
    end
    
end



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


function ExToEx = GenerateQ1Network( P )

% Parameters
numExModules = 8;
numExPerModule = 100;
numExEdgesPerModule = 1000;
numExTotal = numExModules * numExPerModule;

numInModules = 1;
numInPerModule = 200;


% Generate Connection Matrix for Excitatory->Excitatory connections

ExToEx = zeros(numExTotal,numExTotal);

% For each module make 1000 random connections
for i = 0 : (numExModules - 1)
    
    offset = i * numExPerModule;
    
    for j = 1 : 1000
       startNeuron = randi(numExPerModule); 
       endNeuron = randomNeuronExcl( startNeuron, numExPerModule );
       
       ExToEx( startNeuron+offset, endNeuron+offset) = 1;
       
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


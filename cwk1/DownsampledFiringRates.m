function rates = DownsampledFiringRates()

    shiftSize = 20;
    windowSize = 50;
    numShifts = 60000/shiftSize;
    buckets = zeros(8, numShifts);
    
    rates = zeros(20,8,3000);

    for i = 1:20
       
        i
        
        model = load(['Q2Network-', int2str(i), '.mat']);
           
        firings1 = model.layer{1}.firings;
        
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
            rates(i, module, :) = buckets(module, :);
            
        end
        
    end

end

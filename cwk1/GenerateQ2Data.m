function GenerateQ2Data()

for i = 1:20
   
    p = 0.1 + 0.4*rand();
    GenerateQ2Net(p, i);
    Run2LQ2(p, 60000, i);
    
    
end

end


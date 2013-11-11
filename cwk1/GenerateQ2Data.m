function GenerateQ2Data(i)

    p = 0.1 + 0.4*rand();
    GenerateQ2Net(p, i);
    Run2LQ2(p, 60000, i);

end


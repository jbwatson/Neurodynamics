function[val] = getComplexity(s)
s = aks_diff(aks_diff(s));
sEntropy = entropy(s);
MIs = [];
for i = 1:size(s,1)
    i
    
    ithElementOfS = s(:, i);
    
    %remove ith element
    if i > 1
        sNoX = s(1:i-1,:);
    else
        sNoX = [];
    end
    second = s(i+1:size(s, 1), :);
    sNoX = [sNoX; second];
    MIs = [MIs, getMI(ithElementOfS, sNoX, sEntropy)];
end
val = sum(MIs) - integration(s);

end

function[mi] = getMI(x, sNoX, sEntropy)

mi = entropy(x) + entropy(sNoX) - sEntropy;

end

function[int] = integration(s)

ents = [];
for i = 1:size(s)
    j=i
    ents = [ents, entropy(s(i))];
end

int = sum(ents)-entropy(s);

end

function[ret] = entropy(val)
tpe = (2*pi*exp(1));
s = size(val);
s1 = s(2)
lt = log(tpe)
cv = cov(val);
dcv = det(cv)
if dcv <= 0
    val
    val'
    %cv
end
ld = log(dcv)
ret = (s1*lt + ld)/2

end

function Kern =KernMask(dists,mask)

Kern = zeros(size(dists{1}));

for i=1:length(dists)
    for j = 1: length(dists{i})
        dists{i}(j,j) = 0;
    end

    Kern = Kern+dists{i}/mean(dists{i}(mask==1));
end

normKern=zeros(size(Kern));
normKern(mask==1) =normalize(Kern(mask==1));
Kern = exp(-15*normKern);
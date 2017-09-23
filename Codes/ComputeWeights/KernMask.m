function Kern =KernMask(dists,didx,mask)

Kern = zeros(size(dists{didx(1)}));




for i=didx
    for j = 1: length(dists{i})
        dists{i}(j,j) = 0;
    end

%     Kern = Kern+dists{i}/2;
    Kern = Kern+dists{i}/mean(dists{i}(mask==1));
end

normKern=zeros(size(Kern));
normKern(mask==1) =normalize(Kern(mask==1));
% Kern = exp(-15*normKern);
Kern = exp(-15*normKern);
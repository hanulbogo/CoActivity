function Kern =KernMaskidx(dists,didx,mask,allidx)
% dists{1} = dists{1}(allidx,allidx);
Kern = zeros(length(allidx),length(allidx));




for i=didx
    for j = 1: length(dists{i})
        dists{i}(j,j) = 0;
    end
    dists{i} = dists{i}(allidx,allidx);
%     Kern = Kern+dists{i}/2;
    Kern = Kern+dists{i}/mean(dists{i}(mask==1));
end

normKern=zeros(size(Kern));
normKern(mask==1) =normalize(Kern(mask==1));
Kern = exp(-15*normKern);
function Kern =PW_calc_Kern_from_dist_one_vid(dists,didx)

Kern = zeros(size(dists{didx(1)}));




for i=didx
    for j = 1: length(dists{i})
        dists{i}(j,j) = 0;
    end

%     Kern = Kern+dists{i}/2;
    Kern = Kern+dists{i}/mean(dists{i}(:));
end

normKern =reshape(normalize(Kern(:)), size(Kern));
Kern = exp(-15*normKern);

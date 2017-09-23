function Kern =PW_calc_Kern_from_dist_multi(dists)

Kern = zeros(size(dists{1}));
for i=1:5
    tmpdist= dists{i};
    m{i}=mean(tmpdist(:));
    Kern= Kern+(dists{i}/m{i});
%     Kern = Kern+dists{i};
end
% Kern=Kern/(mean(Kern(:))/5);
Kern = exp(-Kern);

% figure;
% imshow(Kern);

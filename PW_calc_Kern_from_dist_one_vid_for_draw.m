function Kern =PW_calc_Kern_from_dist_one_vid_for_draw(dists,didx)

Kern = zeros(size(dists{didx(1)}));




for i=didx
    for j = 1: length(dists{i})
        dists{i}(j,j) = 0;
    end

%      tmpdist= dists{i};
%      tmpdist(tmpdist==-1) = 0;
%      m=mean(tmpdist(:));
%      Kern= Kern+(tmpdist/m);
%     
%     dists{i}=(2-dists{i})/2;
% dists{i}=dists{i}/2;
% dists{i}(dists{i}>=0.5)=255;
%     dists{i}(dists{i}<=0.5) =0;
    Kern = Kern+dists{i};
end
% for i = 1: length(Kern)
%     Kern(i,i) = 0;
% end
% Kern=Kern/(mean(Kern(:))/5);
% Kern = exp((Kern/length(didx))*7);
% Kern = exp(-(Kern/length(didx))*30);
%  Kern = exp(-(Kern/length(didx))*20);
 Kern = exp(-(Kern/length(didx))*30);
 

% Kern = exp(-(Kern/length(didx))*20);
% Kern = 1-Kern/4000;
% Kern = exp(-(Kern/(length(didx)*2)));
%  Kern = exp(-Kern/(length(didx)/5));
% 
% figure;
% imshow(Kern);

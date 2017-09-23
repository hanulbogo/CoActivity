function th =otsu(density_map)
% close all;
densities=[];
for v=1:length(density_map)
    densities = [densities density_map{v}];
end
nbins =100;
historg =hist(densities,nbins);
historg=historg/sum(historg);

P1= cumsum(historg);
P2 = ones(size(P1))-P1;

ip =(0:1:nbins-1).*historg;

m = cumsum(ip);

mg = sum(ip);

varb = ((mg*P1 - m).^2)./(P1.*P2);
varb(logical((P1==0).*(P2==0)))=0;
[maxvalue th] = max(varb);



th = th-1;

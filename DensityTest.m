load('./densitytest.mat');
density_map1 = density_map;
load('./testdensity2.mat');
density_map2 = density_map;
for i=1:length(density_map)

    
        dif= density_map1{i}-density_map2{i};
        find(dif~=0)
        fprintf('%d %f \n',i,sum(dif));
    
end
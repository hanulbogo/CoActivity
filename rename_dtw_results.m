ppath ='./data/shortest_res/';

for class= 1:14
    for vi=1:25
        for vj=vi+1:25
            movefile([ppath,'res_',num2str(class),'_',num2str(vi),num2str(vj),'.mat'],[ppath,'res_',num2str(class),'_',num2str(vi),'_',num2str(vj),'.mat']);%,'maxitv1','maxitv2','minval');
        end
    end
end
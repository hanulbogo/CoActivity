function KDE_plot_denstiy_map_for_each_kern(nodesize, classlist, len)
load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
dpath ='./data/KDE_density_map/';
nVideos=50;
for d=1:6
    for class =classlist% kiss set has the best results
        lname =ucf_annotation{(class-1)*50+1}.label;
        dpath2 = [dpath, lname,'/',lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'/'];
        load([dpath2,num2str(d),'.mat'],'density_map');
        
        gt_start= zeros(nVideos,2);
        gt_end= zeros(nVideos,2);
        v_start= zeros(nVideos,1);
        v_end= zeros(nVideos,1);
        for v=1:nVideos
            aidx =(class-1)*nVideos+v;
            
            v_start(v)=1;
            v_end(v)= sum(ucf_annotation{aidx}.nFrames);
            
            gt_start(v,1) = ucf_annotation{aidx}.gt_start(1);
            gt_end(v,1)= ucf_annotation{aidx}.gt_end(1);
            gt_start(v,2) = ucf_annotation{aidx}.gt_start(2);
            gt_end(v,2)= ucf_annotation{aidx}.gt_end(2);
        end
        gt_cen = (gt_start+gt_end)/2;
        v_cen = (v_start+v_end)/2;
        h=figure;
        title(lname);
        hold on;
        errorbar((1:nVideos), v_cen,v_cen-v_start,v_end-v_cen,'k.');
        errorbar((1:nVideos), gt_cen(:,1),gt_cen(:,1)-gt_start(:,1),gt_end(:,1)-gt_cen(:,1),'b.','LineWidth',2);
        errorbar((1:nVideos), gt_cen(:,2),gt_cen(:,2)-gt_start(:,2),gt_end(:,2)-gt_cen(:,2),'b.','LineWidth',2);
        for v= (1: nVideos)
            plot(v+density_map{v}/2, v_start(v):v_end(v),'r-');
        end
        
        hold off;
        spath =['./data/density_img/',ucf_annotation{aidx}.label,'/'];
        if ~exist(spath,'dir')
            mkdir(spath);
        end
        print(h,'-dpdf',[spath,num2str(d),'.pdf']);
        close(h);
        
    end
end
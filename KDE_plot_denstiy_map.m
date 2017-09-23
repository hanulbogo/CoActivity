function KDE_plot_denstiy_map(nodesize, classlist, len)
load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
dpath ='./data/KDE_density_map/';
nVideos=50;

for class =classlist% kiss set has the best results
    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'.mat']); %density_map
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
    print(h,'-dpdf',['./data/density_img/',ucf_annotation{aidx}.label,'_floyd.pdf']);
%     close(h);
    
end
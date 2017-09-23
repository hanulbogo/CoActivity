function OFD_plot_denstiy_map_ofd2(nodesize, classlist, len,nCenter)
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
dpath ='./data/OFD_density_map/';
pdfpath ='./data/OFD_density_img/';
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end
nVideos=25;

for class =classlist% kiss set has the best results
    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenter),'_ofd_novariance.mat']); %density_map
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
        plot(v+density_map{v}(v_start(v):v_end(v))/2, v_start(v):v_end(v),'r-');
    end
    
    hold off;
%     print(h,'-dpdf',['./data/OFD_density_img/',lname,'_',num2str(nCenter),'_ofd.pdf']);
%     close(h);
    
end
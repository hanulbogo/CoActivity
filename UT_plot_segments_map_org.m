function UT_plot_segments_map_org(nodesize, classlist, len,nCenter,Threshold)
load('./data/UT_annotation.mat');%'UT_annotation'
dpath ='./data/UT_density_map/';
pdfpath ='./data/UT_density_img/';
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end
nVideos=10;

for class =classlist% kiss set has the best results
    lname =UT_annotation{(class-1)*nVideos+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_UT_',num2str(len),'_',num2str(nCenter),'_org.mat']); %density_map
    gt_start= zeros(nVideos,2);
    gt_end= zeros(nVideos,2);
    v_start= zeros(nVideos,1);
    v_end= zeros(nVideos,1);
    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        
        v_start(v)=1;
        v_end(v)= sum(UT_annotation{aidx}.nFrames);

        gt_start(v,1) = UT_annotation{aidx}.gt_start(1);
        gt_end(v,1)= UT_annotation{aidx}.gt_end(1);
     
    end
    gt_cen = (gt_start+gt_end)/2;
    v_cen = (v_start+v_end)/2;
    h=figure(1);
    title(lname);
    hold on;
    
    
%     errorbar((1:nVideos)+Threshold/2, v_cen,v_cen-v_start,v_end-v_cen,'k.');
    for v= (1: nVideos)
        seg= 1:length(density_map{v});
        pos_frames =seg(density_map{v}>=Threshold);
        if ~isempty(pos_frames)
            plot(v+0.25, pos_frames,'.','Color',[1 0 0.6],'MarkerSize',4);
        end
        plot(v, v_start(v):v_end(v),'k-','LineWidth',1);
            plot(v*ones(gt_end(v)-gt_start(v)+1,1), gt_start(v):gt_end(v),'b-','Color',[0 0 .6],'LineWidth',4);
    end
%     errorbar((1:nVideos), v_cen,v_cen-v_start,v_end-v_cen,'k.');
%     bar(v_end,0.01,'k');
%     errorbar((1:nVideos), gt_cen(:,1),gt_cen(:,1)-gt_start(:,1),gt_end(:,1)-gt_cen(:,1),'b.','LineWidth',2);
    
    hold off;
%     print(h,'-dpdf',['./data/UT_density_img/',lname,'_',num2str(nCenter),'_org.pdf']);
%     close(h);
    
end
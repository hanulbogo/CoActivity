function KDE_plot_denstiy_map_one_vid(nodesize, classlist, len,vididx)
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
dpath ='./data/KDE_density_map_one/';
nVideos=25;

for class =classlist% kiss set has the best results
    lname =ucf_annotation{(class-1)*25+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'.mat']);%,'density_map');
    gt_start= zeros(nVideos,2);
    gt_end= zeros(nVideos,2);
    v_start= zeros(nVideos,1);
    v_end= zeros(nVideos,1);
    for i=1:2
        v=vididx(i);
        aidx =(class-1)*nVideos+v;
        
        v_start(v)=1;
        v_end(v)= sum(ucf_annotation{aidx}.nFrames);

        for gti =1: ucf_annotation{aidx}.gt_n
            gt_start(v,gti) = ucf_annotation{aidx}.gt_start(gti);
            gt_end(v,gti)= ucf_annotation{aidx}.gt_end(gti);
        end
    end
    gt_cen = (gt_start+gt_end)/2;
    v_cen = (v_start+v_end)/2;
    h=figure;
    title(lname);
    hold on;
    errorbar(1:nVideos, v_cen,v_cen-v_start,v_end-v_cen,'k.');
    for gti =1: ucf_annotation{aidx}.gt_n
        errorbar(1:nVideos, gt_cen(:,gti),gt_cen(:,gti)-gt_start(:,gti),gt_end(:,gti)-gt_cen(:,gti),'b.','LineWidth',2);
    end
    
    for i= 1:2
        v=vididx(i);
        plot(v+density_map{v}/2, v_start(v):v_end(v),'r-');
    end
    
    hold off;
    dimgpath = './data/densiity_img_one/';
    if ~exist(dimgpath,'dir')
        mkdir(dimgpath);
    end
    print(h,'-dpdf',[dimgpath,ucf_annotation{aidx}.label,'_',num2str(vididx(1)),'_',num2str(vididx(2)),'.pdf']);
%     close(h);
    
end
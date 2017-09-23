function KDE_plot_denstiy_map_multi_vid(nodesize, classlist, len)
load('./data/ucf_multi_annotation.mat');%'ucf_annotation'
dpath ='./data/KDE_density_map_multi/';
nVideos=10;

for class =classlist% kiss set has the best results
    lname =ucf_annotation{(class-1)*10+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'.mat']); %density_map
    gt_start= zeros(nVideos,2);
    gt_end= zeros(nVideos,2);
    v_start= zeros(nVideos,1);
    v_end= zeros(nVideos,1);
    for v=1:nVideos
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
    errorbar((1:nVideos), v_cen,v_cen-v_start,v_end-v_cen,'k.');
    
    for v= (1: nVideos)
        aidx =(class-1)*nVideos+v;
        for gti =1: ucf_annotation{aidx}.gt_n
            errorbar(v, gt_cen(v,gti),gt_cen(v,gti)-gt_start(v,gti),gt_end(v,gti)-gt_cen(v,gti),'b.','LineWidth',2);
        end
        plot(v+density_map{v}/2, v_start(v):v_end(v),'r-');
    end
    
    hold off;
    dimgpath = './data/densiity_img_multi/';
    if ~exist(dimgpath,'dir')
        mkdir(dimgpath);
    end
       
    print(h,'-dpdf',[dimgpath,ucf_annotation{aidx}.label,'.pdf']);
%     close(h);
    
end
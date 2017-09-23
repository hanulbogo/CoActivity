function UT_plot_denstiy_map_org(density_map,nodesize, classlist, len,nCenter,Threshold)
load('./data/UT_annotation.mat');%'UT_annotation'
dpath ='./data/UT_density_map/';
pdfpath ='./data/UT_density_img/';
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end
load('./data/UT_nVideos.mat');%nVideolist

% sum(nVideolist(1:(class-1)))
nVideos=nVideolist(classlist);

for class =classlist% kiss set has the best results
    lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
    %     load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_UT_',num2str(len),'_',num2str(nCenter),'_org.mat']); %density_map
    gt_start= cell(nVideos,1);
    gt_end= cell(nVideos,1);
    gt_cen= cell(nVideos,1);
    v_start= zeros(nVideos,1);
    v_end= zeros(nVideos,1);
    for v=1:nVideos
        aidx =sum(nVideolist(1:(class-1)))+v;
        
        v_start(v)=1;
        v_end(v)= sum(UT_annotation{aidx}.nFrames);

        gt_start{v} = UT_annotation{aidx}.gt_start;
        gt_end{v}= UT_annotation{aidx}.gt_end;
        gt_cen{v} = (gt_start{v}+gt_end{v})/2;
    end
    
    v_cen = (v_start+v_end)/2;
    h=figure;
    title(lname);
    hold on;
    errorbar((1:nVideos), v_cen,v_cen-v_start,v_end-v_cen,'k.');
    for v= (1: nVideos)
        for gg= 1: length(gt_start{v})
            errorbar(v,gt_cen{v}(gg),gt_cen{v}(gg)-gt_start{v}(gg),gt_end{v}(gg)-gt_cen{v}(gg),'b.','LineWidth',2);
        end
    end
    errorbar((1:nVideos)+Threshold/2, v_cen,v_cen-v_start,v_end-v_cen,'k.');
    for v= (1: nVideos)
        plot(v+density_map{v}/2, v_start(v):v_end(v),'r-');
    end
    
    hold off;
    print(h,'-dpdf',['./data/UT_density_img/',lname,'_',num2str(nCenter),'_org.pdf']);
%     close(h);
    
end
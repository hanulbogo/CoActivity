function UT_plot_denstiy_map_ofd(nodesize, classlist, len,nCenter,Mpairs)
load('./data/UT_annotation.mat');%'UT_annotation'
dpath ='./data/UT_density_map/';
pdfpath ='./data/UT_density_img/';
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end
nVideos=10;

for class =classlist% kiss set has the best results
    lname =UT_annotation{(class-1)*nVideos+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_UT_',num2str(len),'_',num2str(nCenter),'_ofd.mat']); %density_map
    gt_start= zeros(nVideos,2);
    gt_end= zeros(nVideos,2);
    v_start= zeros(nVideos,1);
    v_end= zeros(nVideos,1);
    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        
        v_start(v)=1;
        v_end(v)= sum(UT_annotation{aidx}.nFrames);

        gt_start(v,1) = UT_annotation{aidx}.gt_start;
        gt_end(v,1)= UT_annotation{aidx}.gt_end;
        
    end
    gt_cen = (gt_start+gt_end)/2;
    v_cen = (v_start+v_end)/2;
    
    vidx=1;
%     for s = 1:length(Mpairs)
        
        h=figure;
        title(lname);
        hold on;
        errorbar((1:nVideos), v_cen,v_cen-v_start,v_end-v_cen,'k.');
        errorbar((1:nVideos), gt_cen(:,1),gt_cen(:,1)-gt_start(:,1),gt_end(:,1)-gt_cen(:,1),'b.','LineWidth',2);
        for v= (1: nVideos)
            plot(v+density_map{v}/2, v_start(v):v_end(v),'r-','LineWidth',2);
            plot(v+0.25, v_start(v):v_end(v),'g-','LineWidth',2);
        end
        
        for v=1:nVideos
            aidx =(class-1)*nVideos+v;
            nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
        end
        
        
        
%         startidx = sum(nnodes(1:vidx-1))+1;
%         endidx = sum(nnodes(1:vidx));
%         pos =((s-startidx+1)-1)*nodesize+len/2;
%         for v=1:nVideos
%             plot([vidx, v], [pos ((Mpairs(s,v,1)-1)*nodesize+len/2)],'b-');
%             plot([v v+Mpairs(s,v,2)],[((Mpairs(s,v,1)-1)*nodesize+len/2) ((Mpairs(s,v,1)-1)*nodesize+len/2)],'r-'); 
%         end
%         Mpairs(s,:,2)
%         if s==endidx
%             vidx=vidx+1;
%         end
%         ginput(1);
%         hold off;
%         close(h);
%     end
    
    
%     print(h,'-dpdf',['./data/UT_density_img/',lname,'_',num2str(nCenter),'_ofd.pdf']);
%     close(h);
    
end
function OFD_evaluate_per_frame_org(nodesize, classlist, len,nCenter)
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
dpath ='./data/OFD_density_map/';
pdfpath = './data/OFD_pr_curve_img/';
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end
nVideos=25;
nth=1001;

for class =classlist% kiss set has the best results
    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenter),'_org.mat']); %density_map
    gt_start= zeros(nVideos,2);
    gt_end= zeros(nVideos,2);
    v_start= zeros(nVideos,1);
    v_end= zeros(nVideos,1);
    tp=zeros(nth,1);
    precisiondenom=zeros(nth,1);
    recalldenom =0;
    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        
        v_start(v)=1;
        v_end(v)= sum(ucf_annotation{aidx}.nFrames);

        tmp =zeros(v_end(v),1);
        
        
        
        gt_start(v,1) = ucf_annotation{aidx}.gt_start(1);
        gt_end(v,1)= ucf_annotation{aidx}.gt_end(1);
        gt_start(v,2) = ucf_annotation{aidx}.gt_start(2);
        gt_end(v,2)= ucf_annotation{aidx}.gt_end(2);
        tmp(gt_start(v,1):gt_end(v,1))=1;
        tmp(gt_start(v,2):gt_end(v,2))=1;
        recalldenom = recalldenom+sum(tmp);
        for t=1:nth
            th = (t-1)*(1/(nth-1));
            
            tmp2=zeros(v_end(v),1);
            tmp2(density_map{v}>=th)=1;
            tp(t) = tp(t)+sum((tmp.*tmp2));
            precisiondenom(t) =precisiondenom(t) +sum(tmp2);
        end
    end
    precision =tp./precisiondenom;
    recall = tp./recalldenom;
    [sorted_recall recall_idx]=sort(recall);
    sorted_precision = precision(recall_idx);
    ap = sorted_recall(1)*sorted_precision(1);
    for t= 2:nth
        delta_r=sorted_recall(t)-sorted_recall(t-1);
        ap=ap+delta_r*sorted_precision(t);
    end
%     '.',num2str(floor(100*(ap*100-floor(ap*100))))]
    h=figure;
    title([lname ,' AP : ',num2str((ap*100),'%.2f')],'fontsize',20);
    hold on;
    set(h,'Position',[100,100,300,300]);
     set(gca,'XTick',0:0.2:1);
      set(gca,'YTick',0:0.2:1);
    axis([0 1 0 1],'square');
    xlhand = get(gca,'xlabel');
    set(xlhand,'string','Recall','fontsize',20);
    ylhand = get(gca,'ylabel');
    set(ylhand,'string','Precision','fontsize',20);
    [final_recall, final_precision] = PR_for_draw(sorted_recall, sorted_precision);
    plot(final_recall, final_precision,'r-','LineWidth',3);
%     print(h,'-dpdf',['./data/OFD_pr_curve_img/',lname,'_',num2str(nCenter),'_org.pdf']);
    hold off;
    fprintf('%f',ap*100);
%     close(h);
end
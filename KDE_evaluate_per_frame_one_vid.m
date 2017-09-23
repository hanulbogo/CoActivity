function KDE_evaluate_per_frame_one_vid(nodesize, classlist, len,vididx)
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
dpath ='./data/KDE_density_map_one/';

prpath = './data/pr_curve_img_one/';
if ~exist(prpath,'dir')
    mkdir(prpath);
end
prpath2 = './data/pr_res_one/';
if ~exist(prpath2,'dir')
    mkdir(prpath2);
end
nVideos=2;
nth=101;

for class =classlist% kiss set has the best results
    lname =ucf_annotation{(class-1)*25+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'.mat']);%,'density_map');
    gt_start= zeros(nVideos,2);
    gt_end= zeros(nVideos,2);
    v_start= zeros(nVideos,1);
    v_end= zeros(nVideos,1);
    tp=zeros(nth,1);
    precisiondenom=zeros(nth,1);
    recalldenom =0;
    for v=1:nVideos
        aidx =(class-1)*25+vididx(v);
        
        v_start(v)=1;
        v_end(v)= sum(ucf_annotation{aidx}.nFrames);

        tmp =zeros(v_end(v),1);
        
        
        
        for gti = 1: ucf_annotation{aidx}.gt_n
            gt_start(v,gti) = ucf_annotation{aidx}.gt_start(gti);
            gt_end(v,gti)= ucf_annotation{aidx}.gt_end(gti);
            tmp(gt_start(v,gti):gt_end(v,gti))=1;
        end
        
        recalldenom = recalldenom+sum(tmp);
        for t=1:nth
            th = (t-1)*(1/(nth-1));
            
            tmp2=zeros(v_end(v),1);
            tmp2(density_map{vididx(v)}>=th)=1;
            tp(t) = tp(t)+sum((tmp.*tmp2));
            precisiondenom(t) =precisiondenom(t) +sum(tmp2);
        end
    end
    precision =tp./precisiondenom;
    precision(isnan(precision))=0;
    recall = tp./recalldenom;
    [sorted_recall recall_idx]=sort(recall);
    sorted_precision = precision(recall_idx);
    ap = sorted_recall(1)*sorted_precision(1);
    for t= 2:nth
        delta_r=sorted_recall(t)-sorted_recall(t-1);
        ap=ap+delta_r*sorted_precision(t);
    end
    h=figure;
    title([lname,' AP : ',num2str(floor(ap*100))]);
    hold on;
    axis([0 1 0 1]);
    plot(recall, precision,'ro-');
    hold off;
    fprintf('%f , %f\n',ap*100, min(sorted_precision(sorted_recall==1))); 
    print(h,'-dpdf',[prpath,ucf_annotation{aidx}.label,'_',num2str(vididx(1)), '_',num2str(vididx(2)),'.pdf']);
%     close(h);
    save([prpath2, 'PR_',ucf_annotation{aidx}.label,'_',num2str(vididx(1)),'_',num2str(vididx(2)),'.mat'],'tp','precisiondenom','recalldenom','precision','recall');
end
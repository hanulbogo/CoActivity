function KDE_evaluate_per_frame_multi_vid(nodesize, classlist, len)
load('./data/ucf_multi_annotation.mat');%'ucf_annotation'
dpath ='./data/KDE_density_map_multi/';
prpath = './data/pr_curve_img_multi/';
if ~exist(prpath,'dir')
    mkdir(prpath);
end
prpath2 = './data/pr_res_multi/';
if ~exist(prpath2,'dir')
    mkdir(prpath2);
end
nVideos=10;
nth=101;

for class =classlist% kiss set has the best results
    lname =ucf_annotation{(class-1)*10+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'.mat']); %density_map
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
        
        
        for gti = 1: ucf_annotation{aidx}.gt_n
            gt_start(v,gti) = ucf_annotation{aidx}.gt_start(gti);
            gt_end(v,gti)= ucf_annotation{aidx}.gt_end(gti);
            tmp(gt_start(v,gti):gt_end(v,gti))=1;
        end

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
    print(h,'-dpdf',[prpath,ucf_annotation{aidx}.label,'.pdf']);
    close(h);
    save([prpath2, 'PR_',ucf_annotation{aidx}.label,'.mat'],'tp','precisiondenom','recalldenom','precision','recall');
end
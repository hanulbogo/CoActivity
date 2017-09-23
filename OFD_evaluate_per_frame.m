function OFD_evaluate_per_frame(nodesize, classlist, len)
load('./data/OFD_ucf50_annotation.mat');%'ucf_annotation'
dpath ='./data/OFD_density_map/';
nVideos=50;
nth=1001;

for class =classlist% kiss set has the best results
    lname =ucf_annotation{(class-1)*50+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'.mat']); %density_map
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
    h=figure;
    title([lname,' AP : ',num2str(floor(ap*100))]);
    hold on;
    axis([0 1 0 1]);
    plot(recall, precision,'ro-');
    hold off;
    print(h,'-dpdf',['./data/OFD_pr_curve_img/',ucf_annotation{aidx}.label,'.pdf']);
    
    fprintf('%f %f\n',ap*100,precision(recall_idx(end))*100);
%     close(h);
end
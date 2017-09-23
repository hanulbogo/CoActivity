function cumacc= OFD_evaluate_per_segments_ofd_find_best_th(nodesize,nVideos, classlist, len,nCenter,cumacc)
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
dpath ='./data/OFD_density_map/';
pdfpath = './data/OFD_pr_curve_img/';
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end

nth=1001;

for class =classlist% kiss set has the best results
    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenter),'_ofd.mat']); %density_map
    gt_start= zeros(nVideos,2);
    gt_end= zeros(nVideos,2);
    v_start= zeros(nVideos,1);
    v_end= zeros(nVideos,1);
    tp=zeros(nth,1);
    precisiondenom=zeros(nth,1);
    sumco=zeros(nth,1);
    sumuni=zeros(nth,1);
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
            
            uni_v = ones(1, v_end(v));
            uni_v(density_map{v}<th)=0;
            uni_v(gt_start(v,1):gt_end(v,1))=1;
            uni_v(gt_start(v,2):gt_end(v,2))=1;
            co_v = zeros(1,v_end(v));
            co_v(density_map{v}>=th)=1;
            co_v(gt_start(v,1):gt_end(v,1)) = co_v(gt_start(v,1):gt_end(v,1))+1;
            co_v(gt_start(v,2):gt_end(v,2)) = co_v(gt_start(v,2):gt_end(v,2))+1;
            co_v(co_v<2)=0;
            co_v(co_v>0)=1;
            sumco(t) =sumco(t)+sum(co_v);
            sumuni(t) = sumuni(t)+sum(uni_v);
        end
    end
    precision =tp./precisiondenom;
    recall = tp./recalldenom;
    segacc = sumco./sumuni;
    if max(segacc)>0.7
        cumacc= cumacc+segacc;
    end
    
%     th =otsu(density_map);
    
    fprintf('my acc : %.2f / %.2f',segacc(373), max(segacc));
%     fprintf('my acc : %f %.2f / %.2f',th,segacc(th), max(segacc));
    figure;
    plot(1:nth, segacc,'r*');
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
%     print(h,'-dpdf',['./data/UT_pr_curve_img/',lname,'_',num2str(nCenter),'_ofd.pdf']);
    
%     fprintf('%f %f ',ap*100,precision(recall_idx(end))*100);
%     close(h);
end
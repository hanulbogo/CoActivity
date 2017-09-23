function [lower_bound ap] =KDE_evaluate_per_frame_AP_for_each_kern(nodesize, classlist, len)
load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
dpath ='./data/KDE_density_map/';
nVideos=50;
nth=101;
for d=1:6
    for class =classlist% kiss set has the best results
        lname =ucf_annotation{(class-1)*50+1}.label;
        dpath2 = [dpath, lname,'/',lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'/'];
        load([dpath2,num2str(d),'.mat'],'density_map');
%         load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'.mat']); %density_map
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
        lower_bound = precision(1);
        recall = tp./recalldenom;
        [sorted_recall recall_idx]=sort(recall);
        sorted_precision = precision(recall_idx);
        ap(d) = sorted_recall(1)*sorted_precision(1);
        for t= 2:nth
            delta_r=sorted_recall(t)-sorted_recall(t-1);
            ap(d)=ap(d)+delta_r*sorted_precision(t);
        end
        %     ap = recall(1)*precision(1);
        %     for t= 2:nth
        %         delta_r=abs(recall(t)-recall(t-1));
        %         ap=ap+delta_r*precision(t);
        %     end
        h=figure;
        title([lname,' ',num2str(d),'th Kernel AP : ',num2str(floor(ap(d)*100)),'%']);
        hold on;
        axis([0 1 0 1]);
        plot(recall, precision,'ro-');
        hold off;
        spath =['./data/pr_curve_img/',lname,'/'];
        if ~exist(spath,'dir')
            mkdir(spath);
        end
        print(h,'-dpdf',[spath,num2str(d),'.pdf']);
        close(h);
        
    end
end
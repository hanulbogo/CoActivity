function KDE_evaluate_per_segments(nodesize, classlist, len)
load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
dpath ='./data/KDE_density_map/';
nVideos=50;
nth=101;

for class =classlist% kiss set has the best results
    lname =ucf_annotation{(class-1)*50+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'.mat']); %density_map
    gt_start= zeros(nVideos,2);
    gt_end= zeros(nVideos,2);
    v_start= zeros(nVideos,1);
    v_end= zeros(nVideos,1);
    tp=zeros(nth,1);
    precisiondenom=zeros(nth,1);
    recalldenom =0;
    densitysum=0;
    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        
        v_start(v)=1;
        v_end(v)= sum(ucf_annotation{aidx}.nFrames);

        tmp =zeros(v_end(v),ucf_annotation{aidx}.gt_n);
        for gti=1:ucf_annotation{aidx}.gt_n
            gt_start(v,gti) = ucf_annotation{aidx}.gt_start(gti);
            gt_end(v,gti)= ucf_annotation{aidx}.gt_end(gti);
            tmp(gt_start(v,gti):gt_end(v,gti),gti)=1;
        end
        recalldenom = recalldenom+ucf_annotation{aidx}.gt_n;
        
        densitysum =densitysum+sum(density_map{v});
        for t=1:nth
            th = (t-1)*(1/(nth-1));
            
            tmp2=zeros(v_end(v),1);
            
            tmp2(density_map{v}>=th)=1;
            CC = bwconncomp(tmp2);
            gt_list = 1:ucf_annotation{aidx}.gt_n;
            for c=1:CC.NumObjects
%                 component=CC.PixelIdxList{c};
                tmp3=zeros(v_end(v),1);
                tmp3(CC.PixelIdxList{c})=1;
                maxratio=0;
                maxidx=0;
                for gti = gt_list(gt_list~=0)
                    cup =tmp3+tmp(:,gti);
                    cup(cup>0)=1;
                    cap = tmp(:,gti).*tmp3;
                    ratio=sum(cap)/sum(cup);
                    if maxratio<ratio
                        maxratio=ratio;
                        if maxratio>=0.5
                            maxidx=gti;
                            gt_list(gti)=0;
                            break;
                        end
                    end
                end
                if maxidx~=0
                    tp(t)=tp(t)+1;
                end
                if sum(gt_list)==0
                    break;
                end
                
            end
%              tp(t) = tp(t)+sum((tmp.*tmp2));
            precisiondenom(t) =precisiondenom(t) +CC.NumObjects;
        end
    end
    precision =tp./precisiondenom;
    recall = tp./recalldenom;
    [sorted_recall recall_idx]=sort(recall);
    sorted_precision = precision(recall_idx);
    ap = sorted_recall(1)*sorted_precision(1);
    fprintf('Density sum : %f, Threshold :%d \n',densitysum, recall_idx(end));
    for t= 2:nth
        delta_r=sorted_recall(t)-sorted_recall(t-1);
        ap=ap+delta_r*sorted_precision(t);
    end
    h=figure;
    title([lname,' AP : ',num2str(floor(ap*100))]);
    hold on;
    axis([0 1 0 1]);
%     plot(sorted_recall, sorted_precision,'ro-');
    plot(recall, precision,'ro-');
    hold off;
    print(h,'-dpdf',['./data/pr_curve_img/',ucf_annotation{aidx}.label,'_nomask.pdf']);
%     close(h);
end
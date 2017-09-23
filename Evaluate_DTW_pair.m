function Evaluate_DTW_pair(classlist,nodesize)
nclass=14;
tp=zeros(nclass,1);
rec_denom= zeros(nclass,1);
cnt=0;
for class=classlist
    tp(class)=0;
    rec_denom(class)=0;
    for vi=1:25
        for vj=vi+1:25
            rec_denom(class)=rec_denom(class)+1;
            vidx=[vi,vj];
            nVideos=25;
            ppath ='./data/shortest_res/';
            load('./data/ucf_one_annotation.mat');%'ucf_annotation'
            for v=1:2
                gt_start(v)=ucf_annotation{(class-1)*nVideos+vidx(v)}.gt_start(1);
                gt_end(v)=ucf_annotation{(class-1)*nVideos+vidx(v)}.gt_end(1);
            end
            
            load([ppath,'res_',num2str(class),'_',num2str(vidx(1)),'_',num2str(vidx(2)),'_nodesize_',num2str(nodesize),'.mat']);
            
            
            gt_map = zeros(sum(ucf_annotation{(class-1)*nVideos+vidx(1)}.nFrames),sum(ucf_annotation{(class-1)*nVideos+vidx(2)}.nFrames));
            gt_map(gt_start(1):gt_end(1),gt_start(2):gt_end(2)) =1;
            %             figure;
            %             imshow(gt_map,[]);
            
            res_map = zeros(sum(ucf_annotation{(class-1)*nVideos+vidx(1)}.nFrames),sum(ucf_annotation{(class-1)*nVideos+vidx(2)}.nFrames));
            maxitv1(2)=min(size(res_map,1),maxitv1(2));
            maxitv2(2)=min(size(res_map,2),maxitv2(2));
            res_map(maxitv1(1):maxitv1(2),maxitv2(1):maxitv2(2))=1;
            %             figure;
            %             imshow(res_map,[]);
            predenorm = sum(res_map(:));
            inter_map = gt_map.*res_map;
            union_map = gt_map+res_map;
            union_map(union_map>0) = 1;
            %             figure;
            %             imshow(inter_map,[]);
            %             figure;
            %             imshow(union_map,[]);
            over_ratio = sum(inter_map(:))/sum(union_map(:));
            cnt=cnt+1;
            all_over_ratio(cnt)=over_ratio;
            prec = sum(inter_map(:))/predenorm;
            if over_ratio>=0.5
                tp(class)=tp(class)+1;
            end
            fprintf('Video %d, %d over_ratio : %f PRECISION %f\n',vi,vj,over_ratio,prec); 
            clear inter_map union_map;
        end
    end
    fprintf('Recall : %f\n',tp(class)/rec_denom(class));
    fprintf('Mean Overlapping ratio: %f\n',mean(all_over_ratio));
    
end

% 
% gt_itv1 =gt_start(1):gt_end(2);
% per_frame_recall_denom = length(gt_itv);
% 
% %% Over_itv
% over_itv =overstart:overend;
% over_inter = intersect(gt_itv,over_itv);
% over_union = union(gt_itv,over_itv);
% 
% over_ovratio =length(over_inter)/length(over_union);
% 
% over_per_frame_tp = length(over_inter);
% over_per_frame_precision_denom = length(over_itv);
% 
% over_per_frame_pre= over_per_frame_tp/over_per_frame_precision_denom ;
% over_per_frame_rec= over_per_frame_tp/per_frame_recall_denom ;
% 
% fprintf('Overlapping per_frame_precision : %f per_frame_recall : %f overlapping ratio: %f\n',over_per_frame_pre,over_per_frame_rec,over_ovratio)
% 
% save([rpath,'statistic_',num2str(class),num2str(vi),'_',num2str(vj),'.mat'],'over_per_frame_tp','over_per_frame_precision_denom','per_frame_recall_denom','over_ovratio');
% 
% 
% %%Non-over
% nonover_ovratio=zeros(szmax,1);
% nonover_per_frame_tp=zeros(szmax,1);
% nonover_per_frame_precision_denom=zeros(szmax,1);
% 
% for sz = 1:szmax
%     nonover_itv=nonoverstart(sz):nonoverend(sz);
%     nonover_inter = intersect(gt_itv,nonover_itv);
%     nonover_union = union(gt_itv,nonover_itv);
%     
%     nonover_ovratio(sz) =length(nonover_inter)/length(nonover_union);
%     
%     nonover_per_frame_tp(sz) = length(nonover_inter);
%     nonover_per_frame_precision_denom(sz) = length(nonover_itv);
%     
%     nonover_per_frame_pre= nonover_per_frame_tp(sz)/nonover_per_frame_precision_denom(sz) ;
%     nonover_per_frame_rec= nonover_per_frame_tp(sz)/per_frame_recall_denom ;
%     
%     %     fprintf('Non-Overlapping per_frame_precision : %f per_frame_recall : %f overlapping ratio: %f\n',nonover_per_frame_pre,nonover_per_frame_rec,nonover_ovratio(sz))
%     
% end
% save([rpath2,'statistic_',num2str(class),num2str(vi),'_',num2str(vj),'.mat'],'nonover_per_frame_tp','nonover_per_frame_precision_denom','per_frame_recall_denom','nonover_ovratio');
% 
% 
% %% BOW
% 
% bow_itv =bowstart:bowend;
% bow_inter = intersect(gt_itv,bow_itv);
% bow_union = union(gt_itv,bow_itv);
% 
% bow_ovratio =length(bow_inter)/length(bow_union);
% 
% bow_per_frame_tp = length(bow_inter);
% bow_per_frame_precision_denom = length(bow_itv);
% 
% bow_per_frame_pre= bow_per_frame_tp/bow_per_frame_precision_denom ;
% bow_per_frame_rec= bow_per_frame_tp/per_frame_recall_denom ;
% 
% fprintf('BOW per_frame_precision : %f per_frame_recall : %f overlapping ratio: %f\n',bow_per_frame_pre,bow_per_frame_rec,bow_ovratio)
% 
% save([rpath3,'statistic_',num2str(class),num2str(vi),'_',num2str(vj),'.mat'],'bow_per_frame_tp','bow_per_frame_precision_denom','per_frame_recall_denom','bow_ovratio');




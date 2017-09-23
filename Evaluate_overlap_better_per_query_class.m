function Evaluate_overlap_better_per_query_class(class,szmax)
nVideos=25;

load('./data/ucf_one_annotation.mat');%'ucf_annotation'

rpath ='./data/Overlap_res/';
rpath2 ='./data/NonOver_res/';
rpath3 = './data/BOW_res/';



for vi=1:25
    all_over_per_frame_tp =0;
    all_over_per_frame_precision_denom=0;
    all_per_frame_recall_denom=0;
    all_nonover_per_frame_tp=zeros(szmax,1);
    all_nonover_per_frame_precision_denom= zeros(szmax,1);
    all_bow_per_frame_tp=0;
    all_bow_per_frame_precision_denom=0;
    over_ov=zeros(10,1);
    nonover_ov=zeros(10,1);
    bow_ov =zeros(10,1);
    for vj=1:25
        
        load([rpath,'statistic_',num2str(class),num2str(vi),'_',num2str(vj),'.mat'],'over_per_frame_tp','over_per_frame_precision_denom','per_frame_recall_denom','over_ovratio');
        load([rpath2,'statistic_',num2str(class),num2str(vi),'_',num2str(vj),'.mat'],'nonover_per_frame_tp','nonover_per_frame_precision_denom','per_frame_recall_denom','nonover_ovratio');
        load([rpath3,'statistic_',num2str(class),num2str(vi),'_',num2str(vj),'.mat'],'bow_per_frame_tp','bow_per_frame_precision_denom','per_frame_recall_denom','bow_ovratio');
        
        all_over_per_frame_tp =all_over_per_frame_tp+over_per_frame_tp;
        all_over_per_frame_precision_denom=all_over_per_frame_precision_denom+over_per_frame_precision_denom;
        all_per_frame_recall_denom=all_per_frame_recall_denom+per_frame_recall_denom;
        
        
        all_nonover_per_frame_tp =all_nonover_per_frame_tp+nonover_per_frame_tp;
        all_nonover_per_frame_precision_denom=all_nonover_per_frame_precision_denom+nonover_per_frame_precision_denom;
        
        all_bow_per_frame_tp =all_bow_per_frame_tp+bow_per_frame_tp;
        all_bow_per_frame_precision_denom=all_bow_per_frame_precision_denom+bow_per_frame_precision_denom;
        
        for th=3:9
            if over_ovratio>th*0.1
                over_ov(th) = over_ov(th)+1;
            end
            if nonover_ovratio>th*0.1
                nonover_ov(th) = nonover_ov(th)+1;
            end
            if bow_ovratio>th*0.1
                bow_ov(th) = bow_ov(th)+1;
            end
        end
        
    end
    
    
    all_over_rec_per_frame =all_over_per_frame_tp/all_per_frame_recall_denom;
    all_over_pre_per_frame =all_over_per_frame_tp/all_over_per_frame_precision_denom;
    over_ov=over_ov/25;
    fprintf('Query Video %d\n',vi);
%     fprintf('Overlap Precision : %.2f Recall : %.2f\n', all_over_pre_per_frame*100,all_over_rec_per_frame*100);
    for th=5
        fprintf('Overlap Overlapping Ratio %.1f : %f\n',th*0.1,over_ov(th));
    end
    
    all_bow_rec_per_frame =all_bow_per_frame_tp/all_per_frame_recall_denom;
    all_bow_pre_per_frame =all_bow_per_frame_tp/all_bow_per_frame_precision_denom;
    bow_ov=bow_ov/25;
%     fprintf('BoW Precision : %.2f Recall : %.2f\n', all_bow_pre_per_frame*100, all_bow_rec_per_frame*100);
    
    for th=5
        fprintf('BoW Overlapping Ratio %.1f : %f\n',th*0.1,bow_ov(th));
    end

end

% 
% all_nonover_rec_per_frame =all_nonover_per_frame_tp/all_per_frame_recall_denom;
% all_nonover_pre_per_frame =all_nonover_per_frame_tp/all_nonover_per_frame_precision_denom;
% nonover_ov=nonover_ov/4;
% fprintf('Non-Overlap Precision : %.2f Recall : %.2f\n', all_nonover_rec_per_frame*100, all_nonover_pre_per_frame*100);
% for th=3:9
%     fprintf('Non-Overlap Overlapping Ratio %.1f : %f',th*0.1,nonover_ov(th));
% end


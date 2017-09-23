function Evaluate_overlap_better_per_pair(class,vi,vj,szmax )
nVideos=25;

load('./data/ucf_one_annotation.mat');%'ucf_annotation'
gt_start=ucf_annotation{(class-1)*nVideos+vj}.gt_start(1);
gt_end=ucf_annotation{(class-1)*nVideos+vj}.gt_end(1);

rpath ='./data/Overlap_res/';
rpath2 ='./data/NonOver_res/';
rpath3 = './data/BOW_res/';


load([rpath,num2str(class),'_',num2str(vi),'_',num2str(vj),'.mat']); %'overstart','overend'
% load([rpath2,num2str(class),'_',num2str(vi),'_',num2str(vj),'.mat']);%'nonoverstart','nonoverend'
load([rpath3,num2str(class),'_',num2str(vi),'_',num2str(vj),'.mat']);%'bowstart','bowend'

gt_itv =gt_start:gt_end;
per_frame_recall_denom = length(gt_itv);

%% Over_itv
over_itv =overstart:overend;
over_inter = intersect(gt_itv,over_itv);
over_union = union(gt_itv,over_itv);

over_ovratio =length(over_inter)/length(over_union);

over_per_frame_tp = length(over_inter);
over_per_frame_precision_denom = length(over_itv);

over_per_frame_pre= over_per_frame_tp/over_per_frame_precision_denom ;
over_per_frame_rec= over_per_frame_tp/per_frame_recall_denom ;

fprintf('Overlapping per_frame_precision : %f per_frame_recall : %f overlapping ratio: %f\n',over_per_frame_pre,over_per_frame_rec,over_ovratio)

save([rpath,'statistic_',num2str(class),num2str(vi),'_',num2str(vj),'.mat'],'over_per_frame_tp','over_per_frame_precision_denom','per_frame_recall_denom','over_ovratio'); 


%%Non-over
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
% %     fprintf('Non-Overlapping per_frame_precision : %f per_frame_recall : %f overlapping ratio: %f\n',nonover_per_frame_pre,nonover_per_frame_rec,nonover_ovratio(sz))
%     
% end
% save([rpath2,'statistic_',num2str(class),num2str(vi),'_',num2str(vj),'.mat'],'nonover_per_frame_tp','nonover_per_frame_precision_denom','per_frame_recall_denom','nonover_ovratio');


%% BOW

bow_itv =bowstart:bowend;
bow_inter = intersect(gt_itv,bow_itv);
bow_union = union(gt_itv,bow_itv);

bow_ovratio =length(bow_inter)/length(bow_union);

bow_per_frame_tp = length(bow_inter);
bow_per_frame_precision_denom = length(bow_itv);

bow_per_frame_pre= bow_per_frame_tp/bow_per_frame_precision_denom ;
bow_per_frame_rec= bow_per_frame_tp/per_frame_recall_denom ;

fprintf('BOW per_frame_precision : %f per_frame_recall : %f overlapping ratio: %f\n',bow_per_frame_pre,bow_per_frame_rec,bow_ovratio)

save([rpath3,'statistic_',num2str(class),num2str(vi),'_',num2str(vj),'.mat'],'bow_per_frame_tp','bow_per_frame_precision_denom','per_frame_recall_denom','bow_ovratio'); 




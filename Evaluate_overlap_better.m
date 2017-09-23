function Evaluate_overlap_better(class,vi,vj,szmax)
nVideos=25;
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
gt_start=ucf_annotation{(class-1)*nVideos+vj}.gt_start(1);
            gt_end=ucf_annotation{(class-1)*nVideos+vj}.gt_end(1);

rpath ='./data/Overlap_res/';
rpath2 ='./data/NonOver_res/';
rpath3 = './data/BOW_res/';


load([rpath,'_',num2str(class),'_',num2str(vi),'_',num2str(vj)],'overstart','overend');
load([rpath2,'_',num2str(class),'_',num2str(vi),'_',num2str(vj)],'nonoverstart','nonoverend');
load([rpath3,'_',num2str(class),'_',num2str(vi),'_',num2str(vj)],'minstart','minend');

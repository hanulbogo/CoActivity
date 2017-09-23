function dist =Get_Dist_Map2(class, vididx, nodesize, itv)

load('./data/ucf_one_annotation.mat');%'ucf_annotation'
hpath='./data/KDE_concat_hist_one/';

nVideos=25;



v = vididx(1);
aidx =(class-1)*nVideos+v;
load([hpath,ucf_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
A = [Thists,HOGhists,HOFhists,MBHxhists,MBHyhists];
A =A(itv(1,1):itv(1,2),:);

v = vididx(2);
aidx =(class-1)*nVideos+v;
load([hpath,ucf_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
B = [Thists,HOGhists,HOFhists,MBHxhists,MBHyhists];


dist = vl_alldist2(A',B','CHI2') ;
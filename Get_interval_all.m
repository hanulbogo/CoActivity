function itv = Get_interval_all(class,vididx,nodesize,len)

spath ='./data/seg_hists/';

load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
nVideos=25;
aidx1= (class-1)*nVideos+ vididx(1);

nnodes =(ceil(sum(ucf_annotation{aidx1}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
itv(1,1)=ceil(ucf_annotation{aidx1}.gt_start(1)/nodesize);
itv(1,2) = (ceil(ucf_annotation{aidx1}.gt_end(1)/nodesize)*nodesize - len)/nodesize +1;
% 
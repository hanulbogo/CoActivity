function itv = Get_interval(class,vididx,nodesize,len)

spath ='./data/seg_hists_one/';

load('./data/ucf_one_annotation.mat');%'ucf_annotation'
nVideos=25;
aidx1= (class-1)*nVideos+ vididx(1);

nnodes =(ceil(sum(ucf_annotation{aidx1}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
itv(1,1)=ceil(ucf_annotation{aidx1}.gt_start(1)/nodesize);
itv(1,2) = (ceil(ucf_annotation{aidx1}.gt_end(1)/nodesize)*nodesize - len)/nodesize +1;

aidx2= (class-1)*nVideos+ vididx(2);

nnodes =(ceil(sum(ucf_annotation{aidx2}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
itv(2,1)= 1;
itv(2,2)= nnodes;
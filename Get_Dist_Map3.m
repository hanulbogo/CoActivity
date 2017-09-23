function dist =Get_Dist_Map3(class, vididx, nodesize)

load('./data/ucf_one_annotation.mat');%'ucf_annotation'
hpath='./data/KDE_concat_hist_one/';
nVideos=25;
aidx1= (class-1)*nVideos+ vididx(1);


itv(1,1)=ceil(ucf_annotation{aidx1}.gt_start(1)/nodesize);
itv(1,2) = ceil(ucf_annotation{aidx1}.gt_end(1)/nodesize);

aidx2= (class-1)*nVideos+ vididx(2);

nnodes =ceil(sum(ucf_annotation{aidx2}.nFrames)/nodesize);
itv(2,1)= 1;
itv(2,2)= nnodes;

vlist=[];

if ~exist([hpath,ucf_annotation{aidx1}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat'],'file')
    vlist=[vlist aidx1];
end
if ~exist([hpath,ucf_annotation{aidx2}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat'],'file')
    vlist=[vlist aidx2];
end

make_nodes_one_vid(nodesize,vlist);

v = vididx(1);
aidx =(class-1)*nVideos+v;
load([hpath,ucf_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
A = [Thists,HOGhists,HOFhists,MBHxhists,MBHyhists];
A =A(itv(1,1):itv(1,2),:);

v = vididx(2);
aidx =(class-1)*nVideos+v;
load([hpath,ucf_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
B = [Thists,HOGhists,HOFhists,MBHxhists,MBHyhists];


% dist = vl_alldist2(A',B','CHI2') ;
dist =pdist2(A,B,@chi2dist); %N*D

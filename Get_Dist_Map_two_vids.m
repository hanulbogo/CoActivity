function dist =Get_Dist_Map_two_vids(class, vidx, nodesize, len)

load('./data/ucf_one_annotation.mat');%'ucf_annotation'
spath ='./data/seg_hists_one/';
nVideos=25;

aidx1=  (class-1)*nVideos+vidx(1);
load([spath,ucf_annotation{aidx1}.label,'_',num2str(vidx(1)),'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat']);
sT = sum(TSEGHISTS,2);
sT(sT==0)=1;
TSEGHISTS = TSEGHISTS./repmat(sT,1,size(TSEGHISTS,2));
sHOG = sum(HOGSEGHISTS,2);
sHOG(sHOG==0)=1;
HOGSEGHISTS = HOGSEGHISTS./repmat(sHOG,1,size(HOGSEGHISTS,2));
sHOF = sum(HOFSEGHISTS,2);
sHOF(sHOF==0)=1;
HOFSEGHISTS = HOFSEGHISTS./repmat(sHOF,1,size(HOFSEGHISTS,2));
sMx = sum(MBHxSEGHISTS,2);
sMx(sMx==0)=1;
MBHxSEGHISTS = MBHxSEGHISTS./repmat(sMx,1,size(MBHxSEGHISTS,2));
sMy = sum(MBHySEGHISTS,2);
sMy(sMy==0)=1;
MBHySEGHISTS = MBHySEGHISTS./repmat(sMy,1,size(MBHySEGHISTS,2));

A = [TSEGHISTS,HOGSEGHISTS,HOFSEGHISTS,MBHxSEGHISTS,MBHySEGHISTS];
clear  'TSEGHISTS' 'HOGSEGHISTS' 'HOFSEGHISTS' 'MBHxSEGHISTS' 'MBHySEGHISTS';

aidx2=  (class-1)*nVideos+vidx(2);
load([spath,ucf_annotation{aidx2}.label,'_',num2str(vidx(2)),'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat']);
sT = sum(TSEGHISTS,2);
sT(sT==0)=1;
TSEGHISTS = TSEGHISTS./repmat(sT,1,size(TSEGHISTS,2));
sHOG = sum(HOGSEGHISTS,2);
sHOG(sHOG==0)=1;
HOGSEGHISTS = HOGSEGHISTS./repmat(sHOG,1,size(HOGSEGHISTS,2));
sHOF = sum(HOFSEGHISTS,2);
sHOF(sHOF==0)=1;
HOFSEGHISTS = HOFSEGHISTS./repmat(sHOF,1,size(HOFSEGHISTS,2));
sMx = sum(MBHxSEGHISTS,2);
sMx(sMx==0)=1;
MBHxSEGHISTS = MBHxSEGHISTS./repmat(sMx,1,size(MBHxSEGHISTS,2));
sMy = sum(MBHySEGHISTS,2);
sMy(sMy==0)=1;
MBHySEGHISTS = MBHySEGHISTS./repmat(sMy,1,size(MBHySEGHISTS,2));
B = [TSEGHISTS,HOGSEGHISTS,HOFSEGHISTS,MBHxSEGHISTS,MBHySEGHISTS];

clear  'TSEGHISTS' 'HOGSEGHISTS' 'HOFSEGHISTS' 'MBHxSEGHISTS' 'MBHySEGHISTS';

dist =pdist2(A,B,@chi2dist); %N*D

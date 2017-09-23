function dist =Get_Dist_Map_normalize(class, vididx, nodesize, len)

load('./data/ucf_one_annotation.mat');%'ucf_annotation'
spath ='./data/seg_hists_one/';
nVideos=25;

aidx1=  (class-1)*nVideos+vididx(1);
load([spath,ucf_annotation{aidx1}.label,'_nodesize_',num2str(nodesize),'_SEGHISTS_KDE_',num2str(len),'_',num2str(vididx(1)),'_gt.mat']);
A = [TSEGHISTS,HOGSEGHISTS,HOFSEGHISTS,MBHxSEGHISTS,MBHySEGHISTS];
clear  'TSEGHISTS' 'HOGSEGHISTS' 'HOFSEGHISTS' 'MBHxSEGHISTS' 'MBHySEGHISTS';
SA = remat(sum(A,2),1,size(A,2));
A = A./SA;
aidx2=  (class-1)*nVideos+vididx(2);
load([spath,ucf_annotation{aidx2}.label,'_nodesize_',num2str(nodesize),'_SEGHISTS_KDE_',num2str(len),'_',num2str(vididx(2)),'_all.mat']);
B = [TSEGHISTS,HOGSEGHISTS,HOFSEGHISTS,MBHxSEGHISTS,MBHySEGHISTS];
SB = remat(sum(B,2),1,size(B,2));
B = B./SB;
clear  'TSEGHISTS' 'HOGSEGHISTS' 'HOFSEGHISTS' 'MBHxSEGHISTS' 'MBHySEGHISTS';
% 'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS');

% dist1 = vl_alldist2(A',B','CHI2') ;  %D*N
dist =pdist2(A,B,@chi2dist); %N*D
% fprintf('wow');
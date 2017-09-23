function test_self_similarity()

load('./data/ucf_one_annotation.mat');%'ucf_annotation'
spath ='./data/seg_hists_one/';
nVideos=25;
classlist=1;
nodesize=5;
len = nodesize*15;
for class= classlist
    for vidx =1:25
        aidx1=  (class-1)*nVideos+vidx;
        load([spath,ucf_annotation{aidx1}.label,'_nodesize_',num2str(nodesize),'_SEGHISTS_KDE_',num2str(len),'_',num2str(vidx),'_gt.mat']);
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
        dist =pdist2(MBHxSEGHISTS,MBHxSEGHISTS,@chi2dist); %N*D
        figure;
        imshow(dist,[]);
    end
end

% make_nodes_one_vid(nodesize,vlist);
% 
% v = vididx(1);
% aidx =(class-1)*nVideos+v;
% load([hpath,ucf_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
% A = [Thists,HOGhists,HOFhists,MBHxhists,MBHyhists];
% A =A(itv(1,1):itv(1,2),:);
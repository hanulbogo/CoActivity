function HW_L1Normalization_SEGHISTS_fast(nodesize, class, len,NC) % flag =1 ofd flag =2 org
load('./data/HW_nVideos.mat');%nVideolist
load('./data/HW_annotation.mat');%'HW_annotation'

spath ='./data/HW_seg_hists/';

npath ='./data/HW_L1NORM_seg_hists/';
if ~exist(npath,'dir')
    mkdir(npath);
end
nVideos=nVideolist(class);
lname =HW_annotation{sum(nVideolist(1:(class-1)))+1}.label;


HW_make_segments_org_fast(nodesize, class, len,NC);
load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_HW_',num2str(len),'_org.mat']);


% for
nc =NC;
    sT = sum(TSEGHISTS{nc},2);
    sT(sT==0)=1;
    TDATA{nc} = TSEGHISTS{nc}./repmat(sT,1,size(TSEGHISTS{nc},2));
    
    sHOG = sum(HOGSEGHISTS{nc},2);
    sHOG(sHOG==0)=1;
    HOGDATA{nc} = HOGSEGHISTS{nc}./repmat(sHOG,1,size(HOGSEGHISTS{nc},2));
    
    sHOF = sum(HOFSEGHISTS{nc},2);
    sHOF(sHOF==0)=1;
    HOFDATA{nc} = HOFSEGHISTS{nc}./repmat(sHOF,1,size(HOFSEGHISTS{nc},2));
    
    sMx = sum(MBHxSEGHISTS{nc},2);
    sMx(sMx==0)=1;
    MBHxDATA{nc} = MBHxSEGHISTS{nc}./repmat(sMx,1,size(MBHxSEGHISTS{nc},2));
    
    sMy = sum(MBHySEGHISTS{nc},2);
    sMy(sMy==0)=1;
    MBHyDATA{nc} = MBHySEGHISTS{nc}./repmat(sMy,1,size(MBHySEGHISTS{nc},2));
% end
NDATA=sT;

save([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_HW_',num2str(len),'L1Norm_org.mat'],'NDATA','TDATA','HOGDATA','HOFDATA','MBHxDATA','MBHyDATA');

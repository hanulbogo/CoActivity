function UT_L1Normalization_SEGHISTS_fast(nodesize, class, len,flag,NC) % flag =1 ofd flag =2 org
load('./data/UT_nVideos.mat');%nVideolist
load('./data/UT_annotation.mat');%'UT_annotation'

spath ='./data/UT_seg_hists/';

npath ='./data/UT_L1NORM_seg_hists/';
if ~exist(npath,'dir')
    mkdir(npath);
end
nVideos=nVideolist(class);
lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
if flag==1
%     if~exist([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_UT_',num2str(len),'_ofd.mat'],'file')
        UT_make_segments_ofd(nodesize, class, len,NC);
%     end
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_UT_',num2str(len),'_ofd.mat']);
end
if flag==2
%     if~exist([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_UT_',num2str(len),'_org.mat'],'file')
        UT_make_segments_org_fast(nodesize, class, len,NC);
%     end
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_UT_',num2str(len),'_org.mat']);
end

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
if flag==1
    save([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_UT_',num2str(len),'L1Norm_ofd.mat'],'NDATA','TDATA','HOGFDATA','HOGDATA','OFDLDATA','OFDRDATA','OFDTDATA','OFDBDATA','OFDADATA','OFDCDATA','HOFDATA','MBHxDATA','MBHyDATA');
end
if flag==2
     save([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_UT_',num2str(len),'L1Norm_org.mat'],'NDATA','TDATA','HOGDATA','HOFDATA','MBHxDATA','MBHyDATA');
end
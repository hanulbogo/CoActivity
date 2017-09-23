function L1Normalization_SEGHISTS(nodesize, class, len,spath, npath,flag,NC) % flag =1 ofd flag =2 org

load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
%
% spath ='./data/OFD_seg_hists/';
%
% npath ='./data/OFD_L1NORM_seg_hists/';
if ~exist(npath,'dir')
    mkdir(npath);
end
nVideos=25;
lname =ucf_annotation{(class-1)*nVideos+1}.label;
if flag==1
    OFD_make_segments_ofd(nodesize, class, len,NC);
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_OFD_',num2str(len),'_ofd.mat']);
end
if flag==2
    
    OFD_make_segments_org(nodesize, class, len);
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_OFD_',num2str(len),'_org.mat']);
end

for nc=NC
    %
    sT = sum(TSEGHISTS{nc},2);
    sT(sT==0)=1;
    TDATA{nc} = TSEGHISTS{nc}./repmat(sT,1,size(TSEGHISTS{nc},2));
    
    sHOGF = sum(HOGFSEGHISTS{nc},2);
    sHOGF(sHOGF==0)=1;
    HOGFDATA{nc} = HOGFSEGHISTS{nc}./repmat(sHOGF,1,size(HOGFSEGHISTS{nc},2));
    
    
    sHOG = sum(HOGSEGHISTS{nc},2);
    sHOG(sHOG==0)=1;
    HOGDATA{nc} = HOGSEGHISTS{nc}./repmat(sHOG,1,size(HOGSEGHISTS{nc},2));
    
    sOFDL = sum(OFDLSEGHISTS{nc},2);
    sOFDL(sOFDL==0)=1;
    OFDLDATA{nc} = OFDLSEGHISTS{nc}./repmat(sOFDL,1,size(OFDLSEGHISTS{nc},2));
    
    sOFDR = sum(OFDRSEGHISTS{nc},2);
    sOFDR(sOFDR==0)=1;
    OFDRDATA{nc} = OFDRSEGHISTS{nc}./repmat(sOFDR,1,size(OFDRSEGHISTS{nc},2));
    
    sOFDT = sum(OFDTSEGHISTS{nc},2);
    sOFDT(sOFDT==0)=1;
    OFDTDATA{nc} = OFDTSEGHISTS{nc}./repmat(sOFDT,1,size(OFDTSEGHISTS{nc},2));
    
    sOFDB = sum(OFDBSEGHISTS{nc},2);
    sOFDB(sOFDB==0)=1;
    OFDBDATA{nc} = OFDBSEGHISTS{nc}./repmat(sOFDB,1,size(OFDBSEGHISTS{nc},2));
    
    sOFDA = sum(OFDASEGHISTS{nc},2);
    sOFDA(sOFDA==0)=1;
    OFDADATA{nc} = OFDASEGHISTS{nc}./repmat(sOFDA,1,size(OFDASEGHISTS{nc},2));
    
    sOFDC = sum(OFDCSEGHISTS{nc},2);
    sOFDC(sOFDC==0)=1;
    OFDCDATA{nc} = OFDCSEGHISTS{nc}./repmat(sOFDC,1,size(OFDCSEGHISTS{nc},2));
    
    sHOF = sum(HOFSEGHISTS{nc},2);
    sHOF(sHOF==0)=1;
    HOFDATA{nc} = HOFSEGHISTS{nc}./repmat(sHOF,1,size(HOFSEGHISTS{nc},2));
    
    sMx = sum(MBHxSEGHISTS{nc},2);
    sMx(sMx==0)=1;
    MBHxDATA{nc} = MBHxSEGHISTS{nc}./repmat(sMx,1,size(MBHxSEGHISTS{nc},2));
    
    sMy = sum(MBHySEGHISTS{nc},2);
    sMy(sMy==0)=1;
    MBHyDATA{nc} = MBHySEGHISTS{nc}./repmat(sMy,1,size(MBHySEGHISTS{nc},2));
end

NDATA=sT;

if flag==1
    save([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_OFD_',num2str(len),'L1Norm_ofd.mat'],'NDATA','TDATA','HOGFDATA','HOGDATA','OFDLDATA','OFDRDATA','OFDTDATA','OFDBDATA','OFDADATA','OFDCDATA','HOFDATA','MBHxDATA','MBHyDATA');
end
if flag==2
    save([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_OFD_',num2str(len),'L1Norm_org.mat'],'NDATA','TDATA','HOGFDATA','HOGDATA','OFDLDATA','OFDRDATA','OFDTDATA','OFDBDATA','OFDADATA','OFDCDATA','HOFDATA','MBHxDATA','MBHyDATA');
end
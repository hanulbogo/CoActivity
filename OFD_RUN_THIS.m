% 
nodesize =10;
classlist =2;
len= nodesize*8;

load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
% cpath ='./data/OFD_concat/';
hpath='./data/OFD_concat_hist/';
spath ='./data/OFD_seg_hists/';
dpath ='./data/OFD_density_map/';
% matlabpool(3);
nVideos=25;
for class = classlist
    close all;

    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    if~exist([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_OFD_',num2str(len),'_ofd.mat'],'file') 
        OFD_make_segments_ofd(nodesize, class, len);
    end
    fprintf('OFD %s ',lname);
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_OFD_',num2str(len),'_ofd.mat']);
%     load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_OFD_',num2str(len),'_org.mat']);
    %TSEGHISTS  HOGFSEGHISTS HOGSEGHISTS OFDLSEGHISTS OFDRSEGHISTS OFDTSEGHISTS OFDBSEGHISTS OFDASEGHISTS OFDCSEGHISTS HOFSEGHISTS MBHxSEGHISTS MBHySEGHISTS
    sT = sum(TSEGHISTS,2);
    sT(sT==0)=1;
    TDATA = TSEGHISTS./repmat(sT,1,size(TSEGHISTS,2));
    
    sHOGF = sum(HOGFSEGHISTS,2);
    sHOGF(sHOGF==0)=1;
    HOGFDATA = HOGFSEGHISTS./repmat(sHOGF,1,size(HOGFSEGHISTS,2));
    
    
    sHOG = sum(HOGSEGHISTS,2);
    sHOG(sHOG==0)=1;
    HOGDATA = HOGSEGHISTS./repmat(sHOG,1,size(HOGSEGHISTS,2));
    
    sOFDL = sum(OFDLSEGHISTS,2);
    sOFDL(sOFDL==0)=1;
    OFDLDATA = OFDLSEGHISTS./repmat(sOFDL,1,size(OFDLSEGHISTS,2));
    
    sOFDR = sum(OFDRSEGHISTS,2);
    sOFDR(sOFDR==0)=1;
    OFDRDATA = OFDRSEGHISTS./repmat(sOFDR,1,size(OFDRSEGHISTS,2));
    
    sOFDT = sum(OFDTSEGHISTS,2);
    sOFDT(sOFDT==0)=1;
    OFDTDATA = OFDTSEGHISTS./repmat(sOFDT,1,size(OFDTSEGHISTS,2));
    
    sOFDB = sum(OFDBSEGHISTS,2);
    sOFDB(sOFDB==0)=1;
    OFDBDATA = OFDBSEGHISTS./repmat(sOFDB,1,size(OFDBSEGHISTS,2));
    
    sOFDA = sum(OFDASEGHISTS,2);
    sOFDA(sOFDA==0)=1;
    OFDADATA = OFDASEGHISTS./repmat(sOFDA,1,size(OFDASEGHISTS,2));
    
    sOFDC = sum(OFDCSEGHISTS,2);
    sOFDC(sOFDC==0)=1;
    OFDCDATA = OFDCSEGHISTS./repmat(sOFDC,1,size(OFDCSEGHISTS,2));
    
    sHOF = sum(HOFSEGHISTS,2);
    sHOF(sHOF==0)=1;
    HOFDATA = HOFSEGHISTS./repmat(sHOF,1,size(HOFSEGHISTS,2));
    
    sMx = sum(MBHxSEGHISTS,2);
    sMx(sMx==0)=1;
    MBHxDATA = MBHxSEGHISTS./repmat(sMx,1,size(MBHxSEGHISTS,2));
    
    sMy = sum(MBHySEGHISTS,2);
    sMy(sMy==0)=1;
    MBHyDATA = MBHySEGHISTS./repmat(sMy,1,size(MBHySEGHISTS,2));
    
%     fprintf('start Density Estimation\n');
    
    
    density= OFD_ParzenWindow(class,TDATA,  HOGFDATA, HOGDATA, OFDLDATA, OFDRDATA, OFDTDATA, OFDBDATA, OFDADATA, OFDCDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,sT) ;
    
    density(sT<len*.5) =0;
%     density(density<0.2)=0;
%     density(sT<10) =0;
%     fprintf('finish Density Estimation\n');
    
    OFD_make_weight_map(nodesize, class, len,density);
    OFD_plot_denstiy_map(nodesize, class, len);
%         OFD_evaluate_per_segments(nodesize, class, len);
    OFD_evaluate_per_frame(nodesize, class, len);
    %     toc;
    
    
    if~exist([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_OFD_',num2str(len),'_org.mat'],'file')
        OFD_make_segments_org(nodesize, class, len);
    end
     fprintf('ORG %s ',lname);
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_OFD_',num2str(len),'_org.mat']);
%     load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_OFD_',num2str(len),'_org.mat']);
    %TSEGHISTS  HOGFSEGHISTS HOGSEGHISTS OFDLSEGHISTS OFDRSEGHISTS OFDTSEGHISTS OFDBSEGHISTS OFDASEGHISTS OFDCSEGHISTS HOFSEGHISTS MBHxSEGHISTS MBHySEGHISTS
    sT = sum(TSEGHISTS,2);
    sT(sT==0)=1;
    TDATA = TSEGHISTS./repmat(sT,1,size(TSEGHISTS,2));
    
    sHOGF = sum(HOGFSEGHISTS,2);
    sHOGF(sHOGF==0)=1;
    HOGFDATA = HOGFSEGHISTS./repmat(sHOGF,1,size(HOGFSEGHISTS,2));
    
    
    sHOG = sum(HOGSEGHISTS,2);
    sHOG(sHOG==0)=1;
    HOGDATA = HOGSEGHISTS./repmat(sHOG,1,size(HOGSEGHISTS,2));
    
    sOFDL = sum(OFDLSEGHISTS,2);
    sOFDL(sOFDL==0)=1;
    OFDLDATA = OFDLSEGHISTS./repmat(sOFDL,1,size(OFDLSEGHISTS,2));
    
    sOFDR = sum(OFDRSEGHISTS,2);
    sOFDR(sOFDR==0)=1;
    OFDRDATA = OFDRSEGHISTS./repmat(sOFDR,1,size(OFDRSEGHISTS,2));
    
    sOFDT = sum(OFDTSEGHISTS,2);
    sOFDT(sOFDT==0)=1;
    OFDTDATA = OFDTSEGHISTS./repmat(sOFDT,1,size(OFDTSEGHISTS,2));
    
    sOFDB = sum(OFDBSEGHISTS,2);
    sOFDB(sOFDB==0)=1;
    OFDBDATA = OFDBSEGHISTS./repmat(sOFDB,1,size(OFDBSEGHISTS,2));
    
    sOFDA = sum(OFDASEGHISTS,2);
    sOFDA(sOFDA==0)=1;
    OFDADATA = OFDASEGHISTS./repmat(sOFDA,1,size(OFDASEGHISTS,2));
    
    sOFDC = sum(OFDCSEGHISTS,2);
    sOFDC(sOFDC==0)=1;
    OFDCDATA = OFDCSEGHISTS./repmat(sOFDC,1,size(OFDCSEGHISTS,2));
    
    sHOF = sum(HOFSEGHISTS,2);
    sHOF(sHOF==0)=1;
    HOFDATA = HOFSEGHISTS./repmat(sHOF,1,size(HOFSEGHISTS,2));
    
    sMx = sum(MBHxSEGHISTS,2);
    sMx(sMx==0)=1;
    MBHxDATA = MBHxSEGHISTS./repmat(sMx,1,size(MBHxSEGHISTS,2));
    
    sMy = sum(MBHySEGHISTS,2);
    sMy(sMy==0)=1;
    MBHyDATA = MBHySEGHISTS./repmat(sMy,1,size(MBHySEGHISTS,2));
    
%     fprintf('start Density Estimation\n');
    
    
    density= OFD_ParzenWindow(class,TDATA,  HOGFDATA, HOGDATA, OFDLDATA, OFDRDATA, OFDTDATA, OFDBDATA, OFDADATA, OFDCDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,sT) ;
    
    density(sT<len*.5) =0;
%     density(density<0.2)=0;
%     density(sT<10) =0;
%     fprintf('finish Density Estimation\n');
    
    OFD_make_weight_map(nodesize, class, len,density);
    OFD_plot_denstiy_map(nodesize, class, len);
%         OFD_evaluate_per_segments(nodesize, class, len);
    OFD_evaluate_per_frame(nodesize, class, len);
end
% matlabpool close;

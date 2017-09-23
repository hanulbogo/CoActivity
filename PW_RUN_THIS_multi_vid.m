% function zstip_KDE_BASED_segmentation_run_this()
% close all;
nodesize =10;
classlist =5;
len= nodesize*8;

load('./data/ucf_multi_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
hpath='./data/KDE_concat_hist_multi/';
spath ='./data/seg_hists_multi/';
dpath ='./data/KDE_density_map_multi/';
% matlabpool(3);

for class = classlist
    close all;
    tic;
    lname =ucf_annotation{(class-1)*10+1}.label;
%     if ~exist([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat'],'file')
    KDE_make_segments_multi_vid(nodesize, class, len);
%     end
    fprintf('Class %s\n',lname);
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat']);
    %'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS'
    
    fprintf('finishing load segments\n');
    sT = sum(TSEGHISTS,2);
    sT(sT==0)=1;
    TDATA = TSEGHISTS./repmat(sT,1,size(TSEGHISTS,2));
    sHOG = sum(HOGSEGHISTS,2);
    sHOG(sHOG==0)=1;
    HOGDATA = HOGSEGHISTS./repmat(sHOG,1,size(HOGSEGHISTS,2));
    sHOF = sum(HOFSEGHISTS,2);
    sHOF(sHOF==0)=1;
    HOFDATA = HOFSEGHISTS./repmat(sHOF,1,size(HOFSEGHISTS,2));
    sMx = sum(MBHxSEGHISTS,2);
    sMx(sMx==0)=1;
    MBHxDATA = MBHxSEGHISTS./repmat(sMx,1,size(MBHxSEGHISTS,2));
    sMy = sum(MBHySEGHISTS,2);
    sMy(sMy==0)=1;
    MBHyDATA = MBHySEGHISTS./repmat(sMy,1,size(MBHySEGHISTS,2));
    
    density = zeros(1, size(TSEGHISTS,1));
    density(sumhists>=len)= ParzenWindow_multi_vid(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,sumhists) ;
    fprintf('finish DE\n');
    if min(density)~=0
        density= density/min(density~=0);
    end
        
    KDE_make_weight_map_multi_vid(nodesize, class, len,density);
    KDE_plot_denstiy_map_multi_vid(nodesize, class, len);
%     KDE_evaluate_per_segments(nodesize, class, len);
     KDE_evaluate_per_frame_multi_vid(nodesize, class, len);
    toc;
end
% matlabpool close;

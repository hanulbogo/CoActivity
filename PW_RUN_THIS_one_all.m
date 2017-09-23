% function zstip_KDE_BASED_segmentation_run_this()
% close all;
nodesize =10;
classlist =1:14;
len= nodesize*8;
nVideos=25;

prpath2 = './data/pr_res_one/';
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
hpath='./data/KDE_concat_hist_one/';
spath ='./data/seg_hists_one/';
dpath ='./data/KDE_density_map_one/';
ppath ='./data/shortest_res/';


% matlabpool(3);
for class = classlist
    
    vididx =1:25;
%     fprintf('class %d ',class);
    close all;
    
    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    %     if ~exist([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat'],'file')
    KDE_make_segments_all_vid(nodesize, class, len,vididx);
    %     end
    fprintf('Class %s ',lname);
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'_all_videos.mat']);
    %'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS'
%     fprintf('finishing load segments\n');
    
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
    
%     fprintf('start DE\n');
    
    
    density= ParzenWindow_one_all(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize) ;
%     fprintf('finish DE\n');
    density(sT<len*2)=0;
    KDE_make_weight_map_one_all(nodesize, class, len,density);
    KDE_plot_denstiy_map_one_all(nodesize, class, len);
    %     KDE_evaluate_per_segments(nodesize, class, len);
    KDE_evaluate_per_frame_one_all(nodesize, class, len);
    
    
end

% matlabpool close;
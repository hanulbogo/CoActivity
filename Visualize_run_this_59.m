% function zstip_KDE_BASED_segmentation_run_this()
% close all;
nodesize =10;
classlist =1;
len= nodesize*8;

load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
hpath='./data/KDE_concat_hist/';
spath ='./data/seg_hists/';
dpath ='./data/KDE_density_map/';
% matlabpool(3);

for class = classlist
    close all;
    tic;
    lname =ucf_annotation{(class-1)*50+1}.label;
%     if ~exist([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat'],'file')
%         KDE_make_segments(nodesize, class, len);
%     end
    fprintf('Class %s\n',lname);
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat']);
    %'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS'
    
    fprintf('finishing load segments\n');
    sumhists =sum(TSEGHISTS,2);
    
    
    fprintf('start DE\n');
    
    

    
%     Visualize_by_Isomap_50_vids(class,len,nodesize,sumhists) %data : N*D
%     Visualize_isomap_result(class,len,nodesize,sumhists);
    toc;
end
% matlabpool close;

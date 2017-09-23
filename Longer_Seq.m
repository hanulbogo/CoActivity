function Longer_Seq(itv,vididx,class,len,nodesize)
nVideos=25;

prpath2 = './data/pr_res_one/';
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
hpath='./data/KDE_concat_hist_one/';
spath ='./data/seg_hists_one/';
dpath ='./data/KDE_density_map_one/';


close all;
tic;
lname =ucf_annotation{(class-1)*nVideos+1}.label;

KDE_make_segments_one_vid_with_itv(nodesize, classlist, len,vididx,itv);

fprintf('Class %s\n',lname);
load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'_',num2str(itv(1,1)),'_',num2str(itv(1,2)),'_',num2str(itv(2,1)),'_',num2str(itv(2,2)),'_two_videos.mat']);
%'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS'

fprintf('start DE\n');

Kpath ='./data/dists_one/';
if ~exist(Kpath,'dir')
    mkdir(Kpath);
end
kimgpath = './data/kernel_img_one/';
if ~exist(kimgpath,'dir');
    mkdir(kimgpath);
end
if ~exist([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_',num2str(itv(1,1)),'_',num2str(itv(1,2)),'_',num2str(itv(2,1)),'_',num2str(itv(2,2)),'_two_videos.mat'],'file') 
    dists{1}=PW_paralleldists_two_videos(TDATA','CHI2',class,1);
    dists{2}=PW_paralleldists_two_videos(HOGDATA','CHI2',class,2);
    dists{3}=PW_paralleldists_two_videos(HOFDATA','CHI2',class,3);
    dists{4}=PW_paralleldists_two_videos(MBHxDATA','CHI2',class,4);
    dists{5}=PW_paralleldists_two_videos(MBHyDATA','CHI2',class,5);
    save([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_',num2str(itv(1,1)),'_',num2str(itv(1,2)),'_',num2str(itv(2,1)),'_',num2str(itv(2,2)),'_two_videos.mat'],'dists');
else
    load([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_',num2str(itv(1,1)),'_',num2str(itv(1,2)),'_',num2str(itv(2,1)),'_',num2str(itv(2,2)),'_two_videos.mat']);%'dists'
end
Kern = PW_calc_Kern_from_dist_one_vid(dists);

% function zstip_KDE_BASED_segmentation_run_this()
% close all;
nodesize =10;
classlist =1:14;
len= nodesize*15;
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
    for vi =4
        for vj = 8
            vididx =[vi,vj];
            fprintf('Video %d and %d\n',vi,vj);
%             close all;
            tic;
            lname =ucf_annotation{(class-1)*nVideos+1}.label;
            %     if ~exist([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat'],'file')
            KDE_make_segments_one_vid(nodesize, class, len,vididx);
            %     end
            fprintf('Class %s\n',lname);
            load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'_two_videos.mat']);
            %'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS'
            
            fprintf('finishing load segments\n');
         
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
            
            
            aidx(1) = (class-1)*nVideos+vi;
            aidx(2) = (class-1)*nVideos+vj;
            fprintf('GT video1 [%d %d], video2 [%d,%d]\n',ucf_annotation{aidx(1)}.gt_start(1),ucf_annotation{aidx(1)}.gt_end(1),ucf_annotation{aidx(2)}.gt_start(1),ucf_annotation{aidx(2)}.gt_end(1));
%             if ~exist([ppath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_nodesize_',num2str(nodesize),'.mat'],'file')
                [maxitv1 maxitv2]= ParzenWindow_one_vid(class,TSEGHISTS, HOGSEGHISTS, HOFSEGHISTS, MBHxSEGHISTS, MBHySEGHISTS,len,nodesize,vididx) ;
%             else
% %                 load([ppath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_nodesize_',num2str(nodesize),'.mat']);
                %maxitv1, maxitv2
%             end
            
            
            %             fprintf('finish DE\n');
%             if min(density)~=0
%                 density= density/min(density~=0);
%             end
            
%             KDE_make_weight_map_one_vid(nodesize, class, len,density,vididx);
%             KDE_plot_denstiy_map_one_vid(nodesize, class, len,vididx);
%             KDE_evaluate_per_frame_one_vid(nodesize, class, len,vididx);
%             KDE_evaluate_per_segments
            toc;
            Evaluate_DTW_per_each_pair(class,vididx,nodesize);
            fprintf('\n');
        end
    end
    Evaluate_DTW_pair(class,nodesize)
end

% matlabpool close;
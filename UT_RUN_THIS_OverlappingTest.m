% function UT_RUN_THIS_OverlappingTest(stepsize)

nodesize =10;
classlist =[1:11];%:12;%11:12;%6%[1,2,3,4,7];
len= nodesize*3;
% len= nodesize*20;
load('./data/UT_nVideos.mat');%nVideolist
% sum(nVideolist(1:(class-1)))+1
load('./data/UT_annotation.mat');%'UT_annotation'
% cpath ='./data/UT_feat/';
hpath='./data/UT_hist/';
spath ='./data/UT_seg_hists/';
dpath ='./data/UT_density_map/';
npath ='./data/UT_L1NORM_seg_hists/';
% matlabpool(3);

% nCenters =[50,125,250,500,1000,2000,4000];
nCenters =4000;
% nc=;
NC =7;
cumacc = zeros(1001,1);
% close all;
global Vidlist;
global tempconst;
%  if matlabpool('size') ==0
%      parpool(4);
%  end
nc=7;
for stepsize=[30]
    
    fprintf('Step size %d\n',stepsize);
    for class =8:11%classlist
        close all;
        nVideos = nVideolist(class);
        %             Vidlist = [1:12];
        lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
        fprintf('%s ',lname);
        
        %             UT_L1Normalization_SEGHISTS(nodesize, class, len,2,NC) % flag =1 ofd flag =2 org
%         UT_L1Normalization_SEGHISTS_fast(nodesize, class, len,2,NC) % flag =1 ofd flag =2 org
        load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_UT_',num2str(len),'L1Norm_org.mat']); %NDATA
        
        
        density= UT_AMC_Stepsize(TDATA{nc}, HOGDATA{nc},HOFDATA{nc},MBHxDATA{nc},MBHyDATA{nc},class,len,nodesize,NDATA,nCenters,stepsize) ;
        
%         density_map= UT_make_weight_map_org(nodesize, class, len,density,nCenters);
        %%%%%%%%%%%%%%
        density_map= UT_make_weight_map_Stepsize(stepsize,nodesize,class, len,density);
        
        Threshold=UT_plot_denstiy_map(density_map,nVideos, class);
%         pause;
        %
%         UT_plot_denstiy_map_org(density_map,nodesize, class, len,nCenters,Threshold);
        %             %%%%%%%%%%%%%%
%         pause
        
        %             Threshold=UT_plot_denstiy_map_Mean(density_map,nVideos, class);
        %
        %             UT_plot_denstiy_map_org(density_map,nodesize, class, len,nCenters,Threshold);
        %                 UT_evaluate_per_frame_org(nodesize, class, len,nCenters);
        
        %             end
        %                 UT_video_write(nodesize,class,len,nCenters,Threshold);
        
        fprintf('\n');
    end
end

% function TH_RUN_THIS_OverlappingTest(stepsize)

nodesize =10;
len= nodesize*3;
% len= nodesize*20;
load('./data/TH_nVideos.mat');%nVideolist
% sum(nVideolist(1:(class-1)))+1
load('./data/TH_annotation.mat');%'TH_annotation'
% cpath ='./data/TH_feat/';
hpath='./data/TH_hist/';
spath ='./data/TH_seg_hists/';
dpath ='./data/TH_density_map/';
npath ='./data/TH_L1NORM_seg_hists/';
% matlabpool(3);

% nCenters =[50,125,250,500,1000,2000,4000];
nCenters =4000;
cumacc = zeros(1001,1);
nc=7;
for stepsize=[10,20,30]
    
    fprintf('Step size %d\n',stepsize);
    for class =1:length(nVideolist)
        close all;
        nVideos = nVideolist(class);
        %             Vidlist = [1:12];
        lname =TH_annotation{sum(nVideolist(1:(class-1)))+1}.label;
        fprintf('%s ',lname);
        
        %             TH_L1Normalization_SEGHISTS(nodesize, class, len,2,NC) % flag =1 ofd flag =2 org
%         TH_L1Normalization_SEGHISTS_fast(nodesize, class, len,2,NC) % flag =1 ofd flag =2 org
        load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_TH_',num2str(len),'L1Norm_org.mat']); %NDATA
        
        
        density= TH_AMC_Stepsize(TDATA{nc}, HOGDATA{nc},HOFDATA{nc},MBHxDATA{nc},MBHyDATA{nc},class,len,nodesize,NDATA,nCenters,stepsize) ;
        
%         density_map= TH_make_weight_map_org(nodesize, class, len,density,nCenters);
        %%%%%%%%%%%%%%
        density_map= TH_make_weight_map_Stepsize(stepsize,nodesize,class, len,density);
        
        Threshold=TH_plot_denstiy_map(density_map,nVideos, class);
%         pause;
        %
%         TH_plot_denstiy_map_org(density_map,nodesize, class, len,nCenters,Threshold);
        %             %%%%%%%%%%%%%%
%         pause
        
        %             Threshold=TH_plot_denstiy_map_Mean(density_map,nVideos, class);
        %
        %             TH_plot_denstiy_map_org(density_map,nodesize, class, len,nCenters,Threshold);
        %                 TH_evaluate_per_frame_org(nodesize, class, len,nCenters);
        
        %             end
        %                 TH_video_write(nodesize,class,len,nCenters,Threshold);
        
        fprintf('\n');
    end
end

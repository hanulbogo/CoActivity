% % % function TH_RUN_THIS
nodesize =10;
len= nodesize*3;
% len= nodesize*20;
load('./data/TH_nVideos.mat');%nVideolist
load('./data/TH_annotation.mat');%'TH_annotation'

hpath='./data/TH_hist/';
spath ='./data/TH_seg_hists/';
dpath ='./data/TH_density_map/';
npath ='./data/TH_L1NORM_seg_hists/';
nCenters =4000;
NC =7;
close all;


nc=7;
global mname;
%  if matlabpool('size') ==0
%      parpool(4);
%  end
mlist = {'AMC', 'AMC-','PR'};

for mm =3
    
    mname =mlist{mm};
    
    fprintf('%s \n',mname);
    for class =1:length(nVideolist)
        close all;
        nVideos = nVideolist(class);
        lname =TH_annotation{sum(nVideolist(1:(class-1)))+1}.label;
        fprintf('%d %s ',class, lname);
        
        %             TH_L1Normalization_SEGHISTS(nodesize, class, len,2,NC) % flag =1 ofd flag =2 org
        %     TH_L1Normalization_SEGHISTS_fast(nodesize, class, len,NC) % flag =1 ofd flag =2 org
        load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_TH_',num2str(len),'L1Norm_org.mat']); %NDATA
        
        density= TH_AMC(TDATA{nc}, HOGDATA{nc},HOFDATA{nc},MBHDATA{nc},class,len,nodesize,NDATA,nCenters) ;
        
        %%%%%%%%%%%%%%
        density_map= TH_make_weight_map_org(nodesize, class, len,density);
        Threshold=TH_plot_denstiy_map(density_map,nVideos, class);
        %                 TH_plot_denstiy_map_org(density_map,nodesize, class, len,nCenters,Threshold);
        %%%%%%%%%%%%%%
        
        
        %             Threshold=TH_plot_denstiy_map_Mean(density_map,nVideos, class);
        %
        %             TH_plot_denstiy_map_org(density_map,nodesize, class, len,nCenters,Threshold);
        %                 TH_evaluate_per_frame_org(nodesize, class, len,nCenters);
        
        %             end
        %                 TH_video_write(nodesize,class,len,nCenters,Threshold);
        
        fprintf('\n');
    end
    
end
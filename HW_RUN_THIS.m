% % % function HW_RUN_THIS
nodesize =10;
len= nodesize*3;
% len= nodesize*20;
load('./data/HW_nVideos.mat');%nVideolist
load('./data/HW_annotation.mat');%'HW_annotation'

hpath='./data/HW_hist/';
spath ='./data/HW_seg_hists/';
dpath ='./data/HW_density_map/';
npath ='./data/HW_L1NORM_seg_hists/';
nCenters =4000;
NC =7;
close all;

global mname;
mlist ={'AMC','AMC-','PR'};
nc=7;


    for mm=1:3
        mname = mlist{mm};
        fprintf('%s \n', mname);
        for class =length(nVideolist)
            close all;
            nVideos = nVideolist(class);
            lname =HW_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s ',lname);
            
            %             HW_L1Normalization_SEGHISTS(nodesize, class, len,2,NC) % flag =1 ofd flag =2 org
            %     HW_L1Normalization_SEGHISTS_fast(nodesize, class, len,NC) % flag =1 ofd flag =2 org
           load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_HW_',num2str(len),'L1Norm_org.mat']); %NDATA
            
            density= HW_AMC(TDATA{nc}, HOGDATA{nc},HOFDATA{nc},MBHxDATA{nc},MBHyDATA{nc},class,len,nodesize,NDATA,nCenters) ;
            
            %%%%%%%%%%%%%%
            density_map= HW_make_weight_map_org(nodesize, class, len,density);
            Threshold=HW_plot_denstiy_map(density_map,nVideos, class);
            %                 HW_plot_denstiy_map_org(density_map,nodesize, class, len,nCenters,Threshold);
            %%%%%%%%%%%%%%
            
            
            %             Threshold=HW_plot_denstiy_map_Mean(density_map,nVideos, class);
            %
            %             HW_plot_denstiy_map_org(density_map,nodesize, class, len,nCenters,Threshold);
            %                 HW_evaluate_per_frame_org(nodesize, class, len,nCenters);
            
            %             end
            %                 HW_video_write(nodesize,class,len,nCenters,Threshold);
            
            fprintf('\n');
        end
    end

%
nodesize =10;
classlist =[1,3:12];%:12;%11:12;%6%[1,2,3,4,7];
% len= nodesize*8;
len= nodesize*8;

load('./data/UT_annotation.mat');%'UT_annotation'
% cpath ='./data/UT_feat/';
hpath='./data/UT_hist/';
spath ='./data/UT_seg_hists/';
dpath ='./data/UT_density_map/';
npath ='./data/UT_L1NORM_seg_hists/';
% matlabpool(3);
nVideos=10;
% nCenters =[50,125,250,500,1000,2000,4000];
nCenters =4000;
% nc=;
NC =7;
cumacc = zeros(1001,1);
close all;
global K

for kk = 1:10
    K = 0.1*kk;
    fprintf('\n\n%f\n',K);
    for nc=7
        for class =classlist
            close all;
            
            lname =UT_annotation{(class-1)*nVideos+1}.label;
            fprintf('%s ',lname);
            
            load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_UT_',num2str(len),'L1Norm_org.mat']); %NDATA
            
            %                             density= UT_ParzenWindow_org_Temporal(class,len,nodesize,NDATA,nCenters) ;
            density= UT_KNN(class,len,nodesize,NDATA,nCenters) ;
            %         density= UT_AllSum(class,len,nodesize,NDATA,nCenters) ;
            density(NDATA<len*0.5) =0;
            
            
            UT_make_weight_map_org(nodesize, class, len,density,nCenters);
            
            load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_UT_',num2str(len),'_',num2str(nCenters),'_org.mat'],'density_map');
            %
            
            %   cumacc=UT_evaluate_per_segments(cumacc,nodesize, class, len,nCenters(nc),Threshold);
            Threshold=UT_plot_denstiy_map(density_map,nVideos, class);
            
            UT_plot_denstiy_map_org(nodesize, class, len,nCenters,Threshold);
            %                 UT_evaluate_per_frame_org(nodesize, class, len,nCenters);
            
            %             end
            %                 UT_video_write(nodesize,class,len,nCenters,Threshold);
            
            fprintf('\n');
        end
    end
end
% matlabpool close;
% [val th] =max(cumacc);
% fprintf('org_average acc : %.2f theshold th %d\n', val/length(classlist), th);
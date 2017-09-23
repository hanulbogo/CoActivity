% 
nodesize =10;
classlist =12;%[1,3:12];%:12;%11:12;%6%[1,2,3,4,7];
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
nCenters =[50,125,250,500,1000,2000,4000];
% nc=;
NC =7;
cumacc = zeros(1001,1);
close all;
Threshold=0.3;
rpath ='./coaction_code/data/UT_result/';

for nc=7:NC
    for class = classlist
            close all;
        
        lname =UT_annotation{(class-1)*nVideos+1}.label;
        fprintf('%s ',lname);
%         %     if ~exist([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_UT_',num2str(len),'L1Norm_ofd.mat'],'file')
%         UT_L1Normalization_SEGHISTS(nodesize, class, len,1,nc)
%         %     end
%         load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_UT_',num2str(len),'L1Norm_ofd.mat']);
%         %     density =kmeans([TDATA{nc}, HOGDATA{nc},HOFDATA{nc}, MBHxDATA{nc}, MBHyDATA{nc}],20);
%         %     load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_UT_',num2str(len),'_org.mat']);
%         %TSEGHISTS  HOGFSEGHISTS HOGSEGHISTS OFDLSEGHISTS OFDRSEGHISTS OFDTSEGHISTS OFDBSEGHISTS OFDASEGHISTS OFDCSEGHISTS HOFSEGHISTS MBHxSEGHISTS MBHySEGHISTS
%         %     for nc =1: 1 %NC
%         [density ]= UT_ParzenWindow_ofd(class,TDATA{nc},  HOGFDATA{nc}, HOGDATA{nc}, OFDLDATA{nc}, OFDRDATA{nc}, OFDTDATA{nc}, OFDBDATA{nc}, OFDADATA{nc}, OFDCDATA{nc}, HOFDATA{nc}, MBHxDATA{nc}, MBHyDATA{nc},len,nodesize,NDATA,nCenters(nc)) ;
% %                 density(NDATA<len*.5) =0;
%         UT_make_weight_map_ofd(nodesize, class, len,density,nCenters(nc));
%         UT_plot_denstiy_map_ofd(nodesize, class, len,nCenters(nc),Mpairs);
%         UT_evaluate_per_segments_ofd(nodesize, class, len,nCenters(nc));
        %         UT_evaluate_per_frame_ofd(nodesize, class, len,nCenters(nc));
        %         UT_video_write(nodesize,class,len,nCenters(nc));
        %     end
        
            if ~exist([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_UT_',num2str(len),'L1Norm_org.mat'],'file')
                UT_L1Normalization_SEGHISTS(nodesize, class, len,2,nc)
            end
            load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_UT_',num2str(len),'L1Norm_org.mat']);
            
%             for nc =7
                density= UT_ParzenWindow_org(class,TDATA{nc},  HOGFDATA{nc}, HOGDATA{nc}, OFDLDATA{nc}, OFDRDATA{nc}, OFDTDATA{nc}, OFDBDATA{nc}, OFDADATA{nc}, OFDCDATA{nc}, HOFDATA{nc}, MBHxDATA{nc}, MBHyDATA{nc},len,nodesize,NDATA,nCenters(nc)) ;
                density(NDATA<len*0.5) =0;
                                
                Threshold = mean(density/max(density));
                UT_make_weight_map_org(nodesize, class, len,density,nCenters(nc));
                cumacc=UT_evaluate_per_segments(cumacc,nodesize, class, len,nCenters(nc),Threshold);
                UT_plot_segments_map_org(nodesize, class, len,nCenters(nc),Threshold);
                UT_plot_coaction_map(rpath,nVideos, class,nodesize,nCenters(NC));
                UT_evaluate_per_frame_org(nodesize, class, len,nCenters(nc));
                
%             end
%                 UT_video_write(nodesize,class,len,nCenters(nc));
%                 UT_video_key_frame_write(nodesize,class,len,nCenters(nc),th);
        
        fprintf('\n');
    end
end
% matlabpool close;
[val th] =max(cumacc);
fprintf('org_average acc : %.2f theshold th %d\n', val/length(classlist), th);
function UT_RUN_THIS(len)
stepsize =10;
classlist =[1:11];%:12;%11:12;%6%[1,2,3,4,7];
len= stepsize*3;
% len= stepsize*20;
load('./../data/UT_nVideos.mat');%nVideolist
% sum(nVideolist(1:(class-1)))+1
load('./../data/UT_annotation.mat');%'UT_annotation'
% cpath ='./../data/UT_feat/';
hpath='./../data/UT_hist/';
spath ='./../data/UT_seg_hists/';
dpath ='./../data/UT_density_map/';
npath ='./../data/UT_L1NORM_seg_hists/';
% matlabpool(3);

% nCenters =[50,125,250,500,1000,2000,4000];
nCenters =4000;
% nc=;
NC =7;
cumacc = zeros(1001,1);
% close all;
global Vidlist;
global tempconst;
global mname;
%  if matlabpool('size') ==0
%      parpool(4);
%  end
mlist = {'AMC', 'AMC-','PR'};
nsubseq=0;
for mm =1
    
    mname =mlist{mm};

    fprintf('%s \n',mname);
    for nc=7
        for class =1:11%1:11%classlist
            close all;
            nVideos = nVideolist(class);
%             Vidlist = [1:12];
            lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s ',lname);
            
%             UT_L1Normalization_SEGHISTS(stepsize, class, len,2,NC) % flag =1 ofd flag =2 org
            UT_L1Normalization_SEGHISTS_fast(stepsize, class, len,2,NC) % flag =1 ofd flag =2 org
            load([npath,lname,'_stepsize_',num2str(stepsize), '_DATA_UT_',num2str(len),'L1Norm_org.mat']); %NDATA
            
            nsubseq =nsubseq+length(TDATA{nc});
            density= UT_AMC(TDATA{nc}, HOGDATA{nc},HOFDATA{nc},MBHxDATA{nc},MBHyDATA{nc},class,len,stepsize,NDATA,nCenters) ;
            %%%%%%%%%%%%%%
            density_map= UT_make_weight_map_org(stepsize, class, len,density,nCenters);
            Threshold=UT_plot_denstiy_map(density_map,nVideos, class);
%             UT_plot_denstiy_map_org(density_map,stepsize, class, len,nCenters,Threshold);
            %%%%%%%%%%%%%%
            
            
            %             Threshold=UT_plot_denstiy_map_Mean(density_map,nVideos, class);
            %
            %             UT_plot_denstiy_map_org(density_map,stepsize, class, len,nCenters,Threshold);
            %                 UT_evaluate_per_frame_org(stepsize, class, len,nCenters);
            
            %             end
            %                 UT_video_write(stepsize,class,len,nCenters,Threshold);
            
            fprintf('\n');
        end
    end
end


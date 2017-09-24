function UT_RUN_THIS()
addpath(genpath('./Codes/'));
global dpath;
global npath;
dpath ='./../data/';
npath =[dpath ,'UT_subsequence_hists/'];
% subsequnce sampled every 10 frame
stepsize =10;
% length of subsequence
len= stepsize*3;
% DB information
load([dpath ,'UT_nVideos.mat']);
% Annotation for YouTube dataset. GT information.
load([dpath ,'UT_annotation.mat']);%'UT_annotation'


nCenters =4000;
% Algorithm.
global mname;
mlist = {'AMC', 'AMC-','PR'};

for mm =1
    
    mname =mlist{mm};
    fprintf('%s \n',mname);
    
    
    for class =1:11
        close all;
        nVideos = nVideolist(class);
        lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
        fprintf('%s \n',lname);
        
        %% Features of subsequences
        if ~exist([npath,lname,'_stepsize_',num2str(stepsize), '_subsequence_len_',num2str(len),'.mat'],'file')
            UT_subsequence_hist(stepsize, class, len); % 
        end
        
        %% Graph Construction and Co-activity score AMC
        absorption_time= UT_AMC(class,len,stepsize,lname);
        
        %% Co-activity score
        coactivity_score= UT_CoActivity_Score(stepsize, class, len,absorption_time);
        %% Thresholding and Detect Co-activity frames by using GMM
        UT_Thresholding(coactivity_score,nVideos, class);
                
        fprintf('\n');
    end
    
end


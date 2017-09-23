%
%
nodesize =10;

% len= nodesize*8;
len= nodesize*3;

load('./data/TH_annotation.mat');%'TH_annotation'
load('./data/TH_nVideos.mat');%nVideolist

% cpath ='./data/TH_feat/';
hpath='./data/TH_hist/';
spath ='./data/TH_seg_hists/';
dpath ='./data/TH_density_map/';
distpath = './data/TH_dists/';
npath ='./data/TH_L1NORM_seg_hists/';
% matlabpool(3);
% nVideos=10;
% nCenters =[50,125,250,500,1000,2000,4000];
nCenters =4000;
% nc=;
NC =7;
cumacc = zeros(1001,1);
close all;
    nc=7;
    
    ptemp=0;
    rtemp=0;
    ftemp=0;
    
    for Ncomb = 2
        for class =15%1:length(nVideolist)
            close all;
            nVideos=nVideolist(class);
            
            AllComb= combntns(1 :nVideos,Ncomb );
            lname =TH_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s ',lname);
            
            
            for cc = 1%1:nVideos%:length(AllComb)
%                 if ~isempty(find(AllComb(cc,:)>10, 1)) 
                    Comb = AllComb(cc,:);
%                     TH_N_Visualize2(class,AllComb(cc,:));
%                     TH_N_Visualize2(class,[4,10]);
                    TH_N_Visualize3(class,[4,10]);
%                       TH_All_Visualize2(class,cc);
%                     TH_All_Visualize4(class,cc);
%                     TH_All_Visualize1(density_map, class,AllComb(cc,:));
                    close all;
%                 end
            end
        end
    end

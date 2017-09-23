%
%
nodesize =10;

% len= nodesize*8;
len= nodesize*3;

load('./data/HW_annotation.mat');%'HW_annotation'
load('./data/HW_nVideos.mat');%nVideolist

% cpath ='./data/HW_feat/';
hpath='./data/HW_hist/';
spath ='./data/HW_seg_hists/';
dpath ='./data/HW_density_map/';
distpath = './data/HW_dists/';
npath ='./data/HW_L1NORM_seg_hists/';
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
        for class =2%1:length(nVideolist)
            close all;
            nVideos=nVideolist(class);
            
            AllComb= combntns(1 :nVideos,Ncomb );
            lname =HW_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s ',lname);
            
            
            for cc = 1%:nVideos%length(AllComb)
%                 if ~isempty(find(AllComb(cc,:)>10, 1)) 
%                     Comb = AllComb(cc,:);
                    HW_N_Visualize3(class,[5,6]);
%                       HW_All_Visualize2(class,cc);
%                     HW_All_Visualize4(class,cc);
%                     HW_All_Visualize1(density_map, class,AllComb(cc,:));
                    close all;
%                 end
            end
        end
    end

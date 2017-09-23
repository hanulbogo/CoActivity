%
%
nodesize =10;
classlist =[1:11];%:12;%11:12;%6%[1,2,3,4,7];
% len= nodesize*8;
len= nodesize*3;

load('./data/UT_annotation.mat');%'UT_annotation'
load('./data/UT_nVideos.mat');%nVideolist

% cpath ='./data/UT_feat/';
hpath='./data/UT_hist/';
spath ='./data/UT_seg_hists/';
dpath ='./data/UT_density_map/';
distpath = './data/UT_dists/';
npath ='./data/UT_L1NORM_seg_hists/';
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
        for class =7%1:length(nVideolist)
            close all;
            nVideos=nVideolist(class);
            
            AllComb= combntns(1 :nVideos,Ncomb );
            lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s ',lname);
            
            
            for cc = 1%:length(AllComb)
%                 if ~isempty(find(AllComb(cc,:)>10, 1)) 
%                     Comb = AllComb(cc,:);
%                     UT_N_Visualize2(class,AllComb(cc,:));
%                     UT_N_Visualize2(class,[3,6]);
                    UT_N_Visualize3(class,[6 9]);
%                     UT_N_Visualize5(class,Comb);
%                       UT_All_Visualize2(class,cc);
%                     UT_All_Visualize5(class,cc);
%                     UT_All_Visualize4(class,cc);
%                     UT_All_Visualize1(density_map, class,AllComb(cc,:));
                    close all;
%                 end
            end
        end
    end

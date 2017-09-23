%
%
nodesize =10;

% len= nodesize*8;
len= nodesize*3;

load('./data/UCF_annotation.mat');%'UCF_annotation'
load('./data/UCF_nVideos.mat');%nVideolist

% cpath ='./data/UCF_feat/';
hpath='./data/UCF_hist/';
spath ='./data/UCF_seg_hists/';
dpath ='./data/UCF_density_map/';
distpath = './data/UCF_dists/';
npath ='./data/UCF_L1NORM_seg_hists/';
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
        for class =1:length(nVideolist)
            close all;
            nVideos=nVideolist(class);
            
            AllComb= combntns(1 :nVideos,Ncomb );
            lname =UCF_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s\n ',lname);
            if strcmp(lname,'IceDancing')
            
                for cc = 1%:nVideos%6:length(AllComb)
                    %                 if ~isempty(find(AllComb(cc,:)>10, 1))
                    Comb = AllComb(cc,:);
                    %                     UCF_N_Visualize2(class,AllComb(cc,:));
                    %                     UCF_N_Visualize2(class,[3,6]);
                    UCF_N_Visualize3(class,[1,5]);
                    %                     pause;
                    %                       UCF_All_Visualize2(class,cc);
                    %                     UCF_All_Visualize4(class,cc);
                    %                     UCF_All_Visualize1(density_map, class,AllComb(cc,:));
                    close all;
                    %                 end
                end
            end
        end
    end

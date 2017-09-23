function CoActDiscovery_Main(classlist,hpath,spath, dmpath, npath,nodesize, len)

dpath ='./../UCF_OFD_TWO_SET/';

% 각 비디오의 feature가 저장 되어있는 폴더
fpath ='F:\YDH\features\';

%각각 4개의 비디오에서 feature를 연결해 저정하는 단계
cpath ='./data/OFD_concat/';

%연결된 video를 sliding window의 step size로 나눈 histogram저장장소
hpath='./data/OFD_concat_hist/';

%sliding window를 통해 얻어진 sub-video의 histogram을 저장하는 폴더
spath ='./data/OFD_seg_hists/';

%sliding window를 통해 얻어진 sub-video의 histogram을 L1-Normalization을 한 값들을 저장하는 폴더
npath ='./data/OFD_L1NORM_seg_hists/';

%각 Video들의 Density값이 저장되는 폴더
dmpath ='./data/OFD_density_map/';

%4개의 비디오를 어떤 순서로 섞어서 붙일지 결정하고(랜덤) 결과나온후 Evalutation을 위해 Ground Truth을 저장하는 단계
% OFD_make_new_ann(dpath);  
% 이미 실행해서 정보를 저장함, 실행하려면 video가 필요한데 video를 모두 첨부하기에 용량이 커서 제외.
% 테스트는 Youtube Dataset Test Code를 이용하면 동일한 과정을 볼수 있음.

%101개의 class
classlist = 1:101;

%SlidingWindow stepsize
nodesize=10;

%Subvideo frame length
len=nodesize*3;
%비디오 정보(이름, 전체 프레임수 등) 로드
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'

% hpath='./data/OFD_concat_hist/';
% spath ='./data/OFD_seg_hists/';
% dmpath ='./data/OFD_density_map/';
% npath ='./data/OFD_L1NORM_seg_hists/';
% dpath ='./data/OFD_density_map/';

%카테고리별 비디오 갯수
nVideos=25;

%BoW의 Codeword 갯수
% nCenters =50;
nCenters =4000;
% nCenter =4000;
% nc=1;
global mname;
mlist ={'AMC','AMC-','PR'};
for mm =1:3
    
    mname = mlist{mm};
    fprintf('%s\n',mname);
    dmpath =['./data/OFD_density_map/', mname '/'];
    %classlist에 있는 모든 class들에 대해 co-activity검출
    for class =  classlist
        close all;
        
        lname =ucf_annotation{(class-1)*nVideos+1}.label;
        
        % label 출력
        fprintf('%s ',lname);
        
        %% Camera Motion Invariant Sampling을 통해 얻어진 co-activity
        %         L1Normalization_SEGHISTS(nodesize, class, len,spath, npath,2,7) % flag =1 ofd flag =2 org
%         if ~exist([dmpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenters),'_org.mat'],'file')
            load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_OFD_',num2str(len),'L1Norm_org.mat']); %NDATA
            density= UCF_AMC(TDATA{7},HOGDATA{7},HOFDATA{7},MBHxDATA{7},MBHyDATA{7},class,len,nodesize,NDATA,nCenters) ;
            density(NDATA<len*0.5) =0;
            OFD_make_weight_map_org(nodesize, class, len,density,nCenters,dmpath);
            load([dmpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenters),'_org.mat']); %density_map
%         else
%             load([dmpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenters),'_org.mat']); %density_map
            Threshold=UCF_plot_density_map(density_map,nVideos, class);
             OFD_plot_denstiy_map_org(nodesize, class, len,nCenters,Threshold);
%         end
        %각 Video별 Density값 그림
%                
%                 pause;

        %PR curve를 그리고, Average Precision 계산
        %     OFD_evaluate_per_frame_org(nodesize, class, len,nCenters);
        
        fprintf('\n');
    end
end
end
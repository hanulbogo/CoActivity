function UCF_KNN_Main(classlist,hpath,spath, dmpath, npath,nodesize, len)

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
nc=1;
global K;
for kk =1:10
    K =0.1*kk;
    
    fprintf('\n\n%f\n',K);
    %classlist에 있는 모든 class들에 대해 co-activity검출
    for class = classlist
        close all;
        
        lname =ucf_annotation{(class-1)*nVideos+1}.label;
        
        % label 출력
        fprintf('%s ',lname);
        
        %% Camera Motion Invariant Sampling을 통해 얻어진 co-activity
        
        load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_OFD_',num2str(len),'L1Norm_org.mat']); %NDATA
        density= UCF_KNN(class,len,nodesize,NDATA,nCenters) ;
        density(NDATA<len*0.5) =0;
        
        OFD_make_weight_map_org(nodesize, class, len,density,nCenters);
        load([dmpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenters),'_org.mat']); %density_map
        Threshold=UCF_plot_density_map(density_map,nVideos, class);
        %각 Video별 Density값 그림
        OFD_plot_denstiy_map_org(nodesize, class, len,nCenters,Threshold);
        
        %PR curve를 그리고, Average Precision 계산
        %     OFD_evaluate_per_frame_org(nodesize, class, len,nCenters);
        
        fprintf('\n');
    end
end
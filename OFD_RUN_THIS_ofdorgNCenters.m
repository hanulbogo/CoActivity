function OFD_RUN_THIS_ofdorgNCenters(classlist,spath,npath,nodesize, len)
% classlist=
%비디오 정보(이름, 전체 프레임수 등) 로드
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'

% hpath='./data/OFD_concat_hist/';
% spath ='./data/OFD_seg_hists/';
% dmpath ='./data/OFD_density_map/';
% npath ='./data/OFD_L1NORM_seg_hists/';

%카테고리별 비디오 갯수
nVideos=25;

%BoW의 Codeword 갯수
% nCenters =50;
cnt=1;
nCenters =4000;
nc=7;
NC=7;
cumacc= zeros(1001,1);
cumacc_org= zeros(1001,1);
%classlist에 있는 모든 class들에 대해 co-activity검출
for class = classlist
    
    close all;
    %
    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    
    % label 출력
    fprintf('%s ',lname);
%     %
    % %     %sub-video들의 histogram을 L1-Normalization해서 저장하는 함수
    % %     L1Normalization_SEGHISTS(nodesize, class, len,spath, npath,1,NC);
    % %
    %     %이번 class에 해당하는 sub-video들의 histogram 추출
%     load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_OFD_',num2str(len),'L1Norm_ofd.mat']);
    %
    nc=1;
%     density= OFD_ParzenWindow_ofd(class,TDATA{nc}, HOGDATA{nc}, HOGFDATA{nc}, OFDLDATA{nc}, OFDRDATA{nc}, OFDTDATA{nc}, OFDBDATA{nc},OFDADATA{nc}, OFDCDATA{nc},HOFDATA{nc}, MBHxDATA{nc}, MBHyDATA{nc},len,nodesize,NDATA,nCenters) ;
%     
%     %     Sub-video에서 추출된 trajectory feature가 길이의 반정도도 안되면 삭제
%     density(NDATA<len*.5) =0;
%     %
%     OFD_make_weight_map_ofd(nodesize, class, len,density,nCenters);
%     OFD_plot_denstiy_map_ofd(nodesize, class, len,nCenters);
%     %     OFD_evaluate_per_frame_ofd(nodesize, class, len,nCenters);
%     %     OFD_evaluate_per_segments_ofd(nodesize,nVideos, class, len,nCenters);


%         cumacc= OFD_evaluate_per_segments_ofd_find_best_th(nodesize,nVideos, class, len,nCenters,cumacc);
    %     OFD_video_write(nodesize,class,len,nCenters(nc),nVideos)
    
    
    %     L1Normalization_SEGHISTS(nodesize, class, len,spath, npath,2)
        load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_OFD_',num2str(len),'L1Norm_org.mat']);
    %
%         density= OFD_ParzenWindow_org(class,TDATA{nc}, HOGDATA{nc}, HOGFDATA{nc}, OFDLDATA{nc}, OFDRDATA{nc}, OFDTDATA{nc}, OFDBDATA{nc},OFDADATA{nc}, OFDCDATA{nc},HOFDATA{nc}, MBHxDATA{nc}, MBHyDATA{nc},len,nodesize,NDATA,nCenters);
%         density(NDATA<len*.5) =0;
%         OFD_make_weight_map_org(nodesize, class, len,density,nCenters(nc));
% %         cumacc_org= OFD_evaluate_per_segments_org_find_best_th(nodesize,nVideos, class, len,nCenters,cumacc_org);
        OFD_plot_denstiy_map_org(nodesize, class, len,nCenters(nc));
        OFD_evaluate_per_frame_org(nodesize, class, len,nCenters(nc));
            OFD_video_write(nodesize,class,len,nCenters(nc),nVideos)
        
    %
    cnt=cnt+1;
    fprintf('\n');
end
% [val th]=max(cumacc);
% fprintf('average acc : %.2f theshold th %d', val/101, th);
[val th]=max(cumacc_org);
fprintf('org_average acc : %.2f theshold th %d', val/10, th);
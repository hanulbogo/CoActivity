% 비디오가 저장되어있는 폴더
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
% 
% for class =classlist
%     
%     %DenseSampling할때 얻은 trajectory중 주변과의 움직임 차의 값을 계산한 것이 2이상일때 feature로 이용
%     SamplingThreshold =2;
%     %4개의 비디오의 feature를  OFD_make_new_ann에서 결정한 순서대로 이어 붙이는 단계
%     OFD_make_con_feats_50(SamplingThreshold ,class,fpath, cpath);
%     
%     %4개의 비디오를 SlidingWindow step size 크기로 나눠서 histogram을 생성
%     %(sub-video의 histogram을 빠르게 만들기 위한 방법)
%     %우리가 제안한 Camera motion invariant sampling 방법으로 뽑은 feature
%     OFD_make_nodes(nodesize,class,cpath, hpath);
%     
%     %DenseTrajectory feature의 orginal sampling방법으로 뽑은 feature
%     OFD_make_nodes_org(nodesize,class,cpath, hpath);
% end

% co-activity를 찾는 function
CoActDiscovery_Main(classlist,hpath,spath, dmpath, npath,nodesize, len)
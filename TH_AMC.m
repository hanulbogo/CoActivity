function density=TH_AMC(TDATA, HOGDATA,HOFDATA,MBHDATA,class,len,nodesize,nData,nCenter) %data : N*D
dpath = './data/TH_dists/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end
load('./data/TH_nVideos.mat');%nVideolist
load('./data/TH_annotation.mat');%'TH_annotation'
dists = cell(12,1);

nVideos=nVideolist(class);
nnodes = zeros(nVideos,1);

for v=1:nVideos
    aidx =sum(nVideolist(1:(class-1)))+v;
    nnodes(v) =(ceil(TH_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
end


if ~exist([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'file')

    fprintf('Trajectory %d\n',nCenter);

    dists{1} =PW_paralleldists_multi_vid(TDATA','CHI2'); %D*N
	dists{2} =PW_paralleldists_multi_vid(HOGDATA','CHI2'); %D*N
	dists{3} =PW_paralleldists_multi_vid(HOFDATA','CHI2'); %D*N
	dists{4} =PW_paralleldists_multi_vid(MBHDATA','CHI2'); %D*N
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists','-v7.3');

else
    load([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat']);
end


didx =1:4;

mask= ones(size(dists{1}));

%% 같은 video 사이의 connection 제거 mask
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));    
    mask(startidx:endidx,startidx:endidx) =0;
end

mask(nData<len*.5,:)=0;
mask(:,nData<len*.5)=0;
% Kern = PW_calc_Kern_from_dist_one_vid(dists,didx);
Kern =KernMask(dists,didx,mask);

Kern(nData<len*.5,:)=0;
Kern(:,nData<len*.5)=0;

% MK=mean(Kern(:));
% Kern(Kern<MK)= 0;
Kern =Kern.*mask;
step =len/nodesize;
%% Temporal Mask
tempKern = zeros(size(mask));
for i=1:length(Kern)
    tempKern(i,[max(1,i-step*1):i-1, i+1:min(i+step*1,length(Kern))] )=1;
end
tempKern=tempKern(1:length(Kern),1:length(Kern));
tempKern= tempKern+tempKern';
tempKern=tempKern.*(1-mask);
tempKern(tempKern>=1)=1;


global mname;
if strcmp(mname,'AMC')
    x = AMC_MeanTemp(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5),mask(nData>=len*.5,nData>=len*.5));
elseif strcmp(mname,'AMC-')
    x = AMC_Mean(Kern(nData>=len*.5,nData>=len*.5),mask(nData>=len*.5,nData>=len*.5));
elseif strcmp(mname,'PR')
    x= PageRankTemp(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5));
end


%  x = AMC(Kern(nData>=len*.5,nData>=len*.5));
 x= normalize(x);
 density = zeros(size(nData));
 density(nData>=len*.5) = x;
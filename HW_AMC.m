function density=HW_AMC(TDATA, HOGDATA,HOFDATA,MBHxDATA,MBHyDATA, class,len,nodesize,nData,nCenter) %data : N*D
dpath = './data/HW_dists/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end
load('./data/HW_nVideos.mat');%nVideolist
load('./data/HW_annotation.mat');%'HW_annotation'
dists = cell(12,1);

nVideos=nVideolist(class);
nnodes = zeros(nVideos,1);

for v=1:nVideos
    aidx =sum(nVideolist(1:(class-1)))+v;
    nnodes(v) =(ceil(HW_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
end


if ~exist([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'file')

    fprintf('Trajectory %d\n',nCenter);

    dists{1}=PW_paralleldists_multi_vid(TDATA','CHI2'); %D*N

	dists{3} = PW_paralleldists_multi_vid(HOGDATA','CHI2'); %D*N
	dists{10} =PW_paralleldists_multi_vid(HOFDATA','CHI2'); %D*N
	dists{11} =PW_paralleldists_multi_vid(MBHxDATA','CHI2'); %D*N
	dists{12} =PW_paralleldists_multi_vid(MBHyDATA','CHI2'); %D*N
    save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');

else
    load([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat']);
end


didx =[1,3,10,11,12];%1:12;%[1,3,10,11,12];%[4:8];%[2,8];%[3,8];%[2,3,8];%[2,8];%[1,3,10,11,12];%[4:8];%8;%9;%[4:7];%[3:8,11:12];%[2,4:8,11:12];%[2:9,11:12];%2:12;%1:12;
%[2:9,11:12];

% sum(nVideolist(1:(class-1)))



mask= ones(size(dists{1}));

%% 같은 video 사이의 connection 제거 mask
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    
    mask(startidx:endidx,startidx:endidx) =0;
end

mask(nData<len*.5,:)=0;
mask(:,nData<len*.5)=0;

Kern =KernMask(dists,didx,mask);


Kern(nData<len*.5,:)=0;
Kern(:,nData<len*.5)=0;

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
    x = PageRankTemp(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5));
end
 x= normalize(x);
 density = zeros(size(nData));
 density(nData>=len*.5) = x;
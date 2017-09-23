function density=UT_AMC_Stepsize(TDATA, HOGDATA,HOFDATA,MBHxDATA,MBHyDATA, class,len,nodesize,nData,nCenter,stepsize) %data : N*D
dpath = './data/UT_dists/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end
load('./data/UT_nVideos.mat');%nVideolist
load('./data/UT_annotation.mat');%'UT_annotation'
dists = cell(12,1);

nVideos=nVideolist(class);
nnodes = zeros(nVideos,1);
 
for v=1:nVideos
    aidx =sum(nVideolist(1:(class-1)))+v;
    nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
end
if ~exist([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'file')
    dists{1}=PW_paralleldists_multi_vid(TDATA','CHI2'); %D*N
	dists{3} = PW_paralleldists_multi_vid(HOGDATA','CHI2'); %D*N
	dists{10} =PW_paralleldists_multi_vid(HOFDATA','CHI2'); %D*N
	dists{11} =PW_paralleldists_multi_vid(MBHxDATA','CHI2'); %D*N
	dists{12} =PW_paralleldists_multi_vid(MBHyDATA','CHI2'); %D*N
    save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
else
    load([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat']);
end

didx =[1,3,10,11,12];
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

step =floor(len/nodesize);
tempKern = zeros(size(Kern));
for i=1:length(Kern)
    tempKern(i,[max(1,i-step*1):i-1, i+1:min(i+step*1,length(Kern))] )=1;
end

tempKern=tempKern(1:length(Kern),1:length(Kern));
tempKern= tempKern+tempKern';
tempKern=tempKern.*(1-mask);
tempKern(tempKern>=1)=1;

allind=[];
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    allind =[allind,startidx:stepsize/10:endidx];
end
Kern =Kern(allind,allind);
nData=nData(allind);
tempKern = tempKern(allind,allind);
mask = mask(allind,allind);
x = AMC_MeanTemp(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5),mask(nData>=len*.5,nData>=len*.5));


%  x = AMC(Kern(nData>=len*.5,nData>=len*.5));
 x= normalize(x);
 density = zeros(size(nData));
 density(nData>=len*.5) = x;
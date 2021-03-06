function density=UT_AMC(class,len,stepsize,lname)
global dpath;
global npath;
pdpath = [dpath,'UT_dists/'];
if ~exist(pdpath,'dir')
    mkdir(pdpath);
end
load([dpath,'UT_nVideos.mat']);%nVideolist
load([dpath,'UT_annotation.mat']);%'UT_annotation'
load([npath,lname,'_stepsize_',num2str(stepsize), '_subsequence_len_',num2str(len),'.mat']); %'NDATA','TDATA','HOGDATA','HOFDATA','MBHxDATA','MBHyDATA'

nVideos=nVideolist(class);
nnodes = zeros(nVideos,1);

for v=1:nVideos
    aidx =sum(nVideolist(1:(class-1)))+v;
    nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/stepsize)*stepsize - len)/stepsize +1;
end


% Pairwise distances of all subsequences
dists = cell(5,1);
if ~exist([pdpath, 'Dists_class_',num2str(class),'_stepsize_',num2str(stepsize),'_len_',num2str(len),'.mat'],'file')
    fprintf('Trajectory\n');
    dists{1}=PW_paralleldists_multi_vid(TDATA','CHI2'); %D*N
    fprintf('HOG\n');
	dists{2} = PW_paralleldists_multi_vid(HOGDATA','CHI2'); %D*N
    fprintf('HOF\n');
	dists{3} =PW_paralleldists_multi_vid(HOFDATA','CHI2'); %D*N
	fprintf('MBHx\n');
    dists{4} =PW_paralleldists_multi_vid(MBHxDATA','CHI2'); %D*N
	fprintf('MBHy\n');
	dists{5} =PW_paralleldists_multi_vid(MBHyDATA','CHI2'); %D*N
    save([pdpath, 'Dists_class_',num2str(class),'_stepsize_',num2str(stepsize),'_len_',num2str(len),'.mat'],'dists');
else
    load([pdpath, 'Dists_class_',num2str(class),'_stepsize_',num2str(stepsize),'_len_',num2str(len),'.mat']);
end


mask= ones(size(dists{1}));

%% Eliminate connection between same videos
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    mask(startidx:endidx,startidx:endidx) =0;
end
% If the number of trajectories in the subsequence is smaller than len*.5, then ignore it
mask(NDATA<len*.5,:)=0;
mask(:,NDATA<len*.5)=0;

%% Distance to Weights
Kern =KernMask(dists,mask);
% If the number of trajectories in the subsequence is smaller than len*.5, then ignore it
Kern(NDATA<len*.5,:)=0;
Kern(:,NDATA<len*.5)=0;
% Masking out intra-video connection
Kern =Kern.*mask;
step =len/stepsize;

%% Temporal Mask (temporal connection)
tempKern = zeros(size(mask));

for i=1:length(Kern)
    tempKern(i,[max(1,i-step*1):i-1, i+1:min(i+step*1,length(Kern))] )=1;
end
tempKern=tempKern(1:length(Kern),1:length(Kern));
tempKern= tempKern+tempKern';
tempKern=tempKern.*(1-mask);
tempKern(tempKern>=1)=1;


%% Absorbing Markov chain (and other algorithms)
global mname;
if strcmp(mname,'AMC')
    x = AMC_MeanTemp(Kern(NDATA>=len*.5,NDATA>=len*.5),tempKern(NDATA>=len*.5,NDATA>=len*.5),mask(NDATA>=len*.5,NDATA>=len*.5));
elseif strcmp(mname,'AMC-')
    x = AMC_Mean(Kern(NDATA>=len*.5,NDATA>=len*.5),mask(NDATA>=len*.5,NDATA>=len*.5));
elseif strcmp(mname,'PR')
    x= PageRankTemp(Kern(NDATA>=len*.5,NDATA>=len*.5),tempKern(NDATA>=len*.5,NDATA>=len*.5));
end

 x= normalize(x);
 density = zeros(size(NDATA));
 density(NDATA>=len*.5) = x;
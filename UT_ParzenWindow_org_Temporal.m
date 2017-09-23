function density=UT_ParzenWindow_org_Temporal(class,len,nodesize,nData,nCenter) %data : N*D
dpath = './data/UT_dists/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end

dists = cell(12,1);

if ~exist([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'file')
    fprintf('Trajectory %d\n',nCenter);
    tic;
    dists{1}=PW_paralleldists_multi_vid(TDATA','CHI2'); %D*N
    toc;
%     fprintf('HOGF%d\n',nCenter);
%     tic;
% 	dists{2}=PW_paralleldists_multi_vid(HOGFDATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('HOG%d\n',nCenter);
    tic;
	dists{3} = PW_paralleldists_multi_vid(HOGDATA','CHI2'); %D*N
    toc;
%     fprintf('OFDL%d\n',nCenter);
%     tic;
% 	dists{4} = PW_paralleldists_multi_vid(OFDLDATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('OFDR%d\n',nCenter);
%     tic;
% 	dists{5} =PW_paralleldists_multi_vid(OFDRDATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('OFDT%d\n',nCenter);
%     tic;
% 	dists{6} =	PW_paralleldists_multi_vid(OFDTDATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('OFDB%d\n',nCenter);
%     tic;
% 	dists{7} =PW_paralleldists_multi_vid(OFDBDATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('OFDA%d\n',nCenter);
%     tic;
% 	dists{8} =PW_paralleldists_multi_vid(OFDADATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('OFDC%d\n',nCenter);
%     tic;
% 	dists{9} =PW_paralleldists_multi_vid(OFDCDATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('HOF%d\n',nCenter);
%     tic;
	dists{10} =PW_paralleldists_multi_vid(HOFDATA','CHI2'); %D*N
%     toc;
    fprintf('MBHx%d\n',nCenter);
%     tic;
	dists{11} =PW_paralleldists_multi_vid(MBHxDATA','CHI2'); %D*N
%     toc;
	fprintf('MBHy%d\n',nCenter);
%     tic;
	dists{12} =PW_paralleldists_multi_vid(MBHyDATA','CHI2'); %D*N
    save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
else
    load([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat']);
end

for i=1:12
   dists{i}(nData<len*.5,:)=2;
   dists{i}(:,nData<len*.5)=2;
%    dists{i}(nData<len,:)=2;
%    dists{i}(:,nData<len)=2;
end
load('./data/UT_annotation.mat');%'UT_annotation'
didx =[1,3,10,11,12];%1:12;%[1,3,10,11,12];%[4:8];%[2,8];%[3,8];%[2,3,8];%[2,8];%[1,3,10,11,12];%[4:8];%8;%9;%[4:7];%[3:8,11:12];%[2,4:8,11:12];%[2:9,11:12];%2:12;%1:12;
%[2:9,11:12];

Kern = PW_calc_Kern_from_dist_one_vid(dists,didx);


Kern(nData<len*.5,:)=0;
Kern(:,nData<len*.5)=0;

nVideos=10;
nnodes = zeros(nVideos,1);

for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
end
mask= ones(size(Kern));

%% 같은 video 사이의 connection 제거 mask
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    
    mask(startidx:endidx,startidx:endidx) =0;
end

% MK=mean(Kern(:));
% Kern(Kern<MK)= 0;
Kern =Kern.*mask;
step =len/nodesize;
%% Temporal Mask
tempKern = zeros(size(mask));
for i=1:length(Kern)
    if i> step && i<length(Kern)-step
        tempKern(i,[max(1,i-step*1):i-step*1,i+step*1:min(i+step*1,length(Kern)) ])=1;
    elseif i<=step
        tempKern(i,i+step*1:i+step*1)=1;
    else
        tempKern(i,i-step*1:i-step)=1;
    end
end
% for i=1:length(Kern)
%     if i> step && i<length(Kern)-step
%         tempKern(i,[max(1,i-step*3):i-step*1,i+step*1:min(i+step*3,length(Kern)) ])=1;
%     elseif i<=step
%         tempKern(i,i+step*1:i+step*3)=1;
%     else
%         tempKern(i,i-step*3:i-step)=1;
%     end
% end
tempKern=tempKern(1:length(Kern),1:length(Kern));
tempKern= tempKern+tempKern';
tempKern=tempKern.*(1-mask);

 x = PageRankTemp(Kern(nData>=len*.5,nData>=len*.5), mask(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5));
 density = zeros(size(nData));
 density(nData>=len*.5) = x;
 

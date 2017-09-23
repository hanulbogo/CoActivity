function [density ]=UT_ParzenWindow_ofd(class,TDATA,HOGFDATA, HOGDATA, OFDLDATA, OFDRDATA, OFDTDATA, OFDBDATA, OFDADATA, OFDCDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,nData,nCenter)  %data : N*D
dpath = './data/UT_dists/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end

dists = cell(12,1);

if ~exist([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_ofd.mat'],'file')
%     fprintf('Trajectory %d\n',nCenter);
%     tic;
    dists{1}=PW_paralleldists_multi_vid(TDATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('HOGF%d\n',nCenter);
%     tic;
% 	dists{2}=PW_paralleldists_multi_vid(HOGFDATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('HOG%d\n',nCenter);
%     tic;
	dists{3} = PW_paralleldists_multi_vid(HOGDATA','CHI2',class,1); %D*N
%     toc;
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
	dists{10} =PW_paralleldists_multi_vid(HOFDATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('MBHx%d\n',nCenter);
%     tic;
	dists{11} =PW_paralleldists_multi_vid(MBHxDATA','CHI2',class,1); %D*N
%     toc;
%     fprintf('MBHy%d\n',nCenter);
%     tic;
	dists{12} =PW_paralleldists_multi_vid(MBHyDATA','CHI2',class,1); %D*N
    save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_ofd.mat'],'dists');
else
    load([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_ofd.mat']);
end

% for i=1:12
%    dists{i}(nData<len*.5,:)=2;
%    dists{i}(:,nData<len*.5)=2;
% end
load('./data/UT_annotation.mat');%'UT_annotation'
didx =[1,3,10,11,12];
%[1,3,10,11,12];%[1,2,4:7,10,11,12];%1:12;%[1,3,10,11,12];%[4:8];%[2,8];%[3,8];%[2,3,8];%[2,8];%[1,3,10,11,12];%[4:8];%8;%9;%[4:7];%[3:8,11:12];%[2,4:8,11:12];%[2:9,11:12];%2:12;%1:12;
%[2:9,11:12];
Kern = PW_calc_Kern_from_dist_one_vid(dists,didx);
% D = zeros(size(dists{1}));
% for i=1:5
%     D = D+dists{i};
% end
nVideos=10;
nnodes = zeros(nVideos,1);


for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
end
mask= ones(size(Kern));
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    mask(startidx:endidx,startidx:endidx) =0;
end
Kern =Kern.*mask;
% % 
Kern(nData<len*.5,:)=0;
Kern(:,nData<len*.5)=0;
% 
% density = zeros(1,length(Kern));
% MPairs = zeros(length(Kern),nVideos,2);
% for sub = 1: length(Kern)
%     for v=1:nVideos
%         startidx = sum(nnodes(1:v-1))+1;
%         endidx = sum(nnodes(1:v));
% %         [maxval midx] =max(Kern(startidx:endidx,sub));
%         [maxval midx] =sort(Kern(startidx:endidx,sub),'descend');
% %         density(sub)=density(sub)+maxval;
%         density(startidx+midx(1:25)-1)=density(startidx+midx(1:25)-1)+maxval(1:25)';
% %         MPairs(sub, v,1)=midx;
% %         MPairs(sub, v,2)=maxval;
% %         
%     end
% end
density = zeros(1,length(Kern));
for i = 1:length(Kern)
  
    Ki =Kern(i,:);
  
  density(i) =std(Ki(Ki~=0));
end

density(~isnan(density)) = exp(-((density(~isnan(density))/(mean(density(~isnan(density))))).^(-1)));
density(isnan(density))=0;
% 
% k=25;
% 
% %% KNN
% k=5;
% mask= zeros(size(Kern));
% for sub = 1: length(Kern)
%     for v=1:nVideos
%         startidx = sum(nnodes(1:v-1))+1;
%         endidx = sum(nnodes(1:v));
% %         k=ceil(nnodes(v)*0.9);
%         [maxval midx] =sort(Kern(sub,startidx:endidx),'descend');
%         mask(sub,startidx+midx(1:k)-1)=1;
%           mask(startidx+midx(1:k)-1,sub)=1;
%     end
% end
% % figure;imshow(mask);
% Kern = Kern.*mask;

% 
% %% Thresholding
% th=0.35;
% Kern(Kern<th)=0;

% density = density/(nVideos-1);

% figure;
% imshow(Kern,[]);
% hold on;
% ginput(1);
% hold off;
% Kern(Kern<0.001)=0; aP 71 but non core score 0
% Kern(Kern<0.0001)=0; aP 76 but non core also has some value
% density =zeros(length(Kern),1);
% for i=1:length(Kern)
%     for v=1:nVideos
%         startidx = sum(nnodes(1:v-1))+1;
%         endidx = sum(nnodes(1:v));
%         density(i) =density(i)+ max(Kern(startidx:endidx,i));
%     end
% end

% 
% density =sum(Kern)./sum(mask);


 x = PageRank(Kern, density);
 density = x;
% density =density.*(sum(Kern)./sum(mask));
% density(isnan(density))=0;




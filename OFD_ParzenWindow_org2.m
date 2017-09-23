function density=OFD_ParzenWindow_org2(class,TDATA,HOGFDATA, HOGDATA, OFDLDATA, OFDRDATA, OFDTDATA, OFDBDATA, OFDADATA, OFDCDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,nData,nCenter) %data : N*D
dpath = './data/OFD_dists_TWO/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end

dists = cell(12,1);

if ~exist([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'file')
    fprintf('Trajectory %d\n',nCenter);
    tic;
    dists{1}=PW_paralleldists_multi_vid(TDATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('HOGF%d\n',nCenter);
    tic;
	dists{2}=PW_paralleldists_multi_vid(HOGFDATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('HOG%d\n',nCenter);
    tic;
	dists{3} = PW_paralleldists_multi_vid(HOGDATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('OFDL%d\n',nCenter);
    tic;
	dists{4} = PW_paralleldists_multi_vid(OFDLDATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('OFDR%d\n',nCenter);
    tic;
	dists{5} =PW_paralleldists_multi_vid(OFDRDATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('OFDT%d\n',nCenter);
    tic;
	dists{6} =	PW_paralleldists_multi_vid(OFDTDATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('OFDB%d\n',nCenter);
    tic;
	dists{7} =PW_paralleldists_multi_vid(OFDBDATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('OFDA%d\n',nCenter);
    tic;
	dists{8} =PW_paralleldists_multi_vid(OFDADATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('OFDC%d\n',nCenter);
    tic;
	dists{9} =PW_paralleldists_multi_vid(OFDCDATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('HOF%d\n',nCenter);
    tic;
	dists{10} =PW_paralleldists_multi_vid(HOFDATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('MBHx%d\n',nCenter);
    tic;
	dists{11} =PW_paralleldists_multi_vid(MBHxDATA','CHI2',class,1); %D*N
    toc;
	save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
    fprintf('MBHy%d\n',nCenter);
    tic;
	dists{12} =PW_paralleldists_multi_vid(MBHyDATA','CHI2',class,1); %D*N
    save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat'],'dists');
else
    load([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenter),'_org.mat']);
end

for i=1:12
   dists{i}(nData<len*.5,:)=2;
   dists{i}(:,nData<len*.5)=2;
end
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
didx =[1,3,10,11,12];%1:12;%[1,3,10,11,12];%[4:8];%[2,8];%[3,8];%[2,3,8];%[2,8];%[1,3,10,11,12];%[4:8];%8;%9;%[4:7];%[3:8,11:12];%[2,4:8,11:12];%[2:9,11:12];%2:12;%1:12;
%[2:9,11:12];
Kern = PW_calc_Kern_from_dist_one_vid(dists,didx);
% D = zeros(size(dists{1}));
% for i=1:5
%     D = D+dists{i};
% end
nVideos=25;
nnodes = zeros(nVideos,1);


for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end
mask= ones(size(Kern));
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    mask(startidx:endidx,startidx:endidx) =0;
end
Kern =Kern.*mask;

Kern(nData<len*.5,:)=0;
Kern(:,nData<len*.5)=0;


% figure;
% imshow(Kern,[]);
% hold on;
% ginput(1);
% hold off;
% Kern(Kern<0.001)=0; aP 71 but non core score 0
% Kern(Kern<0.0001)=0; aP 76 but non core also has some value


density =sum(Kern)./sum(mask);


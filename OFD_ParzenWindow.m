function density=OFD_ParzenWindow(class,TDATA,HOGFDATA, HOGDATA, OFDLDATA, OFDRDATA, OFDTDATA, OFDBDATA, OFDADATA, OFDCDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,nData) %data : N*D
dpath = './data/OFD_dists50/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end

dists = cell(12,1);

if ~exist([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'.mat'],'file')
    fprintf('Trajectory \n');
    tic;
    dists{1} = pdist2(TDATA,TDATA,@chi2dist); %N*D
    toc;
    fprintf('HOGF\n');
    tic;
    dists{2} = pdist2(HOGFDATA,HOGFDATA,@chi2dist); %N*D
    toc;
    fprintf('HOG\n');
    tic;
    dists{3} = pdist2(HOGDATA,HOGDATA,@chi2dist); %N*D
    toc;
    fprintf('OFDL\n');
    tic;
    dists{4} = pdist2(OFDLDATA,OFDLDATA,@chi2dist); %N*D
    toc;
    fprintf('OFDR\n');
    tic;
    dists{5} = pdist2(OFDRDATA,OFDRDATA,@chi2dist); %N*D
    toc;
    fprintf('OFDT\n');
    tic;
    dists{6} = pdist2(OFDTDATA,OFDTDATA,@chi2dist); %N*D
    toc;
    fprintf('OFDB\n');
    tic;
    dists{7} = pdist2(OFDBDATA,OFDBDATA,@chi2dist); %N*D
    toc;
    fprintf('OFDA\n');
    tic;
    dists{8} = pdist2(OFDADATA,OFDADATA,@chi2dist); %N*D
    toc;
    fprintf('OFDC\n');
    tic;
    dists{9} = pdist2(OFDCDATA,OFDCDATA,@chi2dist); %N*D
    toc;
    fprintf('HOF\n');
    tic;
    dists{10} = pdist2(HOFDATA,HOFDATA,@chi2dist); %N*D
    toc;
    fprintf('MBHx\n');
    tic;
    dists{11} = pdist2(MBHxDATA,MBHxDATA,@chi2dist); %N*D
    toc;
    fprintf('MBHy\n');
    tic;
    dists{12} = pdist2(MBHyDATA,MBHyDATA,@chi2dist); %N*D
    toc;
    save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'.mat'],'dists');
else
    load([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'.mat']);
end

for i=1:12
   dists{i}(nData<len*.5,:)=2;
   dists{i}(:,nData<len*.5)=2;
end
load('./data/OFD_ucf50_annotation.mat');%'ucf_annotation'
didx =[3,4:7];%1:12;%[1,3,10,11,12];%[4:8];%[2,8];%[3,8];%[2,3,8];%[2,8];%[1,3,10,11,12];%[4:8];%8;%9;%[4:7];%[3:8,11:12];%[2,4:8,11:12];%[2:9,11:12];%2:12;%1:12;
%[2:9,11:12];
Kern = PW_calc_Kern_from_dist_one_vid(dists,didx);
% D = zeros(size(dists{1}));
% for i=1:5
%     D = D+dists{i};
% end
nVideos=50;
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


figure;
imshow(Kern,[]);
hold on;
ginput(1);
hold off;
% Kern(Kern<0.001)=0; aP 71 but non core score 0
% Kern(Kern<0.0001)=0; aP 76 but non core also has some value


density =sum(Kern)./sum(mask);


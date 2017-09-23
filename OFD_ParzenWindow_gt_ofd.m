function OFD_ParzenWindow_gt_ofd(class,TDATA,HOGFDATA, HOGDATA, OFDLDATA, OFDRDATA, OFDTDATA, OFDBDATA, OFDADATA, OFDCDATA, HOFDATA, MBHxDATA, MBHyDATA,nCenter) %data : N*D
dpath = './data/OFD_dists_TWO_gt/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end
nVideos=25;
dists = cell(12,1);

if ~exist([dpath, 'Dists_class_',num2str(class),'_',num2str(nCenter),'_ofd.mat'],'file')
    fprintf('Trajectory %d\n',nCenter);
    tic;
    dists{1}=PW_paralleldists_multi_vid(TDATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('HOGF%d\n',nCenter);
    tic;
	dists{2}=PW_paralleldists_multi_vid(HOGFDATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('HOG%d\n',nCenter);
    tic;
	dists{3} = PW_paralleldists_multi_vid(HOGDATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('OFDL%d\n',nCenter);
    tic;
	dists{4} = PW_paralleldists_multi_vid(OFDLDATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('OFDR%d\n',nCenter);
    tic;
	dists{5} =PW_paralleldists_multi_vid(OFDRDATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('OFDT%d\n',nCenter);
    tic;
	dists{6} =	PW_paralleldists_multi_vid(OFDTDATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('OFDB%d\n',nCenter);
    tic;
	dists{7} =PW_paralleldists_multi_vid(OFDBDATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('OFDA%d\n',nCenter);
    tic;
	dists{8} =PW_paralleldists_multi_vid(OFDADATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('OFDC%d\n',nCenter);
    tic;
	dists{9} =PW_paralleldists_multi_vid(OFDCDATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('HOF%d\n',nCenter);
    tic;
	dists{10} =PW_paralleldists_multi_vid(HOFDATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('MBHx%d\n',nCenter);
    tic;
	dists{11} =PW_paralleldists_multi_vid(MBHxDATA','CHI2',class,1); %D*N
    toc;
	
    fprintf('MBHy%d\n',nCenter);
    tic;
	dists{12} =PW_paralleldists_multi_vid(MBHyDATA','CHI2',class,1); %D*N
    save([dpath, 'Dists_class_',num2str(class),'_',num2str(nCenter),'_ofd.mat'],'dists');
else
    load([dpath, 'Dists_class_',num2str(class),'_',num2str(nCenter),'_ofd.mat']);
end

load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
didx =[1,3,10,11,12];%[1,2,4:7,10,11,12];%1:12;%[1,3,10,11,12];%[4:8];%[2,8];%[3,8];%[2,3,8];%[2,8];%[1,3,10,11,12];%[4:8];%8;%9;%[4:7];%[3:8,11:12];%[2,4:8,11:12];%[2:9,11:12];%2:12;%1:12;
%[2:9,11:12];
Kern = PW_calc_Kern_from_dist_one_vid_for_draw(dists,didx);
% D = zeros(size(dists{1}));
% for i=1:5
%     D = D+dists{i};


for i=1:length(Kern)
    Kern(i,i)=0;
    
end
for i=1:nVideos
    Kern(4*(i-1)+1:4*i,4*(i-1)+1:4*i)=0;
end


% Kern(nData<len*.5,:)=0;
% Kern(:,nData<len*.5)=0;
% 
KernImg=  OFD_Kern_imresize(Kern,10);
OFD_gt_boxing(Kern,KernImg,class,10);


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


% density =max(Kern);%sum(Kern)./sum(mask);


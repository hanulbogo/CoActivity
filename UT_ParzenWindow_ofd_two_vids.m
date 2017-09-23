function density=UT_ParzenWindow_ofd_two_vids(class,TDATA,HOGFDATA, HOGDATA, OFDLDATA, OFDRDATA, OFDTDATA, OFDBDATA, OFDADATA, OFDCDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,nData,nCenter,vidx)  %data : N*D

dists = cell(12,1);

nVideos=10;
nnodes = zeros(nVideos,1);


for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
end

for v=1:nVideos
    
    if vidx(1)==v
        startidx(1) = sum(nnodes(1:v-1))+1;
        endidx(1) = sum(nnodes(1:v));
    end
    if vidx(2)==v
        startidx(2) = sum(nnodes(1:v-1))+1;
        endidx(2) = sum(nnodes(1:v));
    end
end

TDATA =TDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
HOGFDATA =HOGFDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
HOGDATA =HOGDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
OFDLDATA =OFDLDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
OFDRDATA =OFDRDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
OFDTDATA =OFDTDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
OFDBDATA =OFDBDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
OFDADATA =OFDADATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
OFDCDATA =OFDCDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
HOFDATA =HOFDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
MBHxDATA =MBHxDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);
MBHyDATA =MBHyDATA([startidx(1):endidx(1), startidx(2):endidx(2)],:);

nData=nData([startidx(1):endidx(1), startidx(2):endidx(2)]);

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


for i=1:12
   dists{i}(nData<len*.5,:)=2;
   dists{i}(:,nData<len*.5)=2;
end
load('./data/UT_annotation.mat');%'UT_annotation'
didx =[1,3,5,10,11,12];
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


mask(1:nnodes(vidx(1)),1:nnodes(vidx(1))) =0;

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
% density =zeros(length(Kern),1);
% for i=1:length(Kern)
%     for v=1:nVideos
%         startidx = sum(nnodes(1:v-1))+1;
%         endidx = sum(nnodes(1:v));
%         density(i) =density(i)+ max(Kern(startidx:endidx,i));
%     end
% end


density =sum(Kern)./sum(mask);


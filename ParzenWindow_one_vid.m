function [maxitv1 maxitv2]=ParzenWindow_one_vid(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,vididx) %data : N*D
Kpath ='./data/dists_one_normalized/';
if ~exist(Kpath,'dir')
    mkdir(Kpath);
end
kimgpath = './data/kernel_img_one/';
if ~exist(kimgpath,'dir');
    mkdir(kimgpath);
end
if ~exist([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'nodesize_',num2str(nodesize),'_len_',num2str(len),'_two_videos.mat'],'file') 
    dists{1}=PW_paralleldists_two_videos(TDATA','CHI2',class,1);
    dists{2}=PW_paralleldists_two_videos(HOGDATA','CHI2',class,2);
    dists{3}=PW_paralleldists_two_videos(HOFDATA','CHI2',class,3);
    dists{4}=PW_paralleldists_two_videos(MBHxDATA','CHI2',class,4);
    dists{5}=PW_paralleldists_two_videos(MBHyDATA','CHI2',class,5);
    save([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'nodesize_',num2str(nodesize),'_len_',num2str(len),'_two_videos.mat'],'dists');
else
        load([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'nodesize_',num2str(nodesize),'_len_',num2str(len),'_two_videos.mat']);%'dists'
end
Kern = PW_calc_Kern_from_dist_one_vid(dists);
% Kern =Kern1;
% tmpKern=[Kern1(:)';Kern2(:)';Kern4(:)';Kern4(:)';Kern5(:)'];
% maxKern= max(tmpKern);
% Kern = reshape(maxKern, size(Kern1,1),size(Kern1,2));



load('./data/ucf_one_annotation.mat');%'ucf_annotation'

% load(['./data/Kernel/',num2str(class),'.mat']);%,'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');


nVideos=25;
nnodes = zeros(nVideos,1);

for v=vididx
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end
% h=figure; imshow(uint8(Kern*255));
% print(h,'-dpdf',[kimgpath,ucf_annotation{aidx}.label,'_two_videos.pdf']);
% close(h);

% total_nodes =  sum(nnodes);
% mask=ones(total_nodes,total_nodes);
for v=vididx
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
%     mask(startidx:endidx,startidx:endidx) =0;
end
% idx =1:total_nodes;
% kidx=idx(sumhists>=len);
% Kern = Kern(kidx,:);
% Kern = Kern(:,kidx);
% mask =mask(kidx,:);
% mask =mask(:,kidx);
% Ncut(Kern,len,mask,nnodes,vididx);
% Kern = Kern.*mask;

% density =sum(Kern); %1*N
D= zeros(size(dists{1}));
for i =1:5
    D = D+dists{i};
end
D2= zeros(size(dists{1}));
for i =4:5
    D2 = D2+dists{i};
end
for i=1:2
    v=vididx(i);
    aidx =(class-1)*nVideos+v;
    gt_start(i) =ucf_annotation{aidx}.gt_start(1);
    gt_end(i) =ucf_annotation{aidx}.gt_end(1);
    startidx(i) = sum(nnodes(1:v-1))+1;
    endidx(i) = sum(nnodes(1:v)); 
end
DD2= D2(startidx(1):endidx(1), startidx(2):endidx(2));
DD= D(startidx(1):endidx(1), startidx(2):endidx(2));
% figure;
% imshow(DD,[]);
% hold on;
% drawbox([ceil(gt_start(2)/nodesize), ceil((gt_end(2)-len)/nodesize)+1],[ceil(gt_start(1)/nodesize),ceil((gt_end(1)-len)/nodesize)+1],'g-');
% hold off;
% figure;
% imshow(DD2,[]);
% hold on;
% drawbox([ceil(gt_start(2)/nodesize), ceil((gt_end(2)-len)/nodesize)+1],[ceil(gt_start(1)/nodesize),ceil((gt_end(1)-len)/nodesize)+1],'g-');
% ginput(1);
% hold off;


% KK = D(:);
% KK= KK-mean(KK);
% KK= KK / std(KK);
% KK = reshape(KK,size(Kern));
% HeatMap(KK,'Colormap',colormap(jet(256)));
% figure; 
% imshow(D,[]);
% hold on;
% title('Distance');
% ginput(1);
% hold off;
% close all hidden;
% 
% maxitv1=[1,2];
% maxitv2=[2,3];

[maxitv1 maxitv2]= Find_best_pair_by_all(D, len,nodesize,vididx,class);
% [maxitv1, maxitv2] =Find_best_pair(Kern, mask,len,nodesize,vididx,class,nnodes);
% [maxitv1 maxitv2]= Find_best_pair_by_DP(D,len,nodesize,vididx,class);

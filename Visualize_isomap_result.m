function Visualize_isomap_result(class,len,nodesize,sumhists)
dist=10;
load(['./data/dist/distdist',num2str(class),'_',num2str(1),'.mat']);
ipath ='./data/isomap_res_50/';
if ~exist(ipath,'dir')
    mkdir(ipath);
end
D =zeros(size(dist));
for i = 1:5
    load(['./data/dist/distdist',num2str(class),'_',num2str(i),'.mat']);
    D=D+dist;
end

load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'

nVideos=50;
nnodes = zeros(nVideos,1);

for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end


total_nodes =  sum(nnodes);
mask=zeros(total_nodes,total_nodes);
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    mask(startidx:endidx,startidx:endidx) =v;
end
idx =1:total_nodes;
kidx=idx(sumhists>=len);
mask =mask(kidx,:);
mask =mask(:,kidx);

idxlist =zeros(length(mask),1);
for i=1:size(mask,1)
    idxlist(i) =mask(i,i);
end


for v=1:nVideos
    vid= find(idxlist==v);
    startidx(v) =vid(1);
    endidx(v)= vid(end);
end


% figure;
%         imshow(D,[]);
options.dims = 1:2;

itv = zeros(nVideos,4);
for i=1:nVideos
    aidx= (class-1)*nVideos+i;
    if i~=1
        itv(i,1)=ceil(ucf_annotation{aidx}.gt_start(1)/nodesize)+endidx(i-1);
        itv(i,2) = (ceil(ucf_annotation{aidx}.gt_end(1)/nodesize)*nodesize - len)/nodesize +1+endidx(i-1);
        itv(i,3)=ceil(ucf_annotation{aidx}.gt_start(2)/nodesize)+endidx(i-1);
        itv(i,4) = (ceil(ucf_annotation{aidx}.gt_end(2)/nodesize)*nodesize - len)/nodesize +1+endidx(i-1);
    else
        itv(i,1)=ceil(ucf_annotation{aidx}.gt_start(1)/nodesize);
        itv(i,2) = (ceil(ucf_annotation{aidx}.gt_end(1)/nodesize)*nodesize - len)/nodesize +1;
        itv(i,3)=ceil(ucf_annotation{aidx}.gt_start(2)/nodesize);
        itv(i,4) = (ceil(ucf_annotation{aidx}.gt_end(2)/nodesize)*nodesize - len)/nodesize +1;
    end
end
load([ipath,'res_50_',num2str(class),'.mat'],'Y','R','E');
colors =['k'];
colors2 =['r','b','g','c','m','k'];
figure;
hold on;
for v= 1:50
    plot(Y.coords{2}(1,startidx(v):endidx(v)), Y.coords{2}(2,startidx(v):endidx(v)), [colors(1),'o-']);
    %              plot(Y.coords{twod}(1,startidx(2):endidx(2)), Y.coords{twod}(2,startidx(2):endidx(2)), 'bo-');
%     plot(Y.coords{twod}(1,startidx(v)), Y.coords{twod}(2,startidx(v)), 'cb*');
    %              plot(Y.coords{twod}(1,startidx(2)), Y.coords{twod}(2,startidx(2)), 'r*');
    plot(Y.coords{2}(1,itv(v,1):itv(v,2)), Y.coords{2}(2,itv(v,1):itv(v,2)), [colors2(rem(v,6)+1),'o-'],'markersize',10);
    plot(Y.coords{2}(1,itv(v,3):itv(v,4)), Y.coords{2}(2,itv(v,3):itv(v,4)), [colors2(rem(v,6)+1),'o-'],'markersize',10);
    %              plot(Y.coords{twod}(1,itv(2,1):itv(2,2)), Y.coords{twod}(2,itv(2,1):itv(2,2)), 'g*-');
end
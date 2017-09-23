function Visualize_by_Isomap_50_vids(class,len,nodesize,sumhists) %data : N*D
dist=10;
load(['./data/dists50/Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'.mat']);
ipath ='./data/isomap_res_50/';
if ~exist(ipath,'dir')
    mkdir(ipath);
end
D =zeros(size(dists{1}));
for i = 1:5
    D=D+dists{i};
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

itv = zeros(nVideos,2);
for i=1:nVideos
    aidx= (class-1)*nVideos+i;
    if i~=1
        itv(i,1)=ceil(ucf_annotation{aidx}.gt_start(1)/nodesize)+endidx(i-1);
        itv(i,2) = (ceil(ucf_annotation{aidx}.gt_end(1)/nodesize)*nodesize - len)/nodesize +1+endidx(i-1);
    else
        itv(i,1)=ceil(ucf_annotation{aidx}.gt_start(1)/nodesize);
        itv(i,2) = (ceil(ucf_annotation{aidx}.gt_end(1)/nodesize)*nodesize - len)/nodesize +1;
    end
end
[Y, R, E] = Isomap(D, 'k', 15, options,startidx, endidx,itv);

save([ipath,'res_50_',num2str(class),'.mat'],'Y','R','E');


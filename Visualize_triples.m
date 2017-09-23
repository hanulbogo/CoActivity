function Visualize_triples(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,sumhists,vididx) %data : N*D
Kpath ='./data/dists_triples/';
if ~exist(Kpath,'dir')
    mkdir(Kpath);
end
ipath ='./data/res_isomap/';
if ~exist(ipath,'dir')
    mkdir(ipath);
end
if ~exist([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_',num2str(vididx(3)),'triples.mat'],'file') 
    dists{1}=PW_paralleldists_two_videos(TDATA','CHI2',class,1);
    fprintf('1st is done');
    dists{2}=PW_paralleldists_two_videos(HOGDATA','CHI2',class,2);
    fprintf('2nd is done');
    dists{3}=PW_paralleldists_two_videos(HOFDATA','CHI2',class,3);
    fprintf('3rd is done');
    dists{4}=PW_paralleldists_two_videos(MBHxDATA','CHI2',class,4);
    fprintf('4th is done');
    dists{5}=PW_paralleldists_two_videos(MBHyDATA','CHI2',class,5);
    fprintf('5th is done');
    save([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_',num2str(vididx(3)),'triples.mat'],'dists');
else
        load([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_',num2str(vididx(3)),'triples.mat']);%'dists'
end
% Kern = PW_calc_Kern_from_dist_one_vid(dists);
D =zeros(size(dists{1}));

for i=1:5
    D = D+dists{i};
end

load('./data/ucf_one_annotation.mat');%'ucf_annotation'

nVideos=25;
nnodes = zeros(nVideos,1);

for v=vididx
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end

total_nodes =  sum(nnodes);
mask=zeros(total_nodes,total_nodes);
for v=vididx
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


for i=1:length(vididx)
    v=vididx(i);
    vid= find(idxlist==v);
    startidx(i) =vid(1);
    endidx(i)= vid(end);
end


% figure;
%         imshow(D,[]);
options.dims = 1:2;

itv = zeros(length(vididx),2);
for i=1:length(vididx)
    v = vididx(i);
    aidx= (class-1)*nVideos+v;
    if i~=1
        itv(i,1)=ceil(ucf_annotation{aidx}.gt_start(1)/nodesize)+endidx(i-1);
        itv(i,2) = (ceil(ucf_annotation{aidx}.gt_end(1)/nodesize)*nodesize - len)/nodesize +1+endidx(i-1);
    else
        itv(i,1)=ceil(ucf_annotation{aidx}.gt_start(1)/nodesize);
        itv(i,2) = (ceil(ucf_annotation{aidx}.gt_end(1)/nodesize)*nodesize - len)/nodesize +1;
    end
end
[Y, R, E] = Isomap(D, 'k', 15, options,startidx, endidx,itv);

save([ipath,'res_',num2str(length(vididx)),'_',num2str(class),'.mat'],'Y','R','E');
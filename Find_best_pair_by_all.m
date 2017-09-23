function [maxitv1 maxitv2]= Find_best_pair_by_all(Kern, len,nodesize,vididx,class)
% load('./test.mat');
% close all;
% len=75;
% nodesize=5;

load('./data/ucf_one_annotation.mat');%'ucf_annotation'
dpath ='./data/orgD/';
dpath2 ='./data/calD/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end
if ~exist(dpath2,'dir')
    mkdir(dpath2);
end
ppath =['./data/shortest_res/'];
if ~exist(ppath,'dir')
    mkdir(ppath);
end
nVideos=25;
nnodes = zeros(nVideos,1);

for v=vididx
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end
for i=1:2
    v=vididx(i);
    startidx(i) = sum(nnodes(1:v-1))+1;
    endidx(i) = sum(nnodes(1:v));
     aidx =(class-1)*nVideos+v;
    gt_start(i) =ceil(ucf_annotation{aidx}.gt_start(1)/nodesize);
    gt_end(i) =ceil((ucf_annotation{aidx}.gt_end(1)-len)/nodesize)+1;
end
Kern =Kern(startidx(1):endidx(1), startidx(2):endidx(2));% M=sum(Kern()/sum(length(T));

N=size(Kern,1)*size(Kern,2);
idx =1:N;
idx =reshape(idx,size(Kern));
% if ~exist([ppath,'res_',num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_nodesize_',num2str(nodesize),'.mat'],'file')
    D= (ones(N,N,'single')*inf);

    for i=1:size(Kern,1)
        for j=1:size(Kern,2)
            if j~=size(Kern,2) && i~=size(Kern,1)

                D(idx(i,j),idx(i+1,j))= Kern(i,j);
                D(idx(i,j),idx(i,j+1))= Kern(i,j);
                D(idx(i,j),idx(i+1,j+1))= Kern(i,j);
            elseif j==size(Kern,2) && i~=size(Kern,1)
                D(idx(i,j),idx(i+1,j)) = Kern(i,j);
            elseif i==size(Kern,1) && j~=size(Kern,2)
                D(idx(i,j),idx(i,j+1)) = Kern(i,j);
            end
        end
    end
 
    irow =repmat(1:size(Kern,1),1,size(Kern,2));
    icol = zeros(1,N);
    for k=1:N
        icol(k) = ceil(k/size(Kern,1));
    end
        
    rowsub= repmat(irow,N,1)-repmat(irow',1,N)+1;
    colsub = repmat(icol,N,1)-repmat(icol',1,N)+1;
    clen = rowsub+colsub;
    clen(clen<1) =1;
    ND = FastFloyd(D,size(Kern,1),size(Kern,2));
    ND=ND+repmat(Kern(:)',N,1);
    ND(rowsub<len/nodesize)= inf;
    ND(colsub<len/nodesize)= inf;
    ND= ND./clen;

    [foo sidx]  =min(ND(:));
    ridx =rem((sidx-1),N)+1;
    cidx = ceil(sidx/N);
    maxitv1(1) = rem((ridx-1),size(Kern,1))+1;
    maxitv2(1) = ceil(ridx/size(Kern,1));
    maxitv1(2) = rem((cidx-1),size(Kern,1))+1;
    maxitv2(2) = ceil(cidx/size(Kern,1));
    
    

    fprintf('GT DTW value : %f\n', D(idx(gt_start(1),gt_start(2)), idx(gt_end(1),gt_end(2)))+Kern(gt_end(1),gt_end(2)));
    fprintf('Min DTW value: %f\n', D(idx(maxitv1(1),maxitv2(1)), idx(maxitv1(2),maxitv2(2)))+Kern(maxitv1(2),maxitv2(2)));
    
    minval =foo;
    maxitv1(1) =(maxitv1(1)-1)*nodesize+1;
    maxitv1(2)=(maxitv1(2)-1)*nodesize+len;
    maxitv2(1) =(maxitv2(1)-1)*nodesize+1;
    maxitv2(2)=(maxitv2(2)-1)*nodesize+len;
    fprintf('Video 1 [%d, %d] Video2 [%d, %d]\n',maxitv1(1),maxitv1(2),maxitv2(1),maxitv2(2));
    save([ppath,'res_',num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_nodesize_',num2str(nodesize),'.mat'],'maxitv1','maxitv2','minval');
% else
%     
%     load([ppath,'res_',num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_nodesize_',num2str(nodesize),'.mat']);%,'maxitv1','maxitv2','minval');
%     fprintf('Video 1 [%d, %d] Video2 [%d, %d]\n',maxitv1(1),maxitv1(2),maxitv2(1),maxitv2(2));
% end
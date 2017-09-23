function [maxitv1 maxitv2]= Find_best_pair_by_DP(D,len,nodesize,vididx,class)
% load('./test.mat');
% close all;
% len=75;
% nodesize=5;

load('./data/ucf_one_annotation.mat');%'ucf_annotation'
ppath ='./data/shortest_res/';
if ~exist(ppath,'dir')
    mkdir(ppath);
end
nVideos=25;
nnodes = zeros(nVideos,1);

for v=vididx
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end

for v=vididx
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end
gt_start=zeros(2,1);
gt_end = zeros(2,1);

for i=1:2
    v=vididx(i);
    aidx =(class-1)*nVideos+v;
    gt_start(i) =ucf_annotation{aidx}.gt_start(1);
    gt_end(i) =ucf_annotation{aidx}.gt_end(1);
    startidx(i) = sum(nnodes(1:v-1))+1;
    endidx(i) = sum(nnodes(1:v)); 
end
D =D(startidx(1):endidx(1), startidx(2):endidx(2));% M=sum(D()/sum(length(T));
minscore= inf;
for spos = 1:size(D,1)-len/nodesize;
    SD= D(spos:end,:);
%     figure(1);
%     imshow(SD,[]);
%     hold on;
%     drawbox([ceil(gt_start(2)/nodesize), ceil((gt_end(2)-len)/nodesize)],[ceil(gt_start(1)/nodesize)-spos+1,ceil((gt_end(1)-len)/nodesize)-spos+1]);
%     title('Segmented Distance');
%     hold off;
%     drawnow();
    
    [p,q,NormD, score]=dp_query_all_ends(SD,len,nodesize);
    if minscore>score
        minscore= score;
        minp = p+spos-1; %row
        minq = q; %col
%         figure(2);
%         imshow(D,[]);
%         hold on;
%         drawbox([ceil(gt_start(2)/nodesize), ceil((gt_end(2)-len)/nodesize)],[ceil(gt_start(1)/nodesize),ceil((gt_end(1)-len)/nodesize)]);
% %         blockDTWPath =zeros(size(D));
%         plot(minq,minp,'y-');
% %         ginput(1);
%         hold off;
%         drawnow();

        
    end
    
end
fprintf('Overlapping Block Cost :%f\n', score);
fprintf('GT : [%d - %d] ', gt_start(1),gt_end(1));
fprintf('[%d - %d]\n', gt_start(2),gt_end(2));
fprintf('Overlapping Block Result : [%d - %d]',(minp(1)-1)*nodesize+1, (minp(end)-1)*nodesize+len);
fprintf(' [%d - %d]\n',(minq(1)-1)*nodesize+1, (minq(end)-1)*nodesize+len);

maxitv1(1) = (minp(1)-1)*nodesize+1;
maxitv1(2) = (minp(end)-1)*nodesize+len;
maxitv2(1) = (minq(1)-1)*nodesize+1;
maxitv2(2) = (minq(end)-1)*nodesize+len;

save([ppath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_nodesize_',num2str(nodesize),'.mat'],'maxitv1','maxitv2');
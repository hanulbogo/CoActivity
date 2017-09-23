function density=ParzenWindow_multi_vid(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,sumhists) %data : N*D


kpath = './data/dists_multi/';
if ~exist(kpath,'dir')
    mkdir(kpath);
end
if ~exist([kpath,num2str(class),'.mat'])
    [Kerns{1} dists{1}] =PW_paralleldists_multi_vid(TDATA','CHI2',class,1);
    [Kerns{2} dists{2}] =PW_paralleldists_multi_vid(HOGDATA','CHI2',class,2);
    [Kerns{3} dists{3}] =PW_paralleldists_multi_vid(HOFDATA','CHI2',class,3);
    [Kerns{4} dists{4}] =PW_paralleldists_multi_vid(MBHxDATA','CHI2',class,4);
    [Kerns{5} dists{5}] =PW_paralleldists_multi_vid(MBHyDATA','CHI2',class,5);
    
    save([kpath,num2str(class),'.mat'],'Kerns','dists');
else
    % Kern2 =PW_paralleldists(HOGDATA','CHI2');
    % Kern3 =PW_paralleldists(HOFDATA','CHI2');
    % Kern4 =PW_paralleldists(MBHxDATA','CHI2');
    % Kern5 =PW_paralleldists(MBHyDATA','CHI2');
    
    % for i = 1:5
    %     load(['./data/dist/distdist',num2str(class),'_',num2str(i),'.mat']);
    %     dists{i}=dist;
    % end
    load([kpath,num2str(class),'.mat'],'Kerns','dists');
end
Kern =PW_calc_Kern_from_dist_multi(dists);
% 
% Kern= ((((Kern1.*Kern2).*Kern3).*Kern4).*Kern5);




load('./data/ucf_multi_annotation.mat');%'ucf_annotation'

% load(['./data/Kernel/',num2str(class),'.mat']);%,'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');
h=figure; imshow(Kern,[]);

nVideos=10;
nnodes = zeros(nVideos,1);


for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end


print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'.pdf']);
% close(h);
total_nodes =  sum(nnodes);
mask=ones(total_nodes,total_nodes);
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    mask(startidx:endidx,startidx:endidx) =0;
end
idx =1:total_nodes;
kidx=idx(sumhists>=len);
mask =mask(kidx,:);
mask =mask(:,kidx);
badidx =find(sumhists<len);
newnnodes=nnodes;
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    newnnodes(v) = newnnodes(v)- sum(badidx>=startidx& badidx<endidx);
end
cumnodes =cumsum(newnnodes);

% figure;imshow(mask,[])
Kern = Kern.*mask;
Kern(cumnodes,:)=0;
Kern(:,cumnodes)=0;
[itv1 itv2]= Find_best_pair_multi(Kern, mask,len,nodesize,class,newnnodes);
density =sum(Kern); %1*N
% for i = 1: length(Kern)
%     startidx= i-floor(len/2);
%     endidx= i+floor(len/2);
%     if startidx <1
%         startidx=1;
%     end
%     if endidx>length(Kern)
%         endidx = length(Kern);
%     end
%     density(i) = density(i)-sum(Kern(startidx:endidx,i));
% end
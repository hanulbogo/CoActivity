function newKern =T_blocks_similarity(Kern, class,len, nodesize)
step = (len/nodesize);
newKern = Kern;

load('./data/UT_annotation.mat');%'UT_annotation'
nVideos=10;
nnodes = zeros(nVideos,1);

for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
end

newKern(step+1:length(newKern)-step,step+1:length(newKern)-step) = Kern(step+1:length(newKern)-step,step+1:length(newKern)-step)+Kern(1:length(newKern)-step*2,1:length(newKern)-step*2)+Kern(step*2+1:length(newKern),step*2+1:length(newKern));
newKern=newKern/3;
mask= zeros(size(Kern));

for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    
    mask(startidx:startidx+step-1,:) =1;
    mask(endidx-step+1:endidx,:) =1;
end
newKern(mask==1) = Kern(mask==1);
% figure;
% imshow(Kern,[]);
% figure;
% imshow(newKern,[]);
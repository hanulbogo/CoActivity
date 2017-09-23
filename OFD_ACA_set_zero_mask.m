function H=OFD_ACA_set_zero_mask(class,nVideos,nodesize,H,seg)

load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'

nnodes = zeros(nVideos,1);
for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize);
end
cumnodes = cumsum(nnodes);
vidx =1;
aidx = (class-1)*nVideos+vidx;
startidx =1;
for sidx = 1: length(H)
    if seg.s(sidx)>cumnodes(vidx)
        endidx = sidx;
        H(startidx:endidx, startidx:endidx)=0;
        startidx = sidx+1;
        vidx= vidx+1;
    end
end
H(startidx:length(H), startidx:length(H))=0;





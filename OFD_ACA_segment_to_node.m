function OFD_ACA_segment_to_node(class,nVideos,nodesize,x, seg,nCenter)
dpath ='./data/OFD_density_map/';

load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
len=80;
nnodes = zeros(nVideos,1);
for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize);
end
cumnodes = cumsum(nnodes);
vidx =1;
aidx = (class-1)*nVideos+vidx;
density_map=cell(nVideos,1);
density_map{vidx}=zeros(1,sum(ucf_annotation{aidx}.nFrames));

x=x/max(x);
for sidx = 1: length(x)
    if seg.s(sidx)>cumnodes(vidx)
        density_map{vidx}= density_map{vidx}(1:sum(ucf_annotation{aidx}.nFrames));
        vidx=vidx+1;
        aidx = (class-1)*nVideos+vidx;
        density_map{vidx}=zeros(1,sum(ucf_annotation{aidx}.nFrames));
    end
    if vidx>1
        density_map{vidx}((seg.s(sidx)-cumnodes(vidx-1)-1)*nodesize+1:(seg.s(sidx+1)-cumnodes(vidx-1)-1)*nodesize) = x(sidx);
    else
        density_map{vidx}((seg.s(sidx)-1)*nodesize+1:(seg.s(sidx+1)-1)*nodesize) = x(sidx);
    end
end

density_map{vidx}= density_map{vidx}(1:sum(ucf_annotation{aidx}.nFrames));
save([dpath,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenter),'_ofd_novariance.mat'],'density_map');





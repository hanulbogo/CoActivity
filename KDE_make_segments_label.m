function KDE_make_segments_label(nodesize, classlist, len)
load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
hpath='./data/KDE_concat_hist/';
spath ='./data/seg_hists/';
if ~exist(spath,'dir')
    mkdir(spath);
end
D=4000;
nVideos=50;
for class =classlist% kiss set has the best results
    nnodes = zeros(nVideos,1);
    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
    end
    total_nodes =  sum(nnodes);
    label = zeros(total_nodes,1);
    hidx =1;
    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        for n = 1: nnodes(v)
            n_start = n;
            n_end = n+(len/nodesize)-1;
            
            if ucf_annotation{aidx}.gt_start(1)<n_end*nodesize && ucf_annotation{aidx}.gt_end(1)>n_start*nodesize
                label(hidx) =1;
                hidx=hidx+1;
            else
                label(hidx) =0;
                hidx=hidx+1;
            end
            
        end
    end

    save([spath,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_label',num2str(len),'.mat'],'label');
end
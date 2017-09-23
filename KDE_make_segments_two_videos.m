function KDE_make_segments_two_videos(nodesize, classlist, len,vididx)
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
    for v=vididx
        aidx =(class-1)*nVideos+v;
        nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
    end
    total_nodes =  sum(nnodes);
    TSEGHISTS= zeros(total_nodes,D);
    HOGSEGHISTS= zeros(total_nodes,D);
    HOFSEGHISTS= zeros(total_nodes,D);
    MBHxSEGHISTS= zeros(total_nodes,D);
    MBHySEGHISTS= zeros(total_nodes,D);
    
    hidx =1;
    for v=vididx
        aidx =(class-1)*nVideos+v;
        load([hpath,ucf_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
        %'Thists','HOGhists','HOFhists','MBHxhists','MBHyhists'
        Tcumhists = cumsum(Thists);
        HOGcumhists = cumsum(HOGhists);
        HOFcumhists = cumsum(HOFhists);
        MBHxcumhists = cumsum(MBHxhists);
        MBHycumhists = cumsum(MBHyhists);
        for n = 1: nnodes(v)
            n_start = n;
            n_end = n+(len/nodesize)-1;
            if n_start~=1
                TSEGHISTS(hidx,:) = Tcumhists(n_end,:)- Tcumhists(n_start-1,:);
                HOGSEGHISTS(hidx,:) = HOGcumhists(n_end,:)- HOGcumhists(n_start-1,:);
                HOFSEGHISTS(hidx,:) = HOFcumhists(n_end,:)- HOFcumhists(n_start-1,:);
                MBHxSEGHISTS(hidx,:) = MBHxcumhists(n_end,:)- MBHxcumhists(n_start-1,:);
                MBHySEGHISTS(hidx,:) = MBHycumhists(n_end,:)- MBHycumhists(n_start-1,:);
                hidx = hidx+1;
            else
                TSEGHISTS(hidx,:) = Tcumhists(n_end,:);
                HOGSEGHISTS(hidx,:) = HOGcumhists(n_end,:);
                HOFSEGHISTS(hidx,:) = HOFcumhists(n_end,:);
                MBHxSEGHISTS(hidx,:) = MBHxcumhists(n_end,:);
                MBHySEGHISTS(hidx,:) = MBHycumhists(n_end,:);
                hidx =hidx+1;
            end
        end
    end

    save([spath,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'_two_videos.mat'],'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS');
    clear TSEGHISTS HOGSEGHISTS HOFSEGHISTS MBHxSEGHISTS MBHySEGHISTS;
end
function KDE_make_segments_separate(nodesize, classlist, len)
load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
hpath='./data/KDE_concat_hist/';
spath ='./data/seg_hists_pos/';
if ~exist(spath,'dir')
    mkdir(spath);
end
spath2 ='./data/seg_hists_neg/';
if ~exist(spath2,'dir')
    mkdir(spath2);
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
    pTSEGHISTS= zeros(total_nodes,D);
    pHOGSEGHISTS= zeros(total_nodes,D);
    pHOFSEGHISTS= zeros(total_nodes,D);
    pMBHxSEGHISTS= zeros(total_nodes,D);
    pMBHySEGHISTS= zeros(total_nodes,D);
    
    nTSEGHISTS= zeros(total_nodes,D);
    nHOGSEGHISTS= zeros(total_nodes,D);
    nHOFSEGHISTS= zeros(total_nodes,D);
    nMBHxSEGHISTS= zeros(total_nodes,D);
    nMBHySEGHISTS= zeros(total_nodes,D);
    
    hidx =1;
    nidx =1;
    gt_start= zeros(nVideos,2);
    gt_end= zeros(nVideos,2);
    non_gt_n=0;
    non_gt=zeros(2,1);
    non_gt_start=zeros(2,1);
    non_gt_end = zeros(2,1);
    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        load([hpath,ucf_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
        %'Thists','HOGhists','HOFhists','MBHxhists','MBHyhists'
        Tcumhists = cumsum(Thists);
        HOGcumhists = cumsum(HOGhists);
        HOFcumhists = cumsum(HOFhists);
        MBHxcumhists = cumsum(MBHxhists);
        MBHycumhists = cumsum(MBHyhists);
        
        gt_start(v,1) = ucf_annotation{aidx}.gt_start(1);
        gt_end(v,1)= ucf_annotation{aidx}.gt_end(1);
        gt_start(v,2) = ucf_annotation{aidx}.gt_start(2);
        gt_end(v,2)= ucf_annotation{aidx}.gt_end(2);
   
        for k=1:4
            if isempty(find(ucf_annotation{aidx}.gt==k,1))
                non_gt_n =non_gt_n+1;
                non_gt(non_gt_n) = k;
                non_gt_start(non_gt_n)= sum(ucf_annotation{aidx}.nFrames(1:k-1))+1;
                non_gt_end(non_gt_n)= sum(ucf_annotation{aidx}.nFrames(1:k));
            end
        end
        
        for n = 1: nnodes(v)
            n_start = n;
            n_end = n+(len/nodesize)-1;
            if (n_start*nodesize>=gt_start(v,1)&& n_end*nodesize<=gt_end(v,1)) || (n_start*nodesize>=gt_start(v,2)&& n_end*nodesize<=gt_end(v,2))
                if n_start~=1
                    pTSEGHISTS(hidx,:) = Tcumhists(n_end,:)- Tcumhists(n_start-1,:);
                    pHOGSEGHISTS(hidx,:) = HOGcumhists(n_end,:)- HOGcumhists(n_start-1,:);
                    pHOFSEGHISTS(hidx,:) = HOFcumhists(n_end,:)- HOFcumhists(n_start-1,:);
                    pMBHxSEGHISTS(hidx,:) = MBHxcumhists(n_end,:)- MBHxcumhists(n_start-1,:);
                    pMBHySEGHISTS(hidx,:) = MBHycumhists(n_end,:)- MBHycumhists(n_start-1,:);
                    hidx = hidx+1;
                else
                    pTSEGHISTS(hidx,:) = Tcumhists(n_end,:);
                    pHOGSEGHISTS(hidx,:) = HOGcumhists(n_end,:);
                    pHOFSEGHISTS(hidx,:) = HOFcumhists(n_end,:);
                    pMBHxSEGHISTS(hidx,:) = MBHxcumhists(n_end,:);
                    pMBHySEGHISTS(hidx,:) = MBHycumhists(n_end,:);
                    hidx =hidx+1;
                end
            elseif (n_start*nodesize>=non_gt_start(1)&& n_end*nodesize<=non_gt_end(1)) || (n_start*nodesize>=non_gt_start(2)&& n_end*nodesize<=non_gt_end(2))
                if n_start~=1
                    nTSEGHISTS(nidx,:) = Tcumhists(n_end,:)- Tcumhists(n_start-1,:);
                    nHOGSEGHISTS(nidx,:) = HOGcumhists(n_end,:)- HOGcumhists(n_start-1,:);
                    nHOFSEGHISTS(nidx,:) = HOFcumhists(n_end,:)- HOFcumhists(n_start-1,:);
                    nMBHxSEGHISTS(nidx,:) = MBHxcumhists(n_end,:)- MBHxcumhists(n_start-1,:);
                    nMBHySEGHISTS(nidx,:) = MBHycumhists(n_end,:)- MBHycumhists(n_start-1,:);
                    nidx = nidx+1;
                else
                    nTSEGHISTS(nidx,:) = Tcumhists(n_end,:);
                    nHOGSEGHISTS(nidx,:) = HOGcumhists(n_end,:);
                    nHOFSEGHISTS(nidx,:) = HOFcumhists(n_end,:);
                    nMBHxSEGHISTS(nidx,:) = MBHxcumhists(n_end,:);
                    nMBHySEGHISTS(nidx,:) = MBHycumhists(n_end,:);
                    nidx =nidx+1;
                end
            end
        end
    end
    nidx = nidx-1;
    hidx=hidx-1;
    pTSEGHISTS= pTSEGHISTS(1:hidx,:);
    pHOGSEGHISTS=pHOGSEGHISTS(1:hidx,:) ;
    pHOFSEGHISTS=pHOFSEGHISTS(1:hidx,:) ;
    pMBHxSEGHISTS=pMBHxSEGHISTS(1:hidx,:);
    pMBHySEGHISTS=pMBHySEGHISTS(1:hidx,:);
    
    nTSEGHISTS= nTSEGHISTS(1:nidx,:);
    nHOGSEGHISTS=nHOGSEGHISTS(1:nidx,:) ;
    nHOFSEGHISTS=nHOFSEGHISTS(1:nidx,:) ;
    nMBHxSEGHISTS=nMBHxSEGHISTS(1:nidx,:);
    nMBHySEGHISTS=nMBHySEGHISTS(1:nidx,:);
    
    save([spath,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_POS_',num2str(len),'.mat'],'pTSEGHISTS','pHOGSEGHISTS','pHOFSEGHISTS','pMBHxSEGHISTS','pMBHySEGHISTS');
    save([spath2,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_NEG_',num2str(len),'.mat'],'nTSEGHISTS','nHOGSEGHISTS','nHOFSEGHISTS','nMBHxSEGHISTS','nMBHySEGHISTS');
    clear TSEGHISTS HOGSEGHISTS HOFSEGHISTS MBHxSEGHISTS MBHySEGHISTS;
end
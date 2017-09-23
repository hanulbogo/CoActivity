function UT_make_segments_ofd(nodesize, classlist, len,NC)
load('./data/UT_annotation.mat');%'UT_annotation'
% cpath ='./data/UT_concat/';
hpath='./data/UT_hist/';
spath ='./data/UT_seg_hists/';
if ~exist(spath,'dir')
    mkdir(spath);
end
nCenters =[50,125,250,500,1000,2000,4000];

nVideos=10;
for class =classlist% kiss set has the best results
    nnodes = zeros(nVideos,1);
    for v=1:nVideos
        aidx =sum(nVideolist(1:(class-1)))+v;
        nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
    end
    total_nodes =  sum(nnodes);
    TSEGHISTS =cell(NC,1);
    for nc =1:NC
        D = nCenters(nc);
        TSEGHISTS{nc} =zeros(total_nodes,D);
    end
    
    HOGFSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    HOGSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    OFDLSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    OFDRSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    OFDTSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    OFDBSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    OFDASEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    OFDCSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    
    HOFSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    MBHxSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    MBHySEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    
    hidx =1;
    
    for v=1:nVideos
        aidx =sum(nVideolist(1:(class-1)))+v;
        load([hpath,UT_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS_ofd.mat']);
        oldhidx = hidx;
        %'Thists','HOGhists','HOFhists','MBHxhists','MBHyhists'
        for nc = 1: NC
            hidx = oldhidx;
            Tcumhists = cumsum(Thists{nc});
            HOGFcumhists = cumsum(HOGFhists{nc});
            HOGcumhists = cumsum(HOGhists{nc});
            OFDLcumhists = cumsum(OFDLhists{nc});
            OFDRcumhists = cumsum(OFDRhists{nc});
            OFDTcumhists = cumsum(OFDThists{nc});
            OFDBcumhists = cumsum(OFDBhists{nc});
            OFDAcumhists = cumsum(OFDAhists{nc});
            OFDCcumhists = cumsum(OFDChists{nc});
            HOFcumhists = cumsum(HOFhists{nc});
            MBHxcumhists = cumsum(MBHxhists{nc});
            MBHycumhists = cumsum(MBHyhists{nc});
            for n = 1: nnodes(v)
                n_start = n;
                n_end = n+(len/nodesize)-1;
                if n_start~=1
                    TSEGHISTS{nc}(hidx,:) = Tcumhists(n_end,:)- Tcumhists(n_start-1,:);
                    HOGFSEGHISTS{nc}(hidx,:) = HOGFcumhists(n_end,:)- HOGFcumhists(n_start-1,:);
                    HOGSEGHISTS{nc}(hidx,:) = HOGcumhists(n_end,:)- HOGcumhists(n_start-1,:);
                    OFDLSEGHISTS{nc}(hidx,:) = OFDLcumhists(n_end,:)- OFDLcumhists(n_start-1,:);
                    OFDRSEGHISTS{nc}(hidx,:) = OFDRcumhists(n_end,:)- OFDRcumhists(n_start-1,:);
                    OFDTSEGHISTS{nc}(hidx,:) = OFDTcumhists(n_end,:)- OFDTcumhists(n_start-1,:);
                    OFDBSEGHISTS{nc}(hidx,:) = OFDBcumhists(n_end,:)- OFDBcumhists(n_start-1,:);
                    OFDASEGHISTS{nc}(hidx,:) = OFDAcumhists(n_end,:)- OFDAcumhists(n_start-1,:);
                    OFDCSEGHISTS{nc}(hidx,:) = OFDCcumhists(n_end,:)- OFDCcumhists(n_start-1,:);
                    HOFSEGHISTS{nc}(hidx,:) = HOFcumhists(n_end,:)- HOFcumhists(n_start-1,:);
                    MBHxSEGHISTS{nc}(hidx,:) = MBHxcumhists(n_end,:)- MBHxcumhists(n_start-1,:);
                    MBHySEGHISTS{nc}(hidx,:) = MBHycumhists(n_end,:)- MBHycumhists(n_start-1,:);
                    hidx = hidx+1;
                else
                    TSEGHISTS{nc}(hidx,:) = Tcumhists(n_end,:);
                    HOGFSEGHISTS{nc}(hidx,:) = HOGFcumhists(n_end,:);
                    HOGSEGHISTS{nc}(hidx,:) = HOGcumhists(n_end,:);
                    OFDLSEGHISTS{nc}(hidx,:) = OFDLcumhists(n_end,:);
                    OFDRSEGHISTS{nc}(hidx,:) = OFDRcumhists(n_end,:);
                    OFDTSEGHISTS{nc}(hidx,:) = OFDTcumhists(n_end,:);
                    OFDBSEGHISTS{nc}(hidx,:) = OFDBcumhists(n_end,:);
                    OFDASEGHISTS{nc}(hidx,:) = OFDAcumhists(n_end,:);
                    OFDCSEGHISTS{nc}(hidx,:) = OFDCcumhists(n_end,:);
                    HOFSEGHISTS{nc}(hidx,:) = HOFcumhists(n_end,:);
                    MBHxSEGHISTS{nc}(hidx,:) = MBHxcumhists(n_end,:);
                    MBHySEGHISTS{nc}(hidx,:) = MBHycumhists(n_end,:);
                    hidx =hidx+1;
                end
            end
        end
    end

    save([spath,UT_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_UT_',num2str(len),'_ofd.mat'],'TSEGHISTS','HOGFSEGHISTS','HOGSEGHISTS','OFDLSEGHISTS','OFDRSEGHISTS','OFDTSEGHISTS','OFDBSEGHISTS','OFDASEGHISTS','OFDCSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS');
    clear TSEGHISTS  HOGFSEGHISTS HOGSEGHISTS OFDLSEGHISTS OFDRSEGHISTS OFDTSEGHISTS OFDBSEGHISTS OFDASEGHISTS OFDCSEGHISTS HOFSEGHISTS MBHxSEGHISTS MBHySEGHISTS;
end

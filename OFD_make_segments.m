function OFD_make_segments(nodesize, classlist, len)
load('./data/OFD_ucf50_annotation.mat');%'ucf_annotation'
% cpath ='./data/OFD_concat/';
hpath='./data/OFD_concat_hist/';
spath ='./data/OFD_seg_hists/';
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
    TSEGHISTS= zeros(total_nodes,D);
    HOGFSEGHISTS= zeros(total_nodes,D);
    HOGSEGHISTS= zeros(total_nodes,D);
    OFDLSEGHISTS= zeros(total_nodes,D);
    OFDRSEGHISTS= zeros(total_nodes,D);
    OFDTSEGHISTS= zeros(total_nodes,D);
    OFDBSEGHISTS= zeros(total_nodes,D);
    OFDASEGHISTS= zeros(total_nodes,D);
    OFDCSEGHISTS= zeros(total_nodes,D);
    
    HOFSEGHISTS= zeros(total_nodes,D);
    MBHxSEGHISTS= zeros(total_nodes,D);
    MBHySEGHISTS= zeros(total_nodes,D);
    
    hidx =1;
    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        load([hpath,ucf_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
        %'Thists','HOGhists','HOFhists','MBHxhists','MBHyhists'
        Tcumhists = cumsum(Thists);
        HOGFcumhists = cumsum(HOGFhists);
        HOGcumhists = cumsum(HOGhists);
        OFDLcumhists = cumsum(OFDLhists);
        OFDRcumhists = cumsum(OFDRhists);
        OFDTcumhists = cumsum(OFDThists);
        OFDBcumhists = cumsum(OFDBhists);
        OFDAcumhists = cumsum(OFDAhists);
        OFDCcumhists = cumsum(OFDChists);
        
        HOFcumhists = cumsum(HOFhists);
        MBHxcumhists = cumsum(MBHxhists);
        MBHycumhists = cumsum(MBHyhists);
        for n = 1: nnodes(v)
            n_start = n;
            n_end = n+(len/nodesize)-1;
            if n_start~=1
                TSEGHISTS(hidx,:) = Tcumhists(n_end,:)- Tcumhists(n_start-1,:);
                HOGFSEGHISTS(hidx,:) = HOGFcumhists(n_end,:)- HOGFcumhists(n_start-1,:);
                HOGSEGHISTS(hidx,:) = HOGcumhists(n_end,:)- HOGcumhists(n_start-1,:);
                OFDLSEGHISTS(hidx,:) = OFDLcumhists(n_end,:)- OFDLcumhists(n_start-1,:);
                OFDRSEGHISTS(hidx,:) = OFDRcumhists(n_end,:)- OFDRcumhists(n_start-1,:);
                OFDTSEGHISTS(hidx,:) = OFDTcumhists(n_end,:)- OFDTcumhists(n_start-1,:);
                OFDBSEGHISTS(hidx,:) = OFDBcumhists(n_end,:)- OFDBcumhists(n_start-1,:);
                OFDASEGHISTS(hidx,:) = OFDAcumhists(n_end,:)- OFDAcumhists(n_start-1,:);
                OFDCSEGHISTS(hidx,:) = OFDCcumhists(n_end,:)- OFDCcumhists(n_start-1,:);
                
                HOFSEGHISTS(hidx,:) = HOFcumhists(n_end,:)- HOFcumhists(n_start-1,:);
                MBHxSEGHISTS(hidx,:) = MBHxcumhists(n_end,:)- MBHxcumhists(n_start-1,:);
                MBHySEGHISTS(hidx,:) = MBHycumhists(n_end,:)- MBHycumhists(n_start-1,:);
                hidx = hidx+1;
            else
                TSEGHISTS(hidx,:) = Tcumhists(n_end,:);
                HOGFSEGHISTS(hidx,:) = HOGFcumhists(n_end,:);
                HOGSEGHISTS(hidx,:) = HOGcumhists(n_end,:);
                OFDLSEGHISTS(hidx,:) = OFDLcumhists(n_end,:);
                OFDRSEGHISTS(hidx,:) = OFDRcumhists(n_end,:);
                OFDTSEGHISTS(hidx,:) = OFDTcumhists(n_end,:);
                OFDBSEGHISTS(hidx,:) = OFDBcumhists(n_end,:);
                OFDASEGHISTS(hidx,:) = OFDAcumhists(n_end,:);
                OFDCSEGHISTS(hidx,:) = OFDCcumhists(n_end,:);
                
                
                HOFSEGHISTS(hidx,:) = HOFcumhists(n_end,:);
                MBHxSEGHISTS(hidx,:) = MBHxcumhists(n_end,:);
                MBHySEGHISTS(hidx,:) = MBHycumhists(n_end,:);
                hidx =hidx+1;
            end
        end
    end

    save([spath,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_OFD_',num2str(len),'.mat'],'TSEGHISTS','HOGFSEGHISTS','HOGSEGHISTS','OFDLSEGHISTS','OFDRSEGHISTS','OFDTSEGHISTS','OFDBSEGHISTS','OFDASEGHISTS','OFDCSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS');
    clear TSEGHISTS  HOGFSEGHISTS HOGSEGHISTS OFDLSEGHISTS OFDRSEGHISTS OFDTSEGHISTS OFDBSEGHISTS OFDASEGHISTS OFDCSEGHISTS HOFSEGHISTS MBHxSEGHISTS MBHySEGHISTS;
end

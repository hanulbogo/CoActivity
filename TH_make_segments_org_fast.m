function TH_make_segments_org_fast(nodesize, classlist, len,NC)
load('./data/TH_nVideos.mat');%nVideolist
load('./data/TH_annotation.mat');%'TH_annotation'
% cpath ='./data/TH_concat/';
hpath='./data/TH_hist/';
spath ='./data/TH_seg_hists/';
if ~exist(spath,'dir')
    mkdir(spath);
end
nCenters =[50,125,250,500,1000,2000,4000];

for class =classlist% kiss set has the best results
    nVideos=nVideolist(class);
    nnodes = zeros(nVideos,1);
    for v=1:nVideos
        aidx =sum(nVideolist(1:(class-1)))+v;
        nnodes(v) =(ceil(TH_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
    end
    total_nodes =  sum(nnodes);
    TSEGHISTS =cell(NC,1);
    for nc =NC
        D = nCenters(nc);
        TSEGHISTS{nc} =zeros(total_nodes,D);
    end

      
        HOGSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
        HOFSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
        MBHSEGHISTS= TSEGHISTS;%zeros(total_nodes,D);
    
    hidx =1;
    
    for v=1:nVideos
        aidx =sum(nVideolist(1:(class-1)))+v;
        load([hpath,TH_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS_org.mat']);
        oldhidx = hidx;
        %'Thists','HOGhists','HOFhists','MBHhists','MBHyhists'
        for nc = NC
            hidx = oldhidx;
            Tcumhists = cumsum(Thists{nc});
            HOGcumhists = cumsum(HOGhists{nc});
            HOFcumhists = cumsum(HOFhists{nc});
            MBHcumhists = cumsum(MBHhists{nc});

            for n = 1: nnodes(v)
                n_start = n;
                n_end = n+(len/nodesize)-1;
                if n_start~=1
                    TSEGHISTS{nc}(hidx,:) = Tcumhists(n_end,:)- Tcumhists(n_start-1,:);
                    HOGSEGHISTS{nc}(hidx,:) = HOGcumhists(n_end,:)- HOGcumhists(n_start-1,:);
                    HOFSEGHISTS{nc}(hidx,:) = HOFcumhists(n_end,:)- HOFcumhists(n_start-1,:);
                    MBHSEGHISTS{nc}(hidx,:) = MBHcumhists(n_end,:)- MBHcumhists(n_start-1,:);
                    hidx = hidx+1;
                else
                    TSEGHISTS{nc}(hidx,:) = Tcumhists(n_end,:);
                    HOGSEGHISTS{nc}(hidx,:) = HOGcumhists(n_end,:);
                    HOFSEGHISTS{nc}(hidx,:) = HOFcumhists(n_end,:);
                    MBHSEGHISTS{nc}(hidx,:) = MBHcumhists(n_end,:);
                    hidx =hidx+1;
                end
            end
        end
    end

    save([spath,TH_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_TH_',num2str(len),'_org.mat'],'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHSEGHISTS');
    clear TSEGHISTS  HOGSEGHISTS HOFSEGHISTS MBHSEGHISTS;
end

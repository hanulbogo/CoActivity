function UT_make_nodes_org_fast(nodesize)
load('./data/UT_nVideos.mat');%nVideolist
load('./data/UT_annotation.mat');%'UT_annotation'
cpath ='./data/UT_feat/';
hpath='./data/UT_hist/';
if ~exist(hpath,'dir')
    mkdir(hpath);
end

% nclass=12;
nCenters =[50,125,250,500,1000,2000,4000];

NC=7;
for i= 1:length(UT_annotation)
    if ~exist([cpath,UT_annotation{i}.name,'_org.mat'],'file') || exist([hpath,UT_annotation{i}.name,'_nodesize_',num2str(nodesize),'_HISTS_org.mat'],'file')
        continue;
    end
     fprintf('make node org processing %s %d / %d \n',UT_annotation{i}.name,i,length(UT_annotation));
    
     load([cpath,UT_annotation{i}.name,'_org.mat']);
    %'t','Tbins','HOGbins','HOFbins','MBHxbins','MBHybins','totalframe'
    Tbins=org_Tbins;
%     HOGFbins=org_HOGFbins;
    HOGbins=org_HOGbins;
%     OFDLbins=org_OFDLbins;
%     OFDRbins=org_OFDRbins;
%     OFDTbins=org_OFDTbins;
%     OFDBbins=org_OFDBbins;
%     OFDAbins=org_OFDAbins;
%     OFDCbins=org_OFDCbins;
    HOFbins=org_HOFbins;
    MBHxbins=org_MBHxbins;
    MBHybins= org_MBHybins;
    t = org_t;
    
    Nnode = ceil(sum(UT_annotation{i}.nFrames)/nodesize);
    node_start =0;
    node_end=0;
    Thists=cell(NC,1);
    for nc=1:NC
         D = nCenters(nc);
        Thists{nc}=zeros(Nnode,D);
    end
    
    HOGhists=Thists;%zeros(Nnode,D);
 
    HOFhists=Thists;%zeros(Nnode,D);
    MBHxhists=Thists;%zeros(Nnode,D);
    MBHyhists=Thists;%zeros(Nnode,D);
    
    for k =1:Nnode
        node_start = (k-1)*nodesize+1;
        node_end = k*nodesize;
        for nc =NC %1:NC
            D = nCenters(nc);
            Tnode_bins{nc} = Tbins{nc}(t>=node_start & t<=node_end);
            HOGnode_bins{nc} = HOGbins{nc}(t>=node_start & t<=node_end);
            
            HOFnode_bins{nc} = HOFbins{nc}(t>=node_start & t<=node_end);
            MBHxnode_bins{nc} = MBHxbins{nc}(t>=node_start & t<=node_end);
            MBHynode_bins{nc} = MBHybins{nc}(t>=node_start & t<=node_end);
            if ~isempty(Tnode_bins{nc})
                Thists{nc}(k,:) =hist(Tnode_bins{nc},1:D);
            end
            if ~isempty(HOGnode_bins{nc})
                HOGhists{nc}(k,:) =hist(HOGnode_bins{nc},1:D);
            end
            
            if ~isempty(HOFnode_bins{nc})
                HOFhists{nc}(k,:) =hist(HOFnode_bins{nc},1:D);
            end
            if ~isempty(MBHxnode_bins{nc})
                MBHxhists{nc}(k,:) =hist(MBHxnode_bins{nc},1:D);
            end
            if ~isempty(MBHynode_bins{nc})
                MBHyhists{nc}(k,:) =hist(MBHynode_bins{nc},1:D);
            end
        end
    end
    save([hpath,UT_annotation{i}.name,'_nodesize_',num2str(nodesize),'_HISTS_org.mat'], 'Thists','HOGhists','HOFhists','MBHxhists','MBHyhists');
end



% save('./data/nodesize.mat','nodesize');
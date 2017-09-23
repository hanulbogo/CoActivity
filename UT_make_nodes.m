function UT_make_nodes(nodesize)

load('./data/UT_annotation.mat');%'UT_annotation'
cpath ='./data/UT_feat/';
hpath='./data/UT_hist/';
if ~exist(hpath,'dir')
    mkdir(hpath);
end
nVideo = 10;
nclass=12;
nCenters =[50,125,250,500,1000,2000,4000];

NC=7;
for i= 1:nVideo*nclass%length(UT_annotation)
    
    fprintf('make node ofd processing %s %d / %d \n',UT_annotation{i}.name,i,nclass*nVideo);%length(UT_annotation));
    load([cpath,UT_annotation{i}.name,'_ofd.mat']);
    %'t','Tbins','HOGbins','HOFbins','MBHxbins','MBHybins','totalframe'
    
    
    
    Nnode = ceil(UT_annotation{i}.nFrames/nodesize);
    node_start =0;
    node_end=0;
    Thists=cell(NC,1);
    for nc=1:NC
        D = nCenters(nc);
        Thists{nc}=zeros(Nnode,D);
    end
    
    HOGFhists=Thists;%zeros(Nnode,D);
    HOGhists=Thists;%zeros(Nnode,D);
    OFDLhists=Thists;%zeros(Nnode,D);
    OFDRhists=Thists;%zeros(Nnode,D);
    OFDThists=Thists;%zeros(Nnode,D);
    OFDBhists=Thists;%zeros(Nnode,D);
    OFDAhists=Thists;%zeros(Nnode,D);
    OFDChists=Thists;%zeros(Nnode,D);
    
    HOFhists=Thists;%zeros(Nnode,D);
    MBHxhists=Thists;%zeros(Nnode,D);
    MBHyhists=Thists;%zeros(Nnode,D);
    
    for k =1:Nnode
        node_start = (k-1)*nodesize+1;
        node_end = k*nodesize;
        for nc =1:NC
            D = nCenters(nc);
            Tnode_bins{nc} = Tbins{nc}(t>=node_start & t<=node_end);
            HOGFnode_bins{nc} = HOGFbins{nc}(t>=node_start & t<=node_end);
            HOGnode_bins{nc} = HOGbins{nc}(t>=node_start & t<=node_end);
            
            OFDLnode_bins{nc} = OFDLbins{nc}(t>=node_start & t<=node_end);
            OFDRnode_bins{nc} = OFDRbins{nc}(t>=node_start & t<=node_end);
            OFDTnode_bins{nc} = OFDTbins{nc}(t>=node_start & t<=node_end);
            OFDBnode_bins{nc} = OFDBbins{nc}(t>=node_start & t<=node_end);
            OFDAnode_bins{nc} = OFDAbins{nc}(t>=node_start & t<=node_end);
            OFDCnode_bins{nc} = OFDCbins{nc}(t>=node_start & t<=node_end);
            
            HOFnode_bins{nc} = HOFbins{nc}(t>=node_start & t<=node_end);
            MBHxnode_bins{nc} = MBHxbins{nc}(t>=node_start & t<=node_end);
            MBHynode_bins{nc} = MBHybins{nc}(t>=node_start & t<=node_end);
            if ~isempty(Tnode_bins{nc})
                Thists{nc}(k,:) =hist(Tnode_bins{nc},1:D);
            end
            if ~isempty(HOGFnode_bins{nc})
                HOGFhists{nc}(k,:) =hist(HOGFnode_bins{nc},1:D);
            end
            if ~isempty(HOGnode_bins{nc})
                HOGhists{nc}(k,:) =hist(HOGnode_bins{nc},1:D);
            end
            
            if ~isempty(OFDLnode_bins{nc})
                OFDLhists{nc}(k,:) =hist(OFDLnode_bins{nc},1:D);
            end
            if ~isempty(OFDRnode_bins{nc})
                OFDRhists{nc}(k,:) =hist(OFDRnode_bins{nc},1:D);
            end
            if ~isempty(OFDTnode_bins{nc})
                OFDThists{nc}(k,:) =hist(OFDTnode_bins{nc},1:D);
            end
            if ~isempty(OFDBnode_bins{nc})
                OFDBhists{nc}(k,:) =hist(OFDBnode_bins{nc},1:D);
            end
            if ~isempty(OFDAnode_bins{nc})
                OFDAhists{nc}(k,:) =hist(OFDAnode_bins{nc},1:D);
            end
            if ~isempty(OFDCnode_bins{nc})
                OFDChists{nc}(k,:) =hist(OFDCnode_bins{nc},1:D);
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
    save([hpath,UT_annotation{i}.name,'_nodesize_',num2str(nodesize),'_HISTS_ofd.mat'], 'Thists','HOGFhists','HOGhists','OFDLhists','OFDRhists','OFDThists','OFDBhists','OFDAhists','OFDChists','HOFhists','MBHxhists','MBHyhists');
end



% save('./data/nodesize.mat','nodesize');

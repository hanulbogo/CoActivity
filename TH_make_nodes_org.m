function TH_make_nodes_org(nodesize)
load('./data/TH_nVideos.mat');%nVideolist
load('./data/TH_annotation.mat');%'TH_annotation'
cpath ='./data/TH_feat/';
hpath='./data/TH_hist/';
if ~exist(hpath,'dir')
    mkdir(hpath);
end

% nclass=12;
nCenters =[50,125,250,500,1000,2000,4000];

NC=7;
for i= 1:length(TH_annotation)
%     if ~exist([cpath,TH_annotation{i}.name,'_org.mat'],'file') || exist([hpath,TH_annotation{i}.name,'_nodesize_',num2str(nodesize),'_HISTS_org.mat'],'file')
%         continue;
%     end
     fprintf('make node org processing %s %d / %d \n',TH_annotation{i}.name,i,length(TH_annotation));
    
     load([cpath,TH_annotation{i}.name,'_org.mat']);
    %'t','Tbins','HOGbins','HOFbins','MBHbins','totalframe'
    Tbins=org_Tbins;
    HOGbins=org_HOGbins;
    HOFbins=org_HOFbins;
    MBHbins=org_MBHbins;
    t = org_t;
    
    Nnode = ceil(sum(TH_annotation{i}.nFrames)/nodesize);
    node_start =0;
    node_end=0;
    Thists=cell(NC,1);
    for nc=1:NC
         D = nCenters(nc);
        Thists{nc}=zeros(Nnode,D);
    end
    
    HOGhists=Thists;%zeros(Nnode,D);
    HOFhists=Thists;%zeros(Nnode,D);
    MBHhists=Thists;%zeros(Nnode,D);
        
    for k =1:Nnode
        node_start = (k-1)*nodesize+1;
        node_end = k*nodesize;
        for nc =NC %1:NC
            D = nCenters(nc);
            Tnode_bins{nc} = Tbins{nc}(t>=node_start & t<=node_end);
            HOGnode_bins{nc} = HOGbins{nc}(t>=node_start & t<=node_end);      
            HOFnode_bins{nc} = HOFbins{nc}(t>=node_start & t<=node_end);
            MBHnode_bins{nc} = MBHbins{nc}(t>=node_start & t<=node_end);
            
            if ~isempty(Tnode_bins{nc})
                Thists{nc}(k,:) =hist(Tnode_bins{nc},1:D);
            end
            if ~isempty(HOGnode_bins{nc})
                HOGhists{nc}(k,:) =hist(HOGnode_bins{nc},1:D);
            end
            
            if ~isempty(HOFnode_bins{nc})
                HOFhists{nc}(k,:) =hist(HOFnode_bins{nc},1:D);
            end
            if ~isempty(MBHnode_bins{nc})
                MBHhists{nc}(k,:) =hist(MBHnode_bins{nc},1:D);
            end
            
        end
    end
    save([hpath,TH_annotation{i}.name,'_nodesize_',num2str(nodesize),'_HISTS_org.mat'], 'Thists','HOGhists','HOFhists','MBHhists');
end



% save('./data/nodesize.mat','nodesize');
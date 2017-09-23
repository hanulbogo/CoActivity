function make_nodes_one_vid(nodesize,vlist)
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
cpath ='./data/KDE_concat_one/';
hpath='./data/KDE_concat_hist_one/';
if ~exist(hpath,'dir')
    mkdir(hpath);
end
nVideo = 25;
nclass=14;
D=4000;
for i= vlist%length(ucf_annotation)
    Tcon_bins=[];
    HOGcon_bins=[];
    HOFcon_bins=[];
    MBHxcon_bins=[];
    MBHycon_bins=[];
    con_t =[];
    fprintf('processing %s %d / %d \n',ucf_annotation{i}.name,i,nclass*nVideo);
    load([cpath,ucf_annotation{i}.name,'.mat']);
    %'con_t','Tcon_bins','HOGcon_bins','HOFcon_bins','MBHxcon_bins','MBHycon_bins','totalframe'
    
    Nnode = ceil(sum(ucf_annotation{i}.nFrames)/nodesize);
    node_start =0;
    node_end=0;
    Thists=zeros(Nnode,D);
    HOGhists=zeros(Nnode,D);
    HOFhists=zeros(Nnode,D);
    MBHxhists=zeros(Nnode,D);
    MBHyhists=zeros(Nnode,D);
    
    for k =1:Nnode
        node_start = (k-1)*nodesize+1;
        node_end = k*nodesize;
        Tnode_bins = Tcon_bins(con_t>=node_start & con_t<=node_end);
        HOGnode_bins = HOGcon_bins(con_t>=node_start & con_t<=node_end);
        HOFnode_bins = HOFcon_bins(con_t>=node_start & con_t<=node_end);
        MBHxnode_bins = MBHxcon_bins(con_t>=node_start & con_t<=node_end);
        MBHynode_bins = MBHycon_bins(con_t>=node_start & con_t<=node_end);
        if ~isempty(Tnode_bins)
            Thists(k,:) =hist(Tnode_bins,1:D);
        end
        if ~isempty(HOGnode_bins)
            HOGhists(k,:) =hist(HOGnode_bins,1:D);
        end
        if ~isempty(HOFnode_bins)
            HOFhists(k,:) =hist(HOFnode_bins,1:D);
        end
        if ~isempty(MBHxnode_bins)
            MBHxhists(k,:) =hist(MBHxnode_bins,1:D);
        end
        if ~isempty(MBHynode_bins)
            MBHyhists(k,:) =hist(MBHynode_bins,1:D);
        end
    end
    save([hpath,ucf_annotation{i}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat'], 'Thists','HOGhists','HOFhists','MBHxhists','MBHyhists');
    
end

% save('./data/nodesize.mat','nodesize');

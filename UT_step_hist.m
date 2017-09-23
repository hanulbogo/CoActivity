function UT_step_hist(stepsize)
global dpath;
load([dpath,'UT_nVideos.mat']);%nVideolist
load([dpath,'UT_annotation.mat']);%'UT_annotation'
cpath =[dpath,'UT_feat/'];
hpath=[dpath,'UT_hist/'];
if ~exist(hpath,'dir')
    mkdir(hpath);
end

nCenter =4000;

for i= 1:length(UT_annotation)
    if ~exist([cpath,UT_annotation{i}.name,'.mat'],'file') || exist([hpath,UT_annotation{i}.name,'_stepsize_',num2str(stepsize),'_HISTS.mat'],'file')
        continue;
    end
    fprintf('make histogram of every %d frames. processing %s %d / %d \n',stepsize,UT_annotation{i}.name,i,length(UT_annotation));
    
    load([cpath,UT_annotation{i}.name,'.mat']);
    %'t','Tbins','HOGbins','HOFbins','MBHxbins','MBHybins','totalframe'
        
    Nnode = ceil(sum(UT_annotation{i}.nFrames)/stepsize);
    node_start =0;
    node_end=0;
    
    
    Thists=zeros(Nnode,nCenter);
    HOGhists=Thists;%zeros(Nnode,nCenter);
    HOFhists=Thists;%zeros(Nnode,nCenter);
    MBHxhists=Thists;%zeros(Nnode,nCenter);
    MBHyhists=Thists;%zeros(Nnode,nCenter);
    
    for k =1:Nnode
        node_start = (k-1)*stepsize+1;
        node_end = k*stepsize;
        Tnode_bins = Tbins(t>=node_start & t<=node_end);
        HOGnode_bins = HOGbins(t>=node_start & t<=node_end);
        HOFnode_bins = HOFbins(t>=node_start & t<=node_end);
        MBHxnode_bins = MBHxbins(t>=node_start & t<=node_end);
        MBHynode_bins = MBHybins(t>=node_start & t<=node_end);
        if ~isempty(Tnode_bins)
            Thists(k,:) =hist(Tnode_bins,1:nCenter);
        end
        if ~isempty(HOGnode_bins)
            HOGhists(k,:) =hist(HOGnode_bins,1:nCenter);
        end
        if ~isempty(HOFnode_bins)
            HOFhists(k,:) =hist(HOFnode_bins,1:nCenter);
        end
        if ~isempty(MBHxnode_bins)
            MBHxhists(k,:) =hist(MBHxnode_bins,1:nCenter);
        end
        if ~isempty(MBHynode_bins)
            MBHyhists(k,:) =hist(MBHynode_bins,1:nCenter);
        end
        
    end
    save([hpath,UT_annotation{i}.name,'_stepsize_',num2str(stepsize),'_HISTS.mat'], 'Thists','HOGhists','HOFhists','MBHxhists','MBHyhists');
end
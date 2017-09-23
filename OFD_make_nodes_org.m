function OFD_make_nodes_org(nodesize,classlist,cpath, hpath)

load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
% cpath ='./data/OFD_concat/';
% hpath='./data/OFD_concat_hist/';
if ~exist(hpath,'dir')
    mkdir(hpath);
end
nVideo = 25;

nCenters =[50,125,250,500,1000,2000,4000];
NC=7;
for class = classlist
    for i= nVideo*(class-1)+1: nVideo*class%length(ucf_annotation)
        
        fprintf('makenode org processing %s %d / %d \n',ucf_annotation{i}.name,i,class*nVideo);%length(ucf_annotation));
        load([cpath,ucf_annotation{i}.name,'_org.mat']);
        %'con_t','Tcon_bins','HOGcon_bins','HOFcon_bins','MBHxcon_bins','MBHycon_bins','totalframe'
        Tcon_bins=org_Tcon_bins;
        HOGFcon_bins=org_HOGFcon_bins;
        HOGcon_bins=org_HOGcon_bins;
        OFDLcon_bins=org_OFDLcon_bins;
        OFDRcon_bins=org_OFDRcon_bins;
        OFDTcon_bins=org_OFDTcon_bins;
        OFDBcon_bins=org_OFDBcon_bins;
        OFDAcon_bins=org_OFDAcon_bins;
        OFDCcon_bins=org_OFDCcon_bins;
        HOFcon_bins=org_HOFcon_bins;
        MBHxcon_bins=org_MBHxcon_bins;
        MBHycon_bins= org_MBHycon_bins;
        con_t = org_con_t;
        
        Nnode = ceil(sum(ucf_annotation{i}.nFrames)/nodesize);
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
                Tnode_bins{nc} = Tcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                HOGFnode_bins{nc} = HOGFcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                HOGnode_bins{nc} = HOGcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                
                OFDLnode_bins{nc} = OFDLcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                OFDRnode_bins{nc} = OFDRcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                OFDTnode_bins{nc} = OFDTcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                OFDBnode_bins{nc} = OFDBcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                OFDAnode_bins{nc} = OFDAcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                OFDCnode_bins{nc} = OFDCcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                
                HOFnode_bins{nc} = HOFcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                MBHxnode_bins{nc} = MBHxcon_bins{nc}(con_t>=node_start & con_t<=node_end);
                MBHynode_bins{nc} = MBHycon_bins{nc}(con_t>=node_start & con_t<=node_end);
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
        save([hpath,ucf_annotation{i}.name,'_nodesize_',num2str(nodesize),'_HISTS_org.mat'], 'Thists','HOGFhists','HOGhists','OFDLhists','OFDRhists','OFDThists','OFDBhists','OFDAhists','OFDChists','HOFhists','MBHxhists','MBHyhists');
    end
end


% save('./data/nodesize.mat','nodesize');e
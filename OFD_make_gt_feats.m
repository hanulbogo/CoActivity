% function KDE_make_con_feats()
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
fpath='D:\Share_with_linux\DenseTrajectory_OFD\features\';
cpath ='./data/OFD_gt_feats/';
if ~exist(cpath,'dir')
    mkdir(cpath);
end

Ti =7:13;
HOGFi=14:20;
HOGi=21:27;
OFDLi=28:34;
OFDRi=35:41;
OFDTi=42:48;
OFDBi=49:55;
OFDAi=56:62;
OFDCi=63:69;
HOFi=70:76;
MBHxi=77:83;
MBHyi=84:90;

nCenters =[50,125,250,500,1000,2000,4000];

% vname=ucf_annotation{1}.vnames(1).name;
% fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
% fid2=fopen([fpath,vname(1:end-4),'_2.feats']);
% feat1 = textscan(fid1,'%d%f%f%f%f%f%f%d%d%d%d%d');
% feat2= textscan(fid2,'%d%f%f%f%f%f%f%d%d%d%d%d');
nVideos = 25;
class =27;
NC=1;


for i= 1: class*nVideos%length(ucf_annotation)
    org_Tcon_bins=cell(NC,1);
    org_HOGFcon_bins=cell(NC,1);
    org_HOGcon_bins=cell(NC,1);
    org_OFDLcon_bins=cell(NC,1);
    org_OFDRcon_bins=cell(NC,1);
    org_OFDTcon_bins=cell(NC,1);
    org_OFDBcon_bins=cell(NC,1);
    org_OFDAcon_bins=cell(NC,1);
    org_OFDCcon_bins=cell(NC,1);
    org_HOFcon_bins=cell(NC,1);
    org_MBHxcon_bins=cell(NC,1);
    org_MBHycon_bins=cell(NC,1);
    
    Tcon_bins=cell(NC,1);
    HOGFcon_bins=cell(NC,1);
    HOGcon_bins=cell(NC,1);
    OFDLcon_bins=cell(NC,1);
    OFDRcon_bins=cell(NC,1);
    OFDTcon_bins=cell(NC,1);
    OFDBcon_bins=cell(NC,1);
    OFDAcon_bins=cell(NC,1);
    OFDCcon_bins=cell(NC,1);
    HOFcon_bins=cell(NC,1);
    MBHxcon_bins=cell(NC,1);
    MBHycon_bins=cell(NC,1);
    valid_org=[];
    valid_ofd=[];
    flowsum=[];
    org_con_t=[];
    con_t =[];
    
    totalframe=sum(ucf_annotation{i}.nFrames);
    
    fprintf('make con feat processing %s %d / %d \n',ucf_annotation{i}.name,i,class*nVideos);%length(ucf_annotation));
    for k=1:4
        vname=ucf_annotation{i}.vnames(k).name;
        fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
        
        feat1 = textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
        fclose(fid1);
        %         fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
        %         feat2= textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
        %         fclose(fid1);
        fid2=fopen([fpath,vname(1:end-4),'_2.feats']);
        feat2= textscan(fid2,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
        fclose(fid2);
        
        org_con_t =[org_con_t; feat1{1}(feat1{4}==1)+sum(ucf_annotation{i}.nFrames(1:k-1))+1; feat2{1}(feat2{4}==1)+sum(ucf_annotation{i}.nFrames(1:k-1))+1];
        con_t =[con_t; feat1{1}(feat1{5}==1)+sum(ucf_annotation{i}.nFrames(1:k-1))+1; feat2{1}(feat2{5}==1)+sum(ucf_annotation{i}.nFrames(1:k-1))+1];
        valid_org =[valid_org;feat1{4};feat2{4}];
        valid_ofd =[valid_ofd;feat1{5};feat2{5}];
        flowsum =[flowsum;feat1{6}(feat1{5}==1);feat2{6}(feat2{5}==1)];
        for nc=1:NC
            D=nCenters(nc);
            org_Tcon_bins{nc}= [ feat1{Ti(nc)}(feat1{4}==1)+1; feat2{Ti(nc)}(feat2{4}==1)+1];
            org_HOGFcon_bins{nc}=[feat1{HOGFi(nc)}(feat1{4}==1)+1; feat2{HOGFi(nc)}(feat2{4}==1)+1];
            org_HOGcon_bins{nc}=[feat1{HOGi(nc)}; feat2{HOGi(nc)}(feat2{4}==1)+1];
            org_OFDLcon_bins{nc} = [feat1{OFDLi(nc)}(feat1{4}==1)+1; feat2{OFDLi(nc)}(feat2{4}==1)+1];
            org_OFDRcon_bins{nc} = [feat1{OFDRi(nc)}(feat1{4}==1)+1; feat2{OFDRi(nc)}(feat2{4}==1)+1];
            org_OFDTcon_bins{nc} = [feat1{OFDTi(nc)}(feat1{4}==1)+1; feat2{OFDTi(nc)}(feat2{4}==1)+1];
            org_OFDBcon_bins{nc} = [feat1{OFDBi(nc)}(feat1{4}==1)+1; feat2{OFDBi(nc)}(feat2{4}==1)+1];
            org_OFDAcon_bins{nc} = [feat1{OFDAi(nc)}(feat1{4}==1)+1; feat2{OFDAi(nc)}(feat2{4}==1)+1];
            org_OFDCcon_bins{nc} = [feat1{OFDCi(nc)}(feat1{4}==1)+1; feat2{OFDCi(nc)}(feat2{4}==1)+1];
            org_HOFcon_bins{nc}=[feat1{HOFi(nc)}(feat1{4}==1)+1; feat2{HOFi(nc)}(feat2{4}==1)+1];
            org_MBHxcon_bins{nc}=[feat1{MBHxi(nc)}(feat1{4}==1)+1; feat2{MBHxi(nc)}(feat2{4}==1)+1];
            org_MBHycon_bins{nc}=[feat1{MBHyi(nc)}(feat1{4}==1)+1; feat2{MBHyi(nc)}(feat2{4}==1)+1];
            
            Tcon_bins{nc}= [feat1{Ti(nc)}(feat1{5}==1)+1; feat2{Ti(nc)}(feat2{5}==1)+1];
            HOGFcon_bins{nc}=[feat1{HOGFi(nc)}(feat1{5}==1)+1; feat2{HOGFi(nc)}(feat2{5}==1)+1];
            HOGcon_bins{nc}=[feat1{HOGi(nc)}(feat1{5}==1)+1; feat2{HOGi(nc)}(feat2{5}==1)+1];
            OFDLcon_bins{nc} = [feat1{OFDLi(nc)}(feat1{5}==1)+1; feat2{OFDLi(nc)}(feat2{5}==1)+1];
            OFDRcon_bins{nc} = [feat1{OFDRi(nc)}(feat1{5}==1)+1; feat2{OFDRi(nc)}(feat2{5}==1)+1];
            OFDTcon_bins{nc} = [feat1{OFDTi(nc)}(feat1{5}==1)+1; feat2{OFDTi(nc)}(feat2{5}==1)+1];
            OFDBcon_bins{nc} = [feat1{OFDBi(nc)}(feat1{5}==1)+1; feat2{OFDBi(nc)}(feat2{5}==1)+1];
            OFDAcon_bins{nc} = [feat1{OFDAi(nc)}(feat1{5}==1)+1; feat2{OFDAi(nc)}(feat2{5}==1)+1];
            OFDCcon_bins{nc} = [feat1{OFDCi(nc)}(feat1{5}==1)+1; feat2{OFDCi(nc)}(feat2{5}==1)+1];
            HOFcon_bins{nc}=[feat1{HOFi(nc)}(feat1{5}==1)+1; feat2{HOFi(nc)}(feat2{5}==1)+1];
            MBHxcon_bins{nc}=[feat1{MBHxi(nc)}(feat1{5}==1)+1; feat2{MBHxi(nc)}(feat2{5}==1)+1];
            MBHycon_bins{nc}=[feat1{MBHyi(nc)}(feat1{5}==1)+1; feat2{MBHyi(nc)}(feat2{5}==1)+1];
            
            if ~isempty(Tcon_bins{nc})
                Thists{nc}(k,:) =hist(Tcon_bins{nc},1:D);
            end
            if ~isempty(HOGFcon_bins{nc})
                HOGFhists{nc}(k,:) =hist(HOGFcon_bins{nc},1:D);
            end
            if ~isempty(HOGcon_bins{nc})
                HOGhists{nc}(k,:) =hist(HOGcon_bins{nc},1:D);
            end
            
            if ~isempty(OFDLcon_bins{nc})
                OFDLhists{nc}(k,:) =hist(OFDLcon_bins{nc},1:D);
            end
            if ~isempty(OFDRcon_bins{nc})
                OFDRhists{nc}(k,:) =hist(OFDRcon_bins{nc},1:D);
            end
            if ~isempty(OFDTcon_bins{nc})
                OFDThists{nc}(k,:) =hist(OFDTcon_bins{nc},1:D);
            end
            if ~isempty(OFDBcon_bins{nc})
                OFDBhists{nc}(k,:) =hist(OFDBcon_bins{nc},1:D);
            end
            if ~isempty(OFDAcon_bins{nc})
                OFDAhists{nc}(k,:) =hist(OFDAcon_bins{nc},1:D);
            end
            if ~isempty(OFDCcon_bins{nc})
                OFDChists{nc}(k,:) =hist(OFDCcon_bins{nc},1:D);
            end
            
            if ~isempty(HOFcon_bins{nc})
                HOFhists{nc}(k,:) =hist(HOFcon_bins{nc},1:D);
            end
            if ~isempty(MBHxcon_bins{nc})
                MBHxhists{nc}(k,:) =hist(MBHxcon_bins{nc},1:D);
            end
            if ~isempty(MBHycon_bins{nc})
                MBHyhists{nc}(k,:) =hist(MBHycon_bins{nc},1:D);
            end
         
    
            
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
            
            
            if ~isempty(Tcon_bins{nc})
                org_Thists{nc}(k,:) =hist(Tcon_bins{nc},1:D);
            end
            if ~isempty(HOGFcon_bins{nc})
                org_HOGFhists{nc}(k,:) =hist(HOGFcon_bins{nc},1:D);
            end
            if ~isempty(HOGcon_bins{nc})
                org_HOGhists{nc}(k,:) =hist(HOGcon_bins{nc},1:D);
            end
            
            if ~isempty(OFDLcon_bins{nc})
                org_OFDLhists{nc}(k,:) =hist(OFDLcon_bins{nc},1:D);
            end
            if ~isempty(OFDRcon_bins{nc})
                org_OFDRhists{nc}(k,:) =hist(OFDRcon_bins{nc},1:D);
            end
            if ~isempty(OFDTcon_bins{nc})
                org_OFDThists{nc}(k,:) =hist(OFDTcon_bins{nc},1:D);
            end
            if ~isempty(OFDBcon_bins{nc})
                org_OFDBhists{nc}(k,:) =hist(OFDBcon_bins{nc},1:D);
            end
            if ~isempty(OFDAcon_bins{nc})
                org_OFDAhists{nc}(k,:) =hist(OFDAcon_bins{nc},1:D);
            end
            if ~isempty(OFDCcon_bins{nc})
                org_OFDChists{nc}(k,:) =hist(OFDCcon_bins{nc},1:D);
            end
            
            if ~isempty(HOFcon_bins{nc})
                org_HOFhists{nc}(k,:) =hist(HOFcon_bins{nc},1:D);
            end
            if ~isempty(MBHxcon_bins{nc})
                org_MBHxhists{nc}(k,:) =hist(MBHxcon_bins{nc},1:D);
            end
            if ~isempty(MBHycon_bins{nc})
                org_MBHyhists{nc}(k,:) =hist(MBHycon_bins{nc},1:D);
            end
            
        end
%         fclose(fid1);
%         fclose(fid2);
        
           save([cpath,ucf_annotation{i}.name,'_ofd.mat'],'con_t','flowsum','Thists','HOGFhists','HOGhists','OFDLhists','OFDRhists','OFDThists','OFDBhists','OFDAhists','OFDChists','HOFhists','MBHxhists','MBHyhists','totalframe');
           save([cpath,ucf_annotation{i}.name,'_org.mat'],'org_con_t','org_Thists','org_HOGFhists','org_HOGhists','org_OFDLhists','org_OFDRhists','org_OFDThists','org_OFDBhists','org_OFDAhists','org_OFDChists','org_HOFhists','org_MBHxhists','org_MBHyhists','totalframe');
        clear feat1 feat2;
    end
  
end

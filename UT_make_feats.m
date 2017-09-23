% function KDE_make_feats()
load('./data/UT_nVideos.mat');%nVideolist
load('./data/UT_annotation.mat');%'UT_annotation'
fpath='D:\FeatureExtraction\Youtubefeatures\';
cpath ='./data/UT_feat/';
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

% vname=UT_annotation{1}.vnames(1).name;
% fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
% fid2=fopen([fpath,vname(1:end-4),'_2.feats']);
% feat1 = textscan(fid1,'%d%f%f%f%f%f%f%d%d%d%d%d');
% feat2= textscan(fid2,'%d%f%f%f%f%f%f%d%d%d%d%d');
nVideos = 10;
class =12;
NC=7;

for i= 1: length(UT_annotation)
    if exist([cpath,UT_annotation{i}.name,'_org.mat'],'file')
        continue;
    end
    org_Tbins=cell(NC,1);
    org_HOGFbins=cell(NC,1);
    org_HOGbins=cell(NC,1);
    org_OFDLbins=cell(NC,1);
    org_OFDRbins=cell(NC,1);
    org_OFDTbins=cell(NC,1);
    org_OFDBbins=cell(NC,1);
    org_OFDAbins=cell(NC,1);
    org_OFDCbins=cell(NC,1);
    org_HOFbins=cell(NC,1);
    org_MBHxbins=cell(NC,1);
    org_MBHybins=cell(NC,1);
    
    Tbins=cell(NC,1);
    HOGFbins=cell(NC,1);
    HOGbins=cell(NC,1);
    OFDLbins=cell(NC,1);
    OFDRbins=cell(NC,1);
    OFDTbins=cell(NC,1);
    OFDBbins=cell(NC,1);
    OFDAbins=cell(NC,1);
    OFDCbins=cell(NC,1);
    HOFbins=cell(NC,1);
    MBHxbins=cell(NC,1);
    MBHybins=cell(NC,1);
    valid_org=[];
    valid_ofd=[];
    flowsum=[];
    org_t=[];
    t =[];
    
    totalframe=sum(UT_annotation{i}.nFrames);
    
    fprintf('make con feat processing %s %d / %d \n',UT_annotation{i}.name,i,length(UT_annotation));

        vname=UT_annotation{i}.vname;
        if ~exist([fpath,vname(1:end-4),'_1.feats'],'file')
            continue;
        end
        fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
        
        feat1 = textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
        fclose(fid1);
        %         fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
        %         feat2= textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
        %         fclose(fid1);
        fid2=fopen([fpath,vname(1:end-4),'_2.feats']);
        feat2= textscan(fid2,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
        fclose(fid2);
        
        org_t =[feat1{1}(feat1{4}==1)+1; feat2{1}(feat2{4}==1)+1];
        t =[feat1{1}(feat1{5}==1)+1; feat2{1}(feat2{5}==1)+1];
        valid_org =[feat1{4};feat2{4}];
        valid_ofd =[feat1{5};feat2{5}];
        flowsum =[feat1{6}(feat1{5}==1);feat2{6}(feat2{5}==1)];
        for nc=NC
            org_Tbins{nc}= [feat1{Ti(nc)}(feat1{4}==1)+1; feat2{Ti(nc)}(feat2{4}==1)+1];
            org_HOGFbins{nc}=[feat1{HOGFi(nc)}(feat1{4}==1)+1; feat2{HOGFi(nc)}(feat2{4}==1)+1];
            org_HOGbins{nc}=[feat1{HOGi(nc)}(feat1{4}==1)+1; feat2{HOGi(nc)}(feat2{4}==1)+1];
            org_OFDLbins{nc} = [feat1{OFDLi(nc)}(feat1{4}==1)+1; feat2{OFDLi(nc)}(feat2{4}==1)+1];
            org_OFDRbins{nc} = [ feat1{OFDRi(nc)}(feat1{4}==1)+1; feat2{OFDRi(nc)}(feat2{4}==1)+1];
            org_OFDTbins{nc} = [ feat1{OFDTi(nc)}(feat1{4}==1)+1; feat2{OFDTi(nc)}(feat2{4}==1)+1];
            org_OFDBbins{nc} = [feat1{OFDBi(nc)}(feat1{4}==1)+1; feat2{OFDBi(nc)}(feat2{4}==1)+1];
            org_OFDAbins{nc} = [feat1{OFDAi(nc)}(feat1{4}==1)+1; feat2{OFDAi(nc)}(feat2{4}==1)+1];
            org_OFDCbins{nc} = [feat1{OFDCi(nc)}(feat1{4}==1)+1; feat2{OFDCi(nc)}(feat2{4}==1)+1];
            org_HOFbins{nc}=[ feat1{HOFi(nc)}(feat1{4}==1)+1; feat2{HOFi(nc)}(feat2{4}==1)+1];
            org_MBHxbins{nc}=[ feat1{MBHxi(nc)}(feat1{4}==1)+1; feat2{MBHxi(nc)}(feat2{4}==1)+1];
            org_MBHybins{nc}=[feat1{MBHyi(nc)}(feat1{4}==1)+1; feat2{MBHyi(nc)}(feat2{4}==1)+1];
            
            Tbins{nc}= [ feat1{Ti(nc)}(feat1{5}==1)+1; feat2{Ti(nc)}(feat2{5}==1)+1];
            HOGFbins{nc}=[ feat1{HOGFi(nc)}(feat1{5}==1)+1; feat2{HOGFi(nc)}(feat2{5}==1)+1];
            HOGbins{nc}=[ feat1{HOGi(nc)}(feat1{5}==1)+1; feat2{HOGi(nc)}(feat2{5}==1)+1];
            OFDLbins{nc} = [ feat1{OFDLi(nc)}(feat1{5}==1)+1; feat2{OFDLi(nc)}(feat2{5}==1)+1];
            OFDRbins{nc} = [ feat1{OFDRi(nc)}(feat1{5}==1)+1; feat2{OFDRi(nc)}(feat2{5}==1)+1];
            OFDTbins{nc} = [feat1{OFDTi(nc)}(feat1{5}==1)+1; feat2{OFDTi(nc)}(feat2{5}==1)+1];
            OFDBbins{nc} = [feat1{OFDBi(nc)}(feat1{5}==1)+1; feat2{OFDBi(nc)}(feat2{5}==1)+1];
            OFDAbins{nc} = [ feat1{OFDAi(nc)}(feat1{5}==1)+1; feat2{OFDAi(nc)}(feat2{5}==1)+1];
            OFDCbins{nc} = [ feat1{OFDCi(nc)}(feat1{5}==1)+1; feat2{OFDCi(nc)}(feat2{5}==1)+1];
            HOFbins{nc}=[ feat1{HOFi(nc)}(feat1{5}==1)+1; feat2{HOFi(nc)}(feat2{5}==1)+1];
            MBHxbins{nc}=[ feat1{MBHxi(nc)}(feat1{5}==1)+1; feat2{MBHxi(nc)}(feat2{5}==1)+1];
            MBHybins{nc}=[ feat1{MBHyi(nc)}(feat1{5}==1)+1; feat2{MBHyi(nc)}(feat2{5}==1)+1];
            
        end
        
        
        clear feat1 feat2;

    save([cpath,UT_annotation{i}.name,'_ofd.mat'],'t','flowsum','Tbins','HOGFbins','HOGbins','OFDLbins','OFDRbins','OFDTbins','OFDBbins','OFDAbins','OFDCbins','HOFbins','MBHxbins','MBHybins','totalframe');
    save([cpath,UT_annotation{i}.name,'_org.mat'],'org_t','org_Tbins','org_HOGFbins','org_HOGbins','org_OFDLbins','org_OFDRbins','org_OFDTbins','org_OFDBbins','org_OFDAbins','org_OFDCbins','org_HOFbins','org_MBHxbins','org_MBHybins','totalframe');
end





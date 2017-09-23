% function KDE_make_feats()
load('./data/HW_nVideos.mat');%nVideolist
load('./data/HW_annotation.mat');%'HW_annotation'
fpath='D:\Coactivity\hollywood\Hollywoodfeatures\';
cpath ='./data/HW_feat/';
if ~exist(cpath,'dir')
    mkdir(cpath);
end
% 0	15	1.000000	0	1	0.487322	3252	1059	2894	2802	2318	3996	1843	3424	2802	114	1914	1597	
Ti =7;
HOGFi=8;
HOGi=9;
OFDLi=10;
OFDRi=11;
OFDTi=12;
OFDBi=13;
OFDAi=14;
OFDCi=15;
HOFi=16;
MBHxi=17;
MBHyi=18;

nCenters =[50,125,250,500,1000,2000,4000];

% vname=HW_annotation{1}.vnames(1).vname;
% fid1=fopen([fpath,vname,'_1.feats']);
% fid2=fopen([fpath,vname,'_2.feats']);
% feat1 = textscan(fid1,'%d%f%f%f%f%f%f%d%d%d%d%d');
% feat2= textscan(fid2,'%d%f%f%f%f%f%f%d%d%d%d%d');

NC=7;

for i= 1: length(HW_annotation)
%     if exist([cpath,HW_annotation{i}.name,'_org.mat'],'file')
%         continue;
%     end
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
    
    totalframe=sum(HW_annotation{i}.nFrames);
    
    fprintf('make con feat processing %s %d / %d \n',HW_annotation{i}.name,i,length(HW_annotation));

        vname=HW_annotation{i}.name;
        if ~exist([fpath,vname,'_1.feats'],'file')
            continue;
        end
        fid1=fopen([fpath,vname,'_1.feats']);
        
%         feat1 = textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
        feat1= textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d');
        fclose(fid1);
        %         fid1=fopen([fpath,vname,'_1.feats']);
        %         feat2= textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
        %         fclose(fid1);
        fid2=fopen([fpath,vname,'_2.feats']);
        feat2= textscan(fid2,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d');
%         feat2= textscan(fid2,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
        fclose(fid2);
        
        org_t =[feat1{1}(feat1{4}==1)+1; feat2{1}(feat2{4}==1)+1];
        t =[feat1{1}(feat1{5}==1)+1; feat2{1}(feat2{5}==1)+1];
        valid_org =[feat1{4};feat2{4}];
        valid_ofd =[feat1{5};feat2{5}];
        flowsum =[feat1{6}(feat1{5}==1);feat2{6}(feat2{5}==1)];
        for nc=NC
            org_Tbins{nc}= [feat1{Ti}(feat1{4}==1)+1; feat2{Ti}(feat2{4}==1)+1];
            org_HOGFbins{nc}=[feat1{HOGFi}(feat1{4}==1)+1; feat2{HOGFi}(feat2{4}==1)+1];
            org_HOGbins{nc}=[feat1{HOGi}(feat1{4}==1)+1; feat2{HOGi}(feat2{4}==1)+1];
            org_OFDLbins{nc} = [feat1{OFDLi}(feat1{4}==1)+1; feat2{OFDLi}(feat2{4}==1)+1];
            org_OFDRbins{nc} = [ feat1{OFDRi}(feat1{4}==1)+1; feat2{OFDRi}(feat2{4}==1)+1];
            org_OFDTbins{nc} = [ feat1{OFDTi}(feat1{4}==1)+1; feat2{OFDTi}(feat2{4}==1)+1];
            org_OFDBbins{nc} = [feat1{OFDBi}(feat1{4}==1)+1; feat2{OFDBi}(feat2{4}==1)+1];
            org_OFDAbins{nc} = [feat1{OFDAi}(feat1{4}==1)+1; feat2{OFDAi}(feat2{4}==1)+1];
            org_OFDCbins{nc} = [feat1{OFDCi}(feat1{4}==1)+1; feat2{OFDCi}(feat2{4}==1)+1];
            org_HOFbins{nc}=[ feat1{HOFi}(feat1{4}==1)+1; feat2{HOFi}(feat2{4}==1)+1];
            org_MBHxbins{nc}=[ feat1{MBHxi}(feat1{4}==1)+1; feat2{MBHxi}(feat2{4}==1)+1];
            org_MBHybins{nc}=[feat1{MBHyi}(feat1{4}==1)+1; feat2{MBHyi}(feat2{4}==1)+1];
        end
        
        
        clear feat1 feat2;

%     save([cpath,HW_annotation{i}.vname,'_ofd.mat'],'t','flowsum','Tbins','HOGFbins','HOGbins','OFDLbins','OFDRbins','OFDTbins','OFDBbins','OFDAbins','OFDCbins','HOFbins','MBHxbins','MBHybins','totalframe');
    save([cpath,HW_annotation{i}.name,'_org.mat'],'org_t','org_Tbins','org_HOGFbins','org_HOGbins','org_OFDLbins','org_OFDRbins','org_OFDTbins','org_OFDBbins','org_OFDAbins','org_OFDCbins','org_HOFbins','org_MBHxbins','org_MBHybins','totalframe');
end





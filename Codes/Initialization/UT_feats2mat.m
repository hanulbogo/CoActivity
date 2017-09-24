function UT_feats2mat()
global dpath;
global fpath;
load([dpath,'UT_nVideos.mat']);%nVideolist
load([dpath,'UT_annotation.mat']);%'UT_annotation'
% Saved feature

cpath =[dpath,'UT_feat/'];
if ~exist(cpath,'dir')
    mkdir(cpath);
end

Ti =7;
HOGi=8;
HOFi=9;
MBHxi=10;
MBHyi=11;


for i= 1: length(UT_annotation)
    %     if exist([cpath,UT_annotation{i}.name,'.mat'],'file')
    %         continue;
    %     end
    
    t =[];
    
    totalframe=sum(UT_annotation{i}.nFrames);
    
    fprintf('concatenate original and flipped feature. processing %s %d / %d \n',UT_annotation{i}.name,i,length(UT_annotation));
    
    vname=UT_annotation{i}.vname;
    if ~exist([fpath,vname(1:end-4),'_1.feats'],'file')
        continue;
    end
    %Original feature
    fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
    feat1 = textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d');
    fclose(fid1);
    
    %Flipped feature
    fid2=fopen([fpath,vname(1:end-4),'_2.feats']);
    feat2= textscan(fid2,'%d%d%f%d%d%f%d%d%d%d%d');
    fclose(fid2);
    
    t =[feat1{1}+1; feat2{1}+1];
    
    Tbins= [ feat1{Ti}+1; feat2{Ti}+1];
    HOGbins=[ feat1{HOGi}+1; feat2{HOGi}+1];
    HOFbins=[ feat1{HOFi}+1; feat2{HOFi}+1];
    MBHxbins=[ feat1{MBHxi}+1; feat2{MBHxi}+1];
    MBHybins=[ feat1{MBHyi}+1; feat2{MBHyi}+1];
    
    
    clear feat1 feat2;
    
    save([cpath,UT_annotation{i}.name,'.mat'],'t','Tbins','HOGbins','HOFbins','MBHxbins','MBHybins','totalframe');
    
end





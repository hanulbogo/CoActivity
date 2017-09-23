% function TH_make_feats()
load('./data/TH_nVideos.mat');%nVideolist
load('./data/TH_annotation.mat');%'TH_annotation'
fpath='D:\Coactivity\TH14_test_features\';
cpath ='./data/TH_feat/';
if ~exist(cpath,'dir')
    mkdir(cpath);
end
%[Frame_num] [mean_x] [mean_y] [Traj_index] [HOG_index] [HOF_index] [MBH_index]
Ti =4;
HOGi=5;
HOFi=6;
MBHi=7;
nCenters =4000;
NC=7;
for i= 1: length(TH_annotation)
    %     if exist([cpath,TH_annotation{i}.name,'_org.mat'],'file')
    %         continue;
    %     end
    org_Tbins=cell(NC,1);
    org_HOGbins=cell(NC,1);
    org_HOFbins=cell(NC,1);
    org_MBHbins=cell(NC,1);
        
    totalframe=sum(TH_annotation{i}.nFrames);
    
    fprintf('make con feat processing %s %d / %d \n',TH_annotation{i}.name,i,length(TH_annotation));
    
    vname=TH_annotation{i}.name;
    
    fid=fopen([fpath,vname,'.txt']);
    feat= textscan(fid,'%d%f%f%d%d%d%d');
    fclose(fid);
    
    org_t =feat{1};
    for nc=NC
        org_Tbins{nc}= feat{Ti}+1;
        org_HOGbins{nc}=feat{HOGi}+1;
        org_HOFbins{nc}= feat{HOFi}+1;
        org_MBHbins{nc}= feat{MBHi}+1;
    end
    
    clear feat;
    save([cpath,TH_annotation{i}.name,'_org.mat'],'org_t','org_Tbins','org_HOGbins','org_HOFbins','org_MBHbins','totalframe');
end





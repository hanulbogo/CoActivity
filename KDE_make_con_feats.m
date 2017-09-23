% function KDE_make_con_feats()
load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
fpath='D:\Share_with_linux\dense_bagofwords\dense_features\';
cpath =['./data/KDE_concat/'];
if ~exist(cpath,'dir')
    mkdir(cpath);
end

Ti =8;
HOGi=9;
HOFi=10;
MBHxi=11;
MBHyi=12;



% vname=ucf_annotation{1}.vnames(1).name;
% fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
% fid2=fopen([fpath,vname(1:end-4),'_2.feats']);
% feat1 = textscan(fid1,'%d%f%f%f%f%f%f%d%d%d%d%d');
% feat2= textscan(fid2,'%d%f%f%f%f%f%f%d%d%d%d%d');
nVideos = 50;
class =11;

for i= 1: class*nVideos%length(ucf_annotation)
    Tcon_bins=[];
    HOGcon_bins=[];
    HOFcon_bins=[];
    MBHxcon_bins=[];
    MBHycon_bins=[];
    con_t =[];
    
    totalframe=sum(ucf_annotation{i}.nFrames);
    
    fprintf('processing %s %d / %d \n',ucf_annotation{i}.name,i,class*nVideos);%length(ucf_annotation));
    for k=1:4
        vname=ucf_annotation{i}.vnames(k).name;
        fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
        fid2=fopen([fpath,vname(1:end-4),'_2.feats']);
        feat1 = textscan(fid1,'%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d');
        feat2= textscan(fid2,'%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d');

        con_t =[con_t; feat1{1}+sum(ucf_annotation{i}.nFrames(1:k-1)); feat2{1}+sum(ucf_annotation{i}.nFrames(1:k-1))];
        Tcon_bins= [Tcon_bins; feat1{Ti}; feat2{Ti}];
        HOGcon_bins=[HOGcon_bins; feat1{HOGi}; feat2{HOGi}];
        HOFcon_bins=[HOFcon_bins; feat1{HOFi}; feat2{HOFi}];
        MBHxcon_bins=[MBHxcon_bins; feat1{MBHxi}; feat2{MBHxi}];
        MBHycon_bins=[MBHycon_bins; feat1{MBHyi}; feat2{MBHyi}];
        fclose(fid1);
        fclose(fid2);
        
        
        clear feat1 feat2;
    end
    save([cpath,ucf_annotation{i}.name,'.mat'],'con_t','Tcon_bins','HOGcon_bins','HOFcon_bins','MBHxcon_bins','MBHycon_bins','totalframe');
end




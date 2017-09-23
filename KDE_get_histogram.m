% function KDE_get_histogram()

%vidname.feats

load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
vpath='D:\Share_with_linux\dense_bagofwords\dense_features\';

D=4000;
THist = zeros(D, 1);%8
Ti =8;
HOGHist = zeros(D,1);%9
HOGi=9;
HOFHist = zeros(D,1);%10
HOFi=10;
MBHxHist = zeros(D,1);%11
MBHxi=11;
MBHyHist = zeros(D,1);%12
MBHyi=12;



vname=ucf_annotation{1}.vnames(1).name;
fid1=fopen([vpath,vname(1:end-4),'_1.feats']);
fid2=fopen([vpath,vname(1:end-4),'_2.feats']);
feat1 = textscan(fid1,'%d%f%f%f%f%f%f%d%d%d%d%d');
feat2= textscan(fid2,'%d%f%f%f%f%f%f%d%d%d%d%d');

% THist=hist(feat1{Ti},1:D)+hist(feat2{Ti},1:D);
% HOGHist=hist(feat1{HOGi},1:D)+hist(feat2{HOGi},1:D);
% HOFHist=hist(feat1{HOFi},1:D)+hist(feat2{HOFi},1:D);
% MBHxHist=hist(feat1{MBHxi},1:D)+hist(feat2{MBHxi},1:D);
% MBHyHist=hist(feat1{MBHyi},1:D)+hist(feat2{MBHyi},1:D);

fclose(fid1);
fclose(fid2);

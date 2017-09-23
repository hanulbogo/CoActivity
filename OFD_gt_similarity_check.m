% 
nodesize =10;
classlist =1;%10:27;

load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
% cpath ='./data/OFD_concat/';
cpath ='./data/OFD_gt_feats/';
Cpath = './data/OFD_gt_feats_concat/';
% matlabpool(11);
nVideos=25;
nCenters =[50,125,250,500,1000,2000,4000];
NC =1;
for class = classlist
    close all;
	
    lname =ucf_annotation{(class-1)*nVideos+1}.label;
	fprintf('%s \n',lname);
    if ~exist([Cpath,lname,'_ofd.mat'],'file')
        OFD_make_gt_feature_concat_ofd(class);
    end
    load([Cpath,lname,'_ofd.mat']);

    for nc =1:NC
        OFD_ParzenWindow_gt_ofd(class,THISTS{nc},  HOGFHISTS{nc}, HOGHISTS{nc}, OFDLHISTS{nc}, OFDRHISTS{nc}, OFDTHISTS{nc}, OFDBHISTS{nc}, OFDAHISTS{nc}, OFDCHISTS{nc}, HOFHISTS{nc}, MBHxHISTS{nc}, MBHyHISTS{nc},nCenters(nc)) ;
    end
    
    if ~exist([Cpath,lname,'_org.mat'],'file')
        OFD_make_gt_feature_concat_org(class);
    end
    load([Cpath,lname,'_org.mat']);

    for nc =1:NC
        OFD_ParzenWindow_gt_org(class,THISTS{nc},  HOGFHISTS{nc}, HOGHISTS{nc}, OFDLHISTS{nc}, OFDRHISTS{nc}, OFDTHISTS{nc}, OFDBHISTS{nc}, OFDAHISTS{nc}, OFDCHISTS{nc}, HOFHISTS{nc}, MBHxHISTS{nc}, MBHyHISTS{nc},nCenters(nc)) ;
    end
end
%  matlabpool close;




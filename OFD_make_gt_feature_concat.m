function OFD_make_gt_feature_concat_ofd(class)
nVideos =25;
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
cpath ='./data/OFD_gt_feats/';
Cpath = './data/OFD_gt_feats_concat/';
if ~exist(Cpath,'dir')
    mkdir(Cpath);
end
nCenters =[50,125,250,500,1000,2000,4000];
NC=1;
THISTS =cell(NC,1);
for i =1:nVideos
    for nc=1:NC
        THISTS{nc} = zeros(4*nVideos,nCenters(nc));
    end
end

HOGFHISTS =THISTS;
HOGHISTS=THISTS;
OFDLHISTS =THISTS;
OFDRHISTS=THISTS;
OFDTHISTS=THISTS;
OFDBHISTS=THISTS;
OFDAHISTS=THISTS;
OFDCHISTS=THISTS;
HOFHISTS=THISTS;
MBHxHISTS =THISTS;
MBHyHISTS=THISTS;

for i =1:nVideos
    for nc =1:NC
        lname =ucf_annotation{(class-1)*nVideos+i}.name;
        fprintf('%s \n',lname);
        load([cpath,lname,'_ofd.mat']);
        
        Thists{nc}=Thists{nc}./repmat(sum(Thists{nc},2),1,nCenters(nc)); %1*D
        HOGFhists{nc}=HOGFhists{nc}./repmat(sum(HOGFhists{nc},2),1,nCenters(nc));
        HOGhists{nc}=HOGhists{nc}./repmat(sum(HOGhists{nc},2),1,nCenters(nc));
        OFDLhists{nc} =OFDLhists{nc}./repmat(sum(OFDLhists{nc},2),1,nCenters(nc));
        OFDRhists{nc}=OFDRhists{nc}./repmat(sum(OFDRhists{nc},2),1,nCenters(nc));
        OFDThists{nc}=OFDThists{nc}./repmat(sum(OFDThists{nc},2),1,nCenters(nc));
        OFDBhists{nc}=OFDBhists{nc}./repmat(sum(OFDBhists{nc},2),1,nCenters(nc));
        OFDAhists{nc}=OFDAhists{nc}./repmat(sum(OFDAhists{nc},2),1,nCenters(nc));
        OFDChists{nc}=OFDChists{nc}./repmat(sum(OFDChists{nc},2),1,nCenters(nc));
        HOFhists{nc}=HOFhists{nc}./repmat(sum(HOFhists{nc},2),1,nCenters(nc));
        MBHxhists{nc}=MBHxhists{nc}./repmat(sum(MBHxhists{nc},2),1,nCenters(nc));
        MBHyhists{nc}=MBHyhists{nc}./repmat(sum(MBHyhists{nc},2),1,nCenters(nc));
        
        THISTS{nc}((nVideos-1)*4+1:nVideos*4,:) =Thists{nc};
        HOGFHISTS{nc}((nVideos-1)*4+1:nVideos*4,:) =HOGFhists{nc};
        HOGHISTS{nc}((nVideos-1)*4+1:nVideos*4,:)=HOGhists{nc};
        OFDLHISTS{nc}((nVideos-1)*4+1:nVideos*4,:) =OFDLhists{nc};
        OFDRHISTS{nc}((nVideos-1)*4+1:nVideos*4,:)=OFDRhists{nc};
        OFDTHISTS{nc}((nVideos-1)*4+1:nVideos*4,:)=OFDThists{nc};
        OFDBHISTS{nc}((nVideos-1)*4+1:nVideos*4,:)=OFDBhists{nc};
        OFDAHISTS{nc}((nVideos-1)*4+1:nVideos*4,:)=OFDAhists{nc};
        OFDCHISTS{nc}((nVideos-1)*4+1:nVideos*4,:)=OFDChists{nc};
        HOFHISTS{nc}((nVideos-1)*4+1:nVideos*4,:)=HOFhists{nc};
        MBHxHISTS{nc}((nVideos-1)*4+1:nVideos*4,:) =MBHxhists{nc};
        MBHyHISTS{nc}((nVideos-1)*4+1:nVideos*4,:)=MBHyhists{nc};
        
    end
end

save([Cpath,ucf_annotation{(class-1)*nVideos+1}.label,'.mat'],'THISTS','HOGFHISTS','HOGHISTS','OFDLHISTS','OFDRHISTS','OFDTHISTS','OFDBHISTS','OFDAHISTS','OFDCHISTS','HOFHISTS','MBHxHISTS','MBHyHISTS');
% function KDE_make_con_feats()
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
% fpath='D:\Share_with_linux\DenseTrajectory_OFD\features\';
% fpath ='F:/YDH/features/';
fpath ='D:/Share_with_linux/DenseTrajectory_OFD/features/';

cpath ='./data/OFD_concat/';
if ~exist(cpath,'dir')
    mkdir(cpath);
end
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

% vname=ucf_annotation{1}.vnames(1).name;
% fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
% fid2=fopen([fpath,vname(1:end-4),'_2.feats']);
% feat1 = textscan(fid1,'%d%f%f%f%f%f%f%d%d%d%d%d');
% feat2= textscan(fid2,'%d%f%f%f%f%f%f%d%d%d%d%d');
nVideos = 25;
class =101;
NC=1;
fid(1) = fopen('../DenseTrajectory_OFD/runthis1_ofd_missing2.bat','w');
for i= 1*nVideos: class*nVideos%length(ucf_annotation)
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
%         fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
%         
%         feat1 =textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d');
%         fclose(fid1);
%         %         fid1=fopen([fpath,vname(1:end-4),'_1.feats']);
%         %         feat2= textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
%         %         fclose(fid1);
%         fid2=fopen([fpath,vname(1:end-4),'_2.feats']);
%         feat2=textscan(fid1,'%d%d%f%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d');
%         fclose(fid2);
        flag=[0,0];
        flength=[length(feat1{1}), length(feat2{1})];
        for f=2:length(feat1)
            if flength(1)~=length(feat1{f})
                flag(1)=1;
                break;
            end
        end
       
        for f=2:length(feat2)
            if flength(2)~=length(feat2{f})
                flag(2)=1;
                break;
            end
        end
        
        
        label = ucf_annotation{i}.label;
        num = ucf_annotation{i}.name(end-1:end);

        
        if flag(1)==1
           fprintf(fid(1),['DenseTrajectory_org_50.exe ./../UCF_OFD_TWO_SET/',label,'/',num,'/',vname,' -o ', fpath,vname(1:end-4),'_1.feats\n']);
        end
        if flag(2)==1
           fprintf(fid(1),['DenseTrajectory_flipped_50.exe ./../UCF_OFD_TWO_SET/',label,'/',num,'/',vname,' -o ',fpath,vname(1:end-4),'_2.feats\n']);
        end
        
        
        clear feat1 feat2;
    end
    
end
fclose(fid(1));



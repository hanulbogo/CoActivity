fid(1) = fopen('../DenseTrajectory_OFD/runthis1_ofd.bat','w');
fid(2) = fopen('../DenseTrajectory_OFD/runthis2_ofd.bat','w');
fid(3) = fopen('../DenseTrajectory_OFD/runthis3_ofd.bat','w');
fid(4) = fopen('../DenseTrajectory_OFD/runthis4_ofd.bat','w');
fid(5) = fopen('../DenseTrajectory_OFD/runthis5_ofd.bat','w');
fid(6) = fopen('../DenseTrajectory_OFD/runthis6_ofd.bat','w');
fid(7) = fopen('../DenseTrajectory_OFD/runthis7_ofd.bat','w');
fid(8) = fopen('../DenseTrajectory_OFD/runthis8_ofd.bat','w');
fid(9) = fopen('../DenseTrajectory_OFD/runthis9_ofd.bat','w');
fid(10) = fopen('../DenseTrajectory_OFD/runthis10_ofd.bat','w');
fid(11) = fopen('../DenseTrajectory_OFD/runthis11_ofd.bat','w');

%echo asdf


% dpath ='./../UCF50_newdata/';
% dpath2 ='./../UCF50_newdata/';
dpath ='./../UCF_OFD_TWO_SET/';
dpath2 ='./../UCF_OFD_TWO_SET/';
fpath ='./features/';
% fpath2='G:\yeo\DenseTrajectory_OFD\features\';
% fpath3='G:\yeo\DenseTrajectory_OFD\checkfeatures\';
fpath2='D:\Share_with_linux\DenseTrajectory_OFD\features\';
fpath3='D:\Share_with_linux\DenseTrajectory_OFD\checkfeatures\';
dlist =dir(dpath);
isdirlist =zeros(size(dlist));
for i=1:length(dlist)
    isdirlist(i) = isdir([dpath,dlist(i).name]);
end

dlist= dlist(logical(isdirlist));
dlist= dlist(3:end);
cnt =0;
lastfiles = zeros(3,1);
checklist=[];
for c =1 : length(dlist)
    cname = dlist(c).name;
    cpath = [dpath,cname,'/'];
    cpath2 = [dpath2,cname,'/'];
    clist = dir(cpath);
    clist = clist(3:end);
    
    for v =1:length(clist)
        vpath = [cpath,clist(v).name,'/'];
        vpath2 = [cpath2,clist(v).name,'/'];
        vlist = dir([vpath,'*.avi']);
        for k=1:length(vlist)
            
            cnt=cnt+1;
            if ~exist([fpath2,vlist(k).name(1:end-4),'_1.feats'],'file') && ~exist([fpath3,vlist(k).name(1:end-4),'_1.feats'],'file')
               % fprintf(fid(rem(cnt,9)+1),['echo ', vlist(k).name,'_',num2str(floor((cnt-1)/3)+1),'-1_~3333\n']);
                fprintf(fid(rem(cnt,11)+1),['DenseTrajectory_org.exe ',vpath2,vlist(k).name,' -o ',fpath,vlist(k).name(1:end-4),'_1.feats\n']);
                
            end
            checkedfids = fopen([fpath3,vlist(k).name(1:end-4),'_1.feats'],'w');
            fclose(checkedfids);
            if ~exist([fpath2,vlist(k).name(1:end-4),'_2.feats'],'file') &&~exist([fpath3,vlist(k).name(1:end-4),'_2.feats'],'file')
                %fprintf(fid(rem(cnt,9)+1),['echo ', vlist(k).name,'_',num2str(floor((cnt-1)/3)+1),'-2_~3333\n']);
                fprintf(fid(rem(cnt,11)+1),['DenseTrajectory_flipped.exe ',vpath2,vlist(k).name,' -o ',fpath,vlist(k).name(1:end-4),'_2.feats\n']);
                
            end
            checkedfids = fopen([fpath3,vlist(k).name(1:end-4),'_2.feats'],'w');
            fclose(checkedfids);
            %fprintf('%d\n',cnt);
        end
    end
end
fclose(fid(1));
fclose(fid(2));
fclose(fid(3));
fclose(fid(4));
fclose(fid(5));
fclose(fid(6));
fclose(fid(7));
fclose(fid(8));
fclose(fid(9));
fclose(fid(10));
fclose(fid(11));



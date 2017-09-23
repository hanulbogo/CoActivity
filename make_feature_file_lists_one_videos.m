fid(1) = fopen('../dense_bagofwords/run_get_features1.sh','w');
fid(2) = fopen('../dense_bagofwords/run_get_features2.sh','w');
fid(3) = fopen('../dense_bagofwords/run_get_features3.sh','w');



dpath ='./../UCF_one/';
dpath2 ='./../../UCF_one/';
fpath ='./../dense_features/';
fpath2='D:\Share_with_linux\dense_bagofwords\dense_features\';
dlist =dir(dpath);
isdirlist =zeros(size(dlist));
for i=1:length(dlist)
    isdirlist(i) = isdir([dpath,dlist(i).name]);
end

dlist= dlist(logical(isdirlist));
dlist= dlist(3:end);
cnt =0;
lastfiles = zeros(3,1);
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
        for k=1: length(vlist)
            cnt=cnt+1;
            if ~exist([fpath2,vlist(k).name(1:end-4),'_1.feats'],'file')
                fprintf(fid(rem(cnt,3)+1),['./print_name ', vlist(k).name,'_',num2str(floor((cnt-1)/3)+1),'-1_~466\n']);
                fprintf(fid(rem(cnt,3)+1),['./DenseTrack_BOW ',vpath2,vlist(k).name,' ',fpath,vlist(k).name(1:end-4),'_1.feats\n']);
            end
            if ~exist([fpath2,vlist(k).name(1:end-4),'_1.feats'],'file')
                fprintf(fid(rem(cnt,3)+1),['./print_name ', vlist(k).name,'_',num2str(floor((cnt-1)/3)+1),'-2_~466\n']);
                fprintf(fid(rem(cnt,3)+1),['./DenseTrack_flipped_BOW ',vpath2,vlist(k).name,' ',fpath,vlist(k).name(1:end-4),'_2.feats\n']);
            end
            fprintf('%d\n',cnt);
        end
    end
end
fclose(fid(1));
fclose(fid(2));
fclose(fid(3));



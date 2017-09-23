fid(1) = fopen('../dense_flipped_sampling_ofd/run_sampling1.sh','w');
fid(2) = fopen('../dense_flipped_sampling_ofd/run_sampling2.sh','w');
fid(3) = fopen('../dense_flipped_sampling_ofd/run_sampling3.sh','w');



dpath ='./../UCF50_newdata/';

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
    clist = dir(cpath);
    clist = clist(3:end);
    for v =1:length(clist)
        vpath = [cpath,clist(v).name,'/'];
        vlist = dir([vpath,'*.avi']);
        for k=1: length(vlist)
            cnt=cnt+1;
            fprintf(fid(rem(cnt,3)+1),['./release/print_name ', vlist(k).name,'_',num2str(floor(cnt/6)+1),'-1_~3333\n']);
            if ~exist(['../dense_flipped_sampling_ofd/SampledFeatures/',num2str(cnt,'%04d'),'.sampled.features'],'file')
                fprintf(fid(rem(cnt,3)+1),['./release/DenseTrack_sampling ',vpath,vlist(k).name,' -o ./SampledFeatures/',num2str(cnt,'%04d'),'.sampled.features\n']);
            else
                lastfiles(rem(cnt,3)+1) = cnt;
            end
            cnt=cnt+1;
            fprintf(fid(rem(cnt,3)+1),['./release/print_name ', vlist(k).name,'_',num2str(floor(cnt/6)+1),'-2_~3333\n']);
            if ~exist(['../dense_flipped_sampling_ofd/SampledFeatures/',num2str(cnt,'%04d'),'.sampled.features'],'file')
                fprintf(fid(rem(cnt-1,3)+1),['./release/DenseTrack_flipped_sampling ',vpath,vlist(k).name,' -o ./SampledFeatures/',num2str(cnt,'%04d'),'.sampled.features\n']);
            else
                lastfiles(rem(cnt,3)+1) = cnt;
            end
            fprintf('%d\n',cnt);
        end
    end
end
fclose(fid(1));
fclose(fid(2));
fclose(fid(3));



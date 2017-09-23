% fid(1) = fopen('../dense_flipped_sampling/run_sampling1.sh','w');
% fid(2) = fopen('../dense_flipped_sampling/run_sampling2.sh','w');
% fid(3) = fopen('../dense_flipped_sampling/run_sampling3.sh','w');



% dpath ='./../UCF50_newdata/';
dpath ='./../UCF101/';

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
    vlist = dir(cpath);
    vlist = vlist(3:end);
    for k =1:length(vlist)
        if sum(vlist(k).name=='('|vlist(k).name==')'|vlist(k).name=='['|vlist(k).name==']'|vlist(k).name=='!'|vlist(k).name=='#'|vlist(k).name=='&'|vlist(k).name=='!'|vlist(k).name=='@'|vlist(k).name=='%'|vlist(k).name=='^'|vlist(k).name=='*'|vlist(k).name==';')
            fprintf('change name %s\n',vlist(k).name);
            newname = [vlist(k).name(1:end-8), vlist(k).name(end-3:end)];
            movefile([cpath, vlist(k).name], [cpath, newname]);
            fprintf('----------->%s \n',newname);
        end
        
    end
end
% fclose(fid(1));
% fclose(fid(2));
% fclose(fid(3));



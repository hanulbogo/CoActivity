
dpath ='./../UCF_multi/';
load('./data/multi_gt_label.mat');

dlist =dir(dpath);
isdirlist =zeros(size(dlist));
for i=1:length(dlist)
    isdirlist(i) = isdir([dpath,dlist(i).name]);
end

dlist= dlist(logical(isdirlist));
dlist= dlist(3:end);
cnt =0;
for c =1 : length(dlist)
    cname = dlist(c).name;
    cpath = [dpath,cname,'/'];
    clist = dir(cpath);
    clist = clist(3:end);
    for v =1:length(clist)
        cnt = cnt+1;
        vpath = [cpath,clist(v).name,'/'];
        vlist = dir([vpath,'*.avi']);
        rc = randperm(length(vlist));
        gt_n = 0;
        gt=zeros(length(rc),1);
        gt_start=zeros(length(rc),1);
        gt_end =zeros(length(rc),1);
        for k =1:length(rc)
       
            vnames(k).name=vlist(rc(k)).name;
            vobj = VideoReader([vpath,vlist(rc(k)).name]);
            nFrames(k) =vobj.NumberOfFrames;
            if strcmp (vlist(rc(k)).name(1:end-12) ,['v_',multi_gt_label{1,c}]) || strcmp (vlist(rc(k)).name(1:end-12) ,['v_',multi_gt_label{2,c}]) || strcmp (vlist(rc(k)).name(1:end-12) ,['v_',multi_gt_label{3,c}])
                gt_n =gt_n+1;
                gt(gt_n) = k;
                gt_start(gt_n)= sum(nFrames(1:k-1))+1;
                gt_end(gt_n)= sum(nFrames(1:k));
            end
            clear vobj;
            
        end
        gt_labels(1).name = multi_gt_label{1,c};
        gt_labels(2).name = multi_gt_label{2,c};
        gt_labels(3).name = multi_gt_label{3,c};
        fprintf('file %s %d/%d %d/%d\n',cname,v,length(clist),c,length(dlist));
        ucf_annotation{cnt}.name = [cname,'_',clist(v).name];
        ucf_annotation{cnt}.label = cname;
        ucf_annotation{cnt}.gt_labels= gt_labels;
        ucf_annotation{cnt}.vnames = vnames;
        ucf_annotation{cnt}.nFrames = nFrames;
        ucf_annotation{cnt}.rc =rc;
        ucf_annotation{cnt}.gt_start= gt_start;
        ucf_annotation{cnt}.gt_end= gt_end;
        ucf_annotation{cnt}.gt= gt;
        ucf_annotation{cnt}.gt_n= gt_n;
        clear rc nFrames gt_start gt_end gt gt_n;
    end
    
end

save('./data/ucf_multi_annotation.mat','ucf_annotation');
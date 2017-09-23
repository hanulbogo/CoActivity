function HW_edit_gt()

dpath ='D:\Coactivity\hollywood\videoclips\';

load('./data/HW_nVideos.mat');%nVideolist
load('./data/HW_annotation.mat');%'HW_annotation'

idx =1;
for cc =1: length(nVideolist)
    vname=cell(nVideolist(cc),1);
    
    for vv = 1: nVideolist(cc)
        vname{vv}= HW_annotation{idx}.vname;
        idx=idx+1; 
    end
    a =unique(vname);
    if length(a) ~=length(vname)
        fprintf('%s %d \n',HW_annotation{idx-1}.label, length(a) -length(vname))
        nVideolist(cc)= nVideolist(cc)+length(a) -length(vname);
    end
end

vv=1;
while(vv ~=length(HW_annotation))
    vname1 =HW_annotation{vv}.name(1:end);
    label1 =HW_annotation{vv}.label;
    vname2 = HW_annotation{vv+1}.name(1:end);
    label2 =HW_annotation{vv+1}.label;
    if strcmp(vname1,vname2) && strcmp(label1,label2)
        HW_annotation{vv}.gt_start = [HW_annotation{vv}.gt_start , HW_annotation{vv+1}.gt_start];
        HW_annotation{vv}.gt_end = [HW_annotation{vv}.gt_end, HW_annotation{vv+1}.gt_end];
        HW_annotation(vv+1:end-1) = HW_annotation(vv+2:end);
        HW_annotation=HW_annotation(1:end-1);
        vv=vv-1;
    end
    vv= vv+1;
    
end
% 
save('./data/HW_annotation.mat','HW_annotation');%'HW_annotation'
save('./data/HW_nVideos.mat','nVideolist');

% for vv = 1: length(HW_annotation)
%     vname =HW_annotation{vv}.name(1:end-4);
%     vpath = [dpath, HW_annotation{vv}.name(1:end)];
%     
%     HW_annotation{vv}.vname = HW_annotation{vv}.name;
%     HW_annotation{vv}.name = vname;
%     fprintf('%s \n',vname);
% %     vobj = VideoReader(vpath);
% %     HW_annotation{vv}.nFrames =vobj.NumberOfFrames;
% end
% 
% save('./data/HW_annotation.mat','HW_annotation');%'HW_annotation'
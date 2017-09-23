function HW_make_gt()

dpath ='D:\Coactivity\hollywood\videoclips\';

load('./data/HW_nVideo.mat');%HW_HW_NVideolist
load('./data/HW_annotation.mat');%'HW_annotation'

for vv = 1: length(HW_annotation)
    vname =HW_annotation{vv}.name(1:end-4);
    vpath = [dpath, HW_annotation{vv}.name(1:end)];
    
    HW_annotation{vv}.vname = HW_annotation{vv}.name;
    HW_annotation{vv}.name = vname;
    fprintf('%s \n',vname);
%     vobj = VideoReader(vpath);
%     HW_annotation{vv}.nFrames =vobj.NumberOfFrames;
end

save('./data/HW_annotation.mat','HW_annotation');%'HW_annotation'
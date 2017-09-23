% function ucf_portion(nVideos)
nVideos=10;

load('./data/UT_annotation.mat');
ucf_annotation=UT_annotation;
% load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
% dpath ='./data/UT_density_map/';
pdfpath ='./data/UCF_density_img/';
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end
pos_frames= cell(nVideos, 1);
neg_frames = cell(nVideos,1);

dth=0;
nlen =0;

gt_start= zeros(nVideos,2);
gt_end= zeros(nVideos,2);
v_start= zeros(nVideos,1);
v_end= zeros(nVideos,1);


for class =1: 12


    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    
    % label Ãâ·Â
    fprintf('%s&',lname);

gttotal=0;
nframetotal =0;

    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        
        nframetotal =nframetotal +sum(ucf_annotation{aidx}.nFrames);
        
        gt_start(v,1) = ucf_annotation{aidx}.gt_start(1);
        gt_end(v,1)= ucf_annotation{aidx}.gt_end(1);
%         gt_start(v,2) = ucf_annotation{aidx}.gt_start(2);
%         gt_end(v,2)= ucf_annotation{aidx}.gt_end(2);
%         gttotal = gttotal + gt_end(v,1)- gt_start(v,1) + gt_end(v,2)- gt_start(v,2);
                gttotal = gttotal + gt_end(v,1)- gt_start(v,1);% + gt_end(v,2)- gt_start(v,2);


    end
meangt = gttotal/nVideos;
meantotal = nframetotal/nVideos;

    fprintf('%.2f&',meangt);
    fprintf('%.2f&',meantotal);
    fprintf('%.2f\\\\ \n',meangt/meantotal);
% ,meantotal,meangt/meantotal)
    
end
% meangt = gttotal/length(ucf_annotation)
% meantotal = nframetotal/length(ucf_annotation)

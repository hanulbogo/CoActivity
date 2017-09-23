class =1;
nodesize=5;
len=75;
for vidx =1:10
    
    load('./data/ucf_one_annotation.mat');%'ucf_annotation'
    spath ='./data/seg_hists_one/';
    nVideos=50;
    
    aidx1=  (class-1)*nVideos+vidx;
    load([spath,ucf_annotation{aidx1}.label,'_nodesize_',num2str(nodesize),'_SEGHISTS_KDE_',num2str(len),'_',num2str(vidx),'_gt.mat']);
    sT = sum(TSEGHISTS,2);
    figure;
    bar(sT,'r');
    
end
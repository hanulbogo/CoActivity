load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'

classlist=3;
nVideos=50;
for class = classlist
    for vi =1:50
        
        
        
        close all;
        tic;
        lname =ucf_annotation{(class-1)*nVideos+1}.label;
        
        fprintf('Class %s\n',lname);
        
        itv=Get_interval_all(class,vi,nodesize,len);
        
        KDE_make_segments_all_vid_with_itv(nodesize, classlist, len,vi,itv);
        
        
    end
end

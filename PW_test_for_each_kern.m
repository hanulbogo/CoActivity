% function PW_test_density_normalization()
% function zstip_KDE_BASED_segmentation_run_this()
% close all;
nodesize =5;
classlist =1:50;
len= nodesize*15;

load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
spath ='./data/seg_hists/';
fprintf('Mean density\tAP\tratio of positive\n');
for class = classlist
    close all;
    tic;
    
%     KDE_make_segments(nodesize, class, len);
    KDE_make_segments_label(nodesize, class, len);
    lname =ucf_annotation{(class-1)*50+1}.label;
%     fprintf('Class %s\n',lname);
    
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat']);
    %'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS'
    
%     fprintf('finishing load segments\n');
    %
    % kern =vl_alldist2(SEGHISTS','L2');
    % imshow(exp(-0.1*(kern/numWords)));
    sumhists =sum(TSEGHISTS,2);
    density = zeros(6, size(TSEGHISTS,1));
    %     density(sumhists>=len)= ParzenWindow2(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA) ;
    density(:,sumhists>=len)= ParzenWindow_load_for_each_kern(class,len,nodesize,sumhists) ;
    KDE_make_weight_map_for_each_kern(nodesize, class, len,density);
    KDE_plot_denstiy_map_for_each_kern(nodesize, class, len);
    [lower_bound ap] =KDE_evaluate_per_frame_AP_for_each_kern(nodesize, class, len);
    for d =1 :6
        fprintf('%s\t%f\t%f\t%f\n',lname,mean(density(d,:)),ap(d),lower_bound);
    end
end

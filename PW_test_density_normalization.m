% function PW_test_density_normalization()
% function zstip_KDE_BASED_segmentation_run_this()
% close all;
nodesize =5;
classlist =6;
len= nodesize*15;

load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
spath ='./data/seg_hists/';
fprintf('Mean density\tAP\tratio of positive\n');
for class = classlist
    close all;
    tic;
    
%     KDE_make_segments(nodesize, class, len);
    lname =ucf_annotation{(class-1)*50+1}.label;
%     fprintf('Class %s\n',lname);
    
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat']);
    %'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS'
    
%     fprintf('finishing load segments\n');
    %
    % kern =vl_alldist2(SEGHISTS','L2');
    % imshow(exp(-0.1*(kern/numWords)));
    sumhists =sum(TSEGHISTS,2);
    density = zeros(1, size(TSEGHISTS,1));
    %     density(sumhists>=len)= ParzenWindow2(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA) ;
    density(sumhists>=len)= ParzenWindow_load(class,len,nodesize,sumhists) ;
    KDE_make_weight_map(nodesize, class, len,density);
    KDE_plot_denstiy_map(nodesize, class, len);
    [lower_bound ap] =KDE_evaluate_per_frame_AP(nodesize, class, len);
    fprintf('%s\t%f\t%f\t%f\n',lname,mean(density),ap,lower_bound);

    
    

%     density= density/max(density);
    
end
% classlist=9;
% for class = classlist
%     close all;
%     tic;
%     
%     KDE_make_segments(nodesize, class, len);
%     lname =ucf_annotation{(class-1)*50+1}.label;
%     fprintf('Class %s\n',lname);
%     
%     load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat']);
%     %'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS'
%     
%     fprintf('finishing load segments\n');
%     %
%     % kern =vl_alldist2(SEGHISTS','L2');
%     % imshow(exp(-0.1*(kern/numWords)));
%     sumhists =sum(TSEGHISTS,2);
%     density2 = zeros(1, size(TSEGHISTS,1));
%     %     density(sumhists>=len)= ParzenWindow2(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA) ;
%     density2(sumhists>=len)= ParzenWindow_load(class,len,nodesize,sumhists) ;
% %     density2= density2/max(density);
%     
% end
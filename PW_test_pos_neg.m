% function PW_test_density_normalization()
% function zstip_KDE_BASED_segmentation_run_this()
% close all;
nodesize =5;
classlist =3;
len= nodesize*15;

load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
spath ='./data/seg_hists_pos/';
spath2 ='./data/seg_hists_neg/';

for class = classlist
    close all;
    tic;
    lname =ucf_annotation{(class-1)*50+1}.label;
    aidx=(class-1)*50+1;
    if ~exist([spath,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_POS_',num2str(len),'.mat'],'file')
        KDE_make_segments_separate(nodesize, class, len);
    end
    
    fprintf('Class %s\n',lname);
    
    load([spath,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_POS_',num2str(len),'.mat']);
    %,'pTSEGHISTS','pHOGSEGHISTS','pHOFSEGHISTS','pMBHxSEGHISTS','pMBHySEGHISTS');
    load([spath2,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_NEG_',num2str(len),'.mat']);
    %,'nTSEGHISTS','nHOGSEGHISTS','nHOFSEGHISTS','nMBHxSEGHISTS','nMBHySEGHISTS');
       
%     fprintf('finishing load segments\n');
    %
    % kern =vl_alldist2(SEGHISTS','L2');
    % imshow(exp(-0.1*(kern/numWords)));
    psumhists =sum(pTSEGHISTS,2);
    pTDATA =pTSEGHISTS(psumhists>=len,:);
    pHOGDATA =pHOGSEGHISTS(psumhists>=len,:);
    pHOFDATA =pHOFSEGHISTS(psumhists>=len,:);
    pMBHxDATA =pMBHxSEGHISTS(psumhists>=len,:);
    pMBHyDATA =pMBHySEGHISTS(psumhists>=len,:);
    nsumhists =sum(nTSEGHISTS,2);
    nTDATA =nTSEGHISTS(nsumhists>=len,:);
    nHOGDATA =nHOGSEGHISTS(nsumhists>=len,:);
    nHOFDATA =nHOFSEGHISTS(nsumhists>=len,:);
    nMBHxDATA =nMBHxSEGHISTS(nsumhists>=len,:);
    nMBHyDATA =nMBHySEGHISTS(nsumhists>=len,:);
    
    [COEFF, SCORE,LATENT] =princomp([pTDATA,pHOGDATA,pHOFDATA,pMBHxDATA, pMBHyDATA;nTDATA,nHOGDATA,nHOFDATA,nMBHxDATA, nMBHyDATA]);
    gt_Label = [ones(size(pTDATA,1),1);-ones(size(nTDATA,1),1)];
    
    figure;
    plot(SCORE(gt_Label==-1,1),zeros(size(SCORE(gt_Label==-1,1))),'b*');
    
    hold on;
    plot(SCORE(gt_Label==1,1),zeros(size(SCORE(gt_Label==1,1))),'r*');
    hold off;
    
    figure;
    plot(SCORE(gt_Label==-1,1),SCORE(gt_Label==-1,2),'b*');
    hold on;
    plot(SCORE(gt_Label==1,1),SCORE(gt_Label==1,2),'r*');
    hold off;
    
    figure;
    plot3(SCORE(gt_Label==1,1),SCORE(gt_Label==1,2),SCORE(gt_Label==1,3),'r*');
    hold on;
    plot3(SCORE(gt_Label==-1,1),SCORE(gt_Label==-1,2),SCORE(gt_Label==-1,3),'b*');
    hold off;
    %     density(sumhists>=len)= ParzenWindow3(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA) ;
%     density(sumhists>=len)= ParzenWindow_load(class,len,nodesize,sumhists) ;
%     ParzenWindow_separate(class,pTDATA, pHOGDATA, pHOFDATA, pMBHxDATA, pMBHyDATA,nTDATA, nHOGDATA, nHOFDATA, nMBHxDATA, nMBHyDATA);
%     KDE_make_weight_map(nodesize, class, len,density);
%     KDE_plot_denstiy_map(nodesize, class, len);
%     [lower_bound ap] =KDE_evaluate_per_frame_AP(nodesize, class, len);
    

%     fprintf('Mean density for %s : %f and AP : %f and ratio of positive : %f\n',lname,mean(density),ap,lower_bound);
    

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
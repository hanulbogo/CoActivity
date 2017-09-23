    % function zstip_KDE_BASED_segmentation_run_this()
% close all;
nodesize =5;
classlist =5;
len= nodesize*15;

load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
hpath='./data/KDE_concat_hist/';
spath ='./data/seg_hists/';
dpath ='./data/KDE_density_map/';

vididx =[1,25];
% matlabpool(3);
for class = classlist
    close all;
    tic;
    lname =ucf_annotation{(class-1)*50+1}.label;
    %     if ~exist([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat'],'file')
    KDE_make_segments_two_videos(nodesize, class, len,vididx);
    %     end
    fprintf('Class %s\n',lname);
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'_two_videos.mat']);
    %'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS'
    
    fprintf('finishing load segments\n');
    %
    % kern =vl_alldist2(SEGHISTS','L2');
    % imshow(exp(-0.1*(kern/numWords)));
    sumhists =sum(TSEGHISTS,2);
    TDATA =TSEGHISTS(sumhists>=len,:);
    % [COEFF, TSCORE,TLATENT] =princomp(TDATA);
    % a=cumsum(TLATENT)/sum(TLATENT);
    % [foo Tidx] =max(a(a<0.9));
    % Tdata = TSCORE(:,1:Tidx);
    % fprintf('finish Trajectory PCA\n');
    
    % sumhists2 =sum(HOGSEGHISTS,2);
    HOGDATA =HOGSEGHISTS(sumhists>=len,:);
    % [COEFF, HOGSCORE,HOGLATENT] =princomp(HOGDATA);
    % a=cumsum(HOGLATENT)/sum(HOGLATENT);
    % [foo HOGidx] =max(a(a<0.9));
    % HOGdata = HOGSCORE(:,1:HOGidx);
    % fprintf('finish HOG PCA\n');
    
    % sumhists3 =sum(HOFSEGHISTS,2);
    HOFDATA =HOFSEGHISTS(sumhists>=len,:);
    % [COEFF, HOFSCORE,HOFLATENT] =princomp(HOFDATA);
    % a=cumsum(HOFLATENT)/sum(HOFLATENT);
    % [foo HOFidx] =max(a(a<0.9));
    % HOFdata = HOFSCORE(:,1:HOFidx);
    % fprintf('finish HOF PCA\n');
    
    % sumhists4 =sum(MBHxSEGHISTS,2);
    MBHxDATA =MBHxSEGHISTS(sumhists>=len,:);
    % [COEFF, MBHxSCORE,MBHxLATENT] =princomp(MBHxDATA);
    % a=cumsum(MBHxLATENT)/sum(MBHxLATENT);
    % [foo MBHxidx] =max(a(a<0.9));
    % MBHxdata = MBHxSCORE(:,1:MBHxidx);
    % fprintf('finish MBHx PCA\n');
    
    % sumhists5 =sum(MBHySEGHISTS,2);
    MBHyDATA =MBHySEGHISTS(sumhists>=len,:);
    % [COEFF, MBHySCORE,MBHyLATENT] =princomp(MBHyDATA);
    % a=cumsum(MBHyLATENT)/sum(MBHyLATENT);
    % [foo MBHyidx] =max(a(a<0.9));
    % MBHydata = MBHySCORE(:,1:MBHyidx);
    % fprintf('finish MBHy PCA\n');
    
    % TDATA HOGDATA HOFDATA MBHxDATA MBHyDATA
    % [data ,settings] = mapminmax(data);
    % [data ,settings] = mapminmax(SCORE(:,1:idx));
    % kern =vl_alldist2(data(2400:end,:)','L2');
    % figure;imshow(exp(-0.1*(kern/15)),[]);
    % D=2500;
    % N=400;
    % data= randi([1, 1000],D,N);
    % p= kde(data,'rot');
    % s = evaluate(p,data);
    
    fprintf('start DE\n');
    
    
    density = zeros(1, size(TSEGHISTS,1));
%     density(sumhists>=len)= ParzenWindow2(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA) ;
    density(sumhists>=len)= ParzenWindow3_two_videos(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,sumhists,vididx) ;
%     density(sumhists>=len)= ParzenWindow4(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,sumhists) ;
    fprintf('finish DE\n');
    if min(density)~=0
        density= density/min(density~=0);
    end
        
    KDE_make_weight_map_two_videos(nodesize, class, len,density,vididx);
    KDE_plot_denstiy_map_two_videos(nodesize, class, len,vididx);
%     KDE_evaluate_per_frame_two_videos(nodesize, class, len,vididx);
    toc;
end
% matlabpool close;
% function zstip_KDE_BASED_segmentation_run_this()
close all;
nodesize =5;
classlist =1:1;
len= nodesize*10;

load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
hpath='./data/KDE_concat_hist/';
spath ='./data/seg_hists/';
dpath ='./data/KDE_density_map/';


KDE_make_segments(nodesize, classlist, len);
for class = classlist
    lname =ucf_annotation{(class-1)*50+1}.label;
    load([spath,lname,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_',num2str(len),'.mat']);
    %'TSEGHISTS','HOGSEGHISTS','HOFSEGHISTS','MBHxSEGHISTS','MBHySEGHISTS'
end
fprintf('finishing load segments\n');
%
% kern =vl_alldist2(SEGHISTS','L2');
% imshow(exp(-0.1*(kern/numWords)));
sumhists =sum(TSEGHISTS,2);
TDATA =TSEGHISTS(sumhists>=len,:);
[COEFF, TSCORE,TLATENT] =princomp(TDATA);
a=cumsum(TLATENT)/sum(TLATENT);
[foo Tidx] =max(a(a<0.9));
Tdata = TSCORE(:,1:Tidx);
fprintf('finish Trajectory PCA\n');

sumhists2 =sum(HOGSEGHISTS,2);
HOGDATA =HOGSEGHISTS(sumhists>=len,:);
[COEFF, HOGSCORE,HOGLATENT] =princomp(HOGDATA);
a=cumsum(HOGLATENT)/sum(HOGLATENT);
[foo HOGidx] =max(a(a<0.9));
HOGdata = HOGSCORE(:,1:HOGidx);
fprintf('finish HOG PCA\n');

sumhists3 =sum(HOFSEGHISTS,2);
HOFDATA =HOFSEGHISTS(sumhists>=len,:);
[COEFF, HOFSCORE,HOFLATENT] =princomp(HOFDATA);
a=cumsum(HOFLATENT)/sum(HOFLATENT);
[foo HOFidx] =max(a(a<0.9));
HOFdata = HOFSCORE(:,1:HOFidx);
fprintf('finish HOF PCA\n');

sumhists4 =sum(MBHxSEGHISTS,2);
MBHxDATA =MBHxSEGHISTS(sumhists>=len,:);
[COEFF, MBHxSCORE,MBHxLATENT] =princomp(MBHxDATA);
a=cumsum(MBHxLATENT)/sum(MBHxLATENT);
[foo MBHxidx] =max(a(a<0.9));
MBHxdata = MBHxSCORE(:,1:MBHxidx);
fprintf('finish MBHx PCA\n');

sumhists5 =sum(MBHySEGHISTS,2);
MBHyDATA =MBHySEGHISTS(sumhists>=len,:);
[COEFF, MBHySCORE,MBHyLATENT] =princomp(MBHyDATA);
a=cumsum(MBHyLATENT)/sum(MBHyLATENT);
[foo MBHyidx] =max(a(a<0.9));
MBHydata = MBHySCORE(:,1:MBHyidx);
fprintf('finish MBHy PCA\n');

data =[Tdata HOGdata HOFdata MBHxdata MBHydata];
% [data ,settings] = mapminmax(data);
% [data ,settings] = mapminmax(SCORE(:,1:idx));
% kern =vl_alldist2(data(2400:end,:)','L2');
% figure;imshow(exp(-0.1*(kern/15)),[]);
% D=2500;
% N=400;
% data= randi([1, 1000],D,N);
% p= kde(data,'rot');
% s = evaluate(p,data);
fprintf('finishPCA\n');

fprintf('start KDE\n');

p= kde(data(:,:)','rot' );
density = zeros(1, size(TSEGHISTS,1));
density(sumhists>=len)= evaluate(p,data');
fprintf('finish KDE\n');
if min(density)~=0
    density= density/min(density~=0);
end
plot(density,'r-');
KDE_make_weight_map(nodesize, classlist, len,density);
for class = classlist
    load([dpath,ucf_annotation{(class-1)*50+1}.label,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'.mat']); %density_map
end
KDE_plot_denstiy_map(nodesize, classlist, len);


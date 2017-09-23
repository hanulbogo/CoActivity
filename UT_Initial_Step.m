% Video path.
global droot;
global dpath;
global fpath;
droot ='D:\Coactivity\AddDataset\';
dpath ='./../data/';
fpath='F:\CoActivity\Youtubefeatures\';
if ~exist(dpath,'dir')
    mkdir(dpath);
end
stepsize=10;

% UT_make_gt() %: new annotation
% UT_feats2mat();
UT_step_hist(stepsize);
function Exhaustive_search(class,vi,vj)

% pickEx = 6; % pickEx=1~8 for picking demo examples

nodesize=5;
len=75;
nVideos=25;

load('./data/ucf_one_annotation.mat');
hpath = './data/KDE_concat_hist_one/';
rpath3 = './data/BOW_res/';
if ~exist(rpath3,'dir')
    mkdir(rpath3);
end

aidx = (class-1)*25+vi;
itv(1,1)=ceil(ucf_annotation{aidx}.gt_start(1)/nodesize);
itv(1,2) = ceil(ucf_annotation{aidx}.gt_end(1)/nodesize);
fprintf('%s\n',[ucf_annotation{aidx}.label,'_',num2str(vi),'_',num2str(vj)]);
load([hpath,ucf_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
%, 'Thists','HOGhists','HOFhists','MBHxhists','MBHyhists');
%             load('./../data/KDE_concat_hist_one/Billiards_01_nodesize_5_HISTS.mat');
s1 = [Thists, HOGhists,HOFhists,MBHxhists,MBHyhists];
s1 = sum(s1(itv(1,1):itv(1,2),:));
s1 = s1/sum(s1);
clear Thists HOGhists HOFhists MBHxhists MBHyhists;
aidx2 = (class-1)*25+vj;
load([hpath,ucf_annotation{aidx2}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
%             load('./../data/KDE_concat_hist/Billards_24_nodesize_5_HISTS.mat');
s2= [Thists, HOGhists,HOFhists,MBHxhists,MBHyhists];
clear Thists HOGhists HOFhists MBHxhists MBHyhists;
tic;
minval=inf;
gt_start=ucf_annotation{(class-1)*nVideos+vj}.gt_start(1);
gt_end=ucf_annotation{(class-1)*nVideos+vj}.gt_end(1);
fprintf('Exhaustive Search\n');
minvals = zeros(size(s2,1)-len/nodesize+1,1);
minidx = zeros(size(s2,1)-len/nodesize+1,1);
parfor startpos=1:size(s2,1)-len/nodesize+1
    Nend = size(s2,1)-(startpos+len/nodesize-1)+1;
    vals = zeros(Nend,1);
    fprintf('class %d vid %d vid %d %d/ %d\n',class,vi,vj,startpos, size(s2,1)-len/nodesize+1);
    for endpos = startpos+len/nodesize-1:size(s2,1)
        Ns =sum(s2(startpos:endpos,:));
        Ns = Ns/sum(Ns);
        denom = s1+Ns;
        denom(denom==0)=1;
        cnt = endpos - (startpos+len/nodesize-1)+1;
        vals(cnt) =sum(((s1-Ns).^2) ./ (denom));
    end
    [minvals(startpos) minidx(startpos)]=min(vals);
end
[minval minstart] = min(minvals);
minend =minidx(minstart)+minstart+len/nodesize-1-1;
fprintf('solution val : %d\n',minval);

fprintf('GT : %d - %d\n', gt_start,gt_end);
fprintf('Exhaustive search Result : %d - %d\n',(minstart-1)*nodesize+1, minend*nodesize);
bowstart  =(minstart-1)*nodesize+1;
bowend = minend*nodesize;
save([rpath3,num2str(class),'_',num2str(vi),'_',num2str(vj),'.mat'],'bowstart','bowend');
    
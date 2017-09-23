function ucf_generate_actoms_N_videos(class,feat_path,apath,kpath,nVideos,nodesize,Dim)
if ~exist(apath,'dir')
    mkdir(apath);
end
load(feat_path); %'HISTS','frame_index' %D*N
concate_hists =[];
for v = 1: nVideos
    concate_hists = [concate_hists HISTS{v}];
end
% pf1 = vis_feas(1).vi;
% pf2 = vis_feas(2).vi;
% pf11 = pf1(2:end,:);
% pf21 = pf2(2:end,:);
% pf1 = pf1(1,:);
% pf2 = pf2(1,:);
% K = chi2_k([pf11(1:4000,:) pf21(1:4000,:)],[pf11(1:4000,:) pf21(1:4000,:)]);
if ~exist(['kernelmatrix_',num2str(class),'_nodesize_',num2str(nodesize),'_Dim_', num2str(Dim),'.mat'],'file')
    K = chi2_k(concate_hists,concate_hists);
    save(['kernelmatrix_',num2str(class),'_nodesize_',num2str(nodesize),'_Dim_', num2str(Dim),'.mat'],'K');
else
    load(['kernelmatrix_',num2str(class),'_nodesize_',num2str(nodesize),'_Dim_', num2str(Dim),'.mat'],'K');
end

% [v,d] = eigs(K);
% v = v(:,1:3);
% da1 = zeros(1,size(pf11,2),3);
% da2 = zeros(1,size(v,1)-size(pf11,2),3);
% da1(1,:,:) = v(1:size(pf11,2),:);
% da2(1,:,:) = v(size(pf11,2)+1:end,:);
% pairs(1).da1 = da1;
% pairs(1).da2 = da2;
% pairs(1).H = K;
% save('pairs_direct.mat','-v7.3','pairs');

numk=6;
% num = size(pf11,2);
nums = zeros(nVideos,1);
for v=1:nVideos
    nums(v)= size(HISTS{v},2);
end
nums =cumsum(nums);
[seg1, H, DA] = demo_aca(numk,nums,K,nVideos);

pairs(1).DA = DA;
pairs(1).H =H;
% pairs(1).da1 = da1;
% pairs(1).da2 = da2;
% pairs(1).H = H;
% save('pairs.mat','-v7.3','pairs','seg1','pf1','pf2');
save([apath,'pairs_',num2str(class),'_nodesize_',num2str(nodesize),'_Dim_', num2str(Dim),'.mat'],'-v7.3','pairs','seg1','frame_index');
%,'pf1','pf2');

function [seg1, H, DA] = demo_aca(numk,nums,K,nVideos)

para.kF = 3;
para.k = numk;%6;
para.nMi = 1;
para.nMa = 4;
% para.nMi = 1;
% para.nMa = 4;
para.ini = 'r';
para.nIni = 8;

%% init
seg0s = segIni(K, para);

%% aca
seg = segAca(K, para, seg0s{1});
%seg.s = orders+1;
%seg.G = zeros(numk,length(orders)-1);



%%da1 da2 H
% seg1 = seg;
% for i = 1:length(seg.s)-1;
%     %num = size(K,2);
%     %divide segments which is obatined from two videos
%     if seg.s(i) < num && seg.s(i+1) > num
%         seg1.s = [seg.s(1:i) num seg.s(i+1:end)];
%     end
% end

seg1 = seg;
nidx=1;
added=0;
for i = 1:length(seg.s)-1;
    %num = size(K,2);
    %divide segments which is obatined from two videos
    if seg.s(i) < nums(nidx)+1 && seg.s(i+1) > nums(nidx)+1
        seg1.s = [seg1.s(1:i+added) nums(nidx)+1 seg1.s(i+1+added:end)];
        added = added+1;
        nidx =nidx+1;
    elseif seg.s(i)== nums(nidx)+1
        nidx =nidx+1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%여기까지함.

[v,d] = eigs(K);
v = v(:,1:3);
v= v';
DA = cell(nVideos,1);
DA{1} = zeros(1,0,3);

% da1 = zeros(1,0,3);
% ind1 = 1;
% da2 = zeros(1,0,3);
% ind2 = 1;
idx = 1;
nidx=1;
for i = 1:length(seg1.s)-1;
    %num = size(v,2);
    temp = v(1:3,seg1.s(i):seg1.s(i+1)-1);
    temp = sum(temp,2);
    
    if seg1.s(i) < nums(nidx) +1
        DA{nidx}(1,idx,:)=temp;
        idx = idx+1;
    else
        nidx =nidx+1;
        if nidx<=nVideos
            DA{nidx}(1,1,:)=temp;
            idx = 2;
        end
    end
%     if seg1.s(i) <= num  -->이러면 틀릴듯 s(i)<num까지 해야되는데...
%         da1(1,ind1,:) = temp;
%         ind1 = ind1 + 1;
%         
%     else
%         
%         da2(1,ind2,:) = temp;
%         ind2 = ind2 + 1;
%     end
end

n = size(K, 1);

% local constarint
lc = ps(para, 'lc', 0);

% frame weights
wFs = ps(para, 'wFs', []);
if isempty(wFs)
    wFs = ones(1, n);
end

% pairwise DTAK
H = dtaksFord(K, seg1, lc, wFs);


function output = compute_framekernel(p1,p2)
p1_f = [];
for i = 1:size(p1.info,1)
    p1_f = [ p1_f;p1.info(i,:)];
end

p2_f = [];
for i = 1:size(p2.info,1)
    p2_f = [p2_f; p2.info(i,:)];
end
if size(p1_f,1) < 1 || size(p2_f,1) < 1
    v1 = 0;
else
K1 = chi2_k(p1_f(:,9:end)',p2_f(:,9:end)');
% temp = ones(size(K1))-diag(ones(size(K1,1),1));
% K1 = K1.*temp;
v1 = max(max(K1));
end

v2_t = [];
pos1_c = [p1.pos(1) (p1.pos(1)+p1.pos(3))/2 p1.pos(3)];
pos1_r = [p1.pos(2) (p1.pos(2)+p1.pos(4))/2 p1.pos(4)];
pos2_c = [p2.pos(1) (p2.pos(1)+p2.pos(3))/2 p2.pos(3)];
pos2_r = [p2.pos(2) (p2.pos(2)+p2.pos(4))/2 p2.pos(4)];
for i = 1:2
    for j = 1:2
    temp1 = p1_f(p1_f(:,1)>pos1_c(i) & p1_f(:,1) < pos1_c(i+1) & p1_f(:,2)>pos1_r(j) & p1_f(:,2)<pos1_r(j+1),9:end);
    temp2 = p2_f(p2_f(:,1)>pos2_c(i) & p2_f(:,1) < pos2_c(i+1) & p2_f(:,2)>pos2_r(j) & p2_f(:,2)<pos2_r(j+1),9:end);
    if size(temp1,1) < 1 || size(temp2,1) < 1
        v2_t = [v2_t 0];
    else
    K2 = chi2_k(temp1',temp2');
%     temp = ones(size(K2))-diag(ones(size(K2,1),1));
%     K2 = K2.*temp;
    v2_t = [v2_t max(max(K2))];
    end
    end
end

output = (v1+sum(v2_t)/2)/2;




function density=ParzenWindow_one_all(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize) %data : N*D
dpath = './data/dists_one_all/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end
dists = cell(5,1);
if ~exist([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'.mat'],'file')
    dists{1} =PW_paralleldists_multi_vid(TDATA','CHI2',class,1);
    dists{2} =PW_paralleldists_multi_vid(HOGDATA','CHI2',class,2);
    dists{3} =PW_paralleldists_multi_vid(HOFDATA','CHI2',class,3);
    dists{4} =PW_paralleldists_multi_vid(MBHxDATA','CHI2',class,4);
    dists{5} =PW_paralleldists_multi_vid(MBHyDATA','CHI2',class,5);
    save([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'.mat'],'dists');
else
    load([dpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'.mat']);
end

load('./data/ucf_one_annotation.mat');%'ucf_annotation'
didx = 2:5;
Kern = PW_calc_Kern_from_dist_one_vid(dists,didx);
% D = zeros(size(dists{1}));
% for i=1:5
%     D = D+dists{i};
% end
nVideos=25;
nnodes = zeros(nVideos,1);


for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end
mask= ones(size(Kern));
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    mask(startidx:endidx,startidx:endidx) =0;
end
Kern =Kern.*mask;
% % figure;
% imshow(Kern,[]);
% hold on;
% ginput(1);
% hold off;
density =sum(Kern)./sum(mask);
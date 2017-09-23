function density=ParzenWindow_load_for_each_kern(class,len,nodesize,sumhists) %data : N*D

% dist =vl_alldist2(data','CHI2');
% Kern1 =PW_paralleldists(TDATA','CHI2'); 
% Kern2 =PW_paralleldists(HOGDATA','CHI2'); 
% Kern3 =PW_paralleldists(HOFDATA','CHI2'); 
% Kern4 =PW_paralleldists(MBHxDATA','CHI2'); 
% Kern5 =PW_paralleldists(MBHyDATA','CHI2'); 
% Kern= ((((Kern1.*Kern2).*Kern3).*Kern4).*Kern5);
% save(['./data/Kernel/',num2str(class),'.mat'],'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');
spath ='./data/seg_hists/';

load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'

load(['./data/Kernel/',num2str(class),'.mat']);%,'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');


nVideos=50;
nnodes = zeros(nVideos,1);


for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end

if ~exist(['./data/kernel_img/',ucf_annotation{aidx}.label,'/'],'dir')
    mkdir(['./data/kernel_img/',ucf_annotation{aidx}.label,'/']);
end
load([spath,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_SEGHISTS_KDE_label',num2str(len),'.mat']);
% L =1:size(Kern,1);
% nlabel =logical(label(sumhists>=len));
% img = zeros(size(Kern,1),size(Kern,1),3);
% img(:,:,1)= floor(Kern*255);
% img(~nlabel,:,2) = floor(Kern(~nlabel,:)*255);
% img(~nlabel,:,3) = floor(Kern(~nlabel,:)*255);
% h=figure; imshow(uint8(img));
% hold on;
% % plot(zeros(length(L(logical(label(sumhists>=len)))),1), L(logical(label(sumhists>=len))),'r.','MarkerSize',80);
% hold off;
% print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_0.pdf']);
% 
% close(h);
% 
% img = zeros(size(Kern1,1),size(Kern1,1),3);
% img(:,:,1)= floor(Kern1*255);
% img(~nlabel,:,2) = floor(Kern1(~nlabel,:)*255);
% img(~nlabel,:,3) = floor(Kern1(~nlabel,:)*255);
% h=figure; imshow(uint8(img));
% print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_Traj.pdf']);
% close(h);
% 
% img = zeros(size(Kern2,1),size(Kern2,1),3);
% img(:,:,1)= floor(Kern2*255);
% img(~nlabel,:,2) = floor(Kern2(~nlabel,:)*255);
% img(~nlabel,:,3) = floor(Kern2(~nlabel,:)*255);
% h=figure; imshow(uint8(img));
% print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_HOG.pdf']);
% close(h);
% 
% img = zeros(size(Kern3,1),size(Kern3,1),3);
% img(:,:,1)= floor(Kern3*255);
% img(~nlabel,:,2) = floor(Kern3(~nlabel,:)*255);
% img(~nlabel,:,3) = floor(Kern3(~nlabel,:)*255);
% h=figure; imshow(uint8(img));
% print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_HOF.pdf']);
% close(h);
% 
% img = zeros(size(Kern4,1),size(Kern4,1),3);
% img(:,:,1)= floor(Kern4*255);
% img(~nlabel,:,2) = floor(Kern4(~nlabel,:)*255);
% img(~nlabel,:,3) = floor(Kern4(~nlabel,:)*255);
% h=figure; imshow(uint8(img));
% print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_MBHx.pdf']);
% close(h);
% 
% img = zeros(size(Kern5,1),size(Kern5,1),3);
% img(:,:,1)= floor(Kern5*255);
% img(~nlabel,:,2) = floor(Kern5(~nlabel,:)*255);
% img(~nlabel,:,3) = floor(Kern5(~nlabel,:)*255);
% h=figure; imshow(uint8(img));
% print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_MBHy.pdf']);
% close(h);




total_nodes =  sum(nnodes);
mask=ones(total_nodes,total_nodes);
for v=1:nVideos
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    mask(startidx:endidx,startidx:endidx) =0;
end
idx =1:total_nodes;
kidx=idx(sumhists>=len);
mask =mask(kidx,:);
mask =mask(:,kidx);

% Kern = Kern1.*mask;
density =[sum(Kern1.*mask); sum(Kern2.*mask);sum(Kern3.*mask);sum(Kern4.*mask);sum(Kern5.*mask);sum(Kern.*mask)];

    %1*N
% for i = 1: length(Kern)
%     startidx= i-floor(len/2);
%     endidx= i+floor(len/2);
%     if startidx <1
%         startidx=1;
%     end
%     if endidx>length(Kern)
%         endidx = length(Kern);
%     end
%     density(i) = density(i)-sum(Kern(startidx:endidx,i));
% end
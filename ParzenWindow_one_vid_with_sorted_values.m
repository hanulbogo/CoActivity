function density=ParzenWindow_one_vid_with_sorted_values(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,vididx) %data : N*D
Kpath ='./data/dists_one/';
if ~exist(Kpath,'dir')
    mkdir(Kpath);
end
kimgpath = './data/kernel_img_one/';
if ~exist(kimgpath,'dir');
    mkdir(kimgpath);
end
if ~exist([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_two_videos_all.mat'],'file') 
    dists{1}=PW_paralleldists_two_videos(TDATA','CHI2',class,1);
    dists{2}=PW_paralleldists_two_videos(HOGDATA','CHI2',class,2);
    dists{3}=PW_paralleldists_two_videos(HOFDATA','CHI2',class,3);
    dists{4}=PW_paralleldists_two_videos(MBHxDATA','CHI2',class,4);
    dists{5}=PW_paralleldists_two_videos(MBHyDATA','CHI2',class,5);
    save([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_two_videos_all.mat'],'dists');
else
        load([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_two_videos_all.mat']);%'dists'
end
Kern = PW_calc_Kern_from_dist_one_vid(dists);
% Kern =Kern1;
% tmpKern=[Kern1(:)';Kern2(:)';Kern4(:)';Kern4(:)';Kern5(:)'];
% maxKern= max(tmpKern);
% Kern = reshape(maxKern, size(Kern1,1),size(Kern1,2));



load('./data/ucf_one_annotation.mat');%'ucf_annotation'

% load(['./data/Kernel/',num2str(class),'.mat']);%,'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');


nVideos=25;
nnodes = zeros(nVideos,1);

for v=vididx
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end
h=figure; imshow(uint8(Kern*255));
% print(h,'-dpdf',[kimgpath,ucf_annotation{aidx}.label,'_two_videos.pdf']);
% close(h);

total_nodes =  sum(nnodes);
mask=ones(total_nodes,total_nodes);
for i=1:2
    v=vididx(i);
    startidx(i) = sum(nnodes(1:v-1))+1;
    endidx(i) = sum(nnodes(1:v));
    
end
K=15;
Kern =Kern(startidx(1):endidx(1), startidx(2):endidx(2));
[foo bestidxA] =max(Kern);
[foo bestidxB] = max(Kern');
Bestmatching=zeros(size(Kern));
Bestmatching2=zeros(size(Kern));
for i =1: size(Kern,1)
    [foo sorti]=sort(Kern(i,:),'descend');
    Bestmatching(i,sorti(1:K))=255;
end
for i =1: size(Kern,2)
    [foo sorti]=sort(Kern(:,i),'descend');
    Bestmatching2(sorti(1:K),i)=255;
end
figure;
imshow(Bestmatching);
figure;
imshow(Bestmatching2);
hold on;
ginput(1);
hold off;
density=0;
% figure; 
% title('Org Kern');
% hold on;
% imshow(uint8(Kern*255));
% hold off;
% % density =sum(Kern); %1*N
% [itv1, itv2]= Find_best_pair_by_sort(Kern,class,vididx,nodesize,len);
% density =0;
% % [itv1, itv2] =Find_best_pair(Kern, mask,len,nodesize,vididx,class,nnodes);

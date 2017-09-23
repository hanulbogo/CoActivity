function density=ParzenWindow3_two_videos(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA,len,nodesize,sumhists,vididx) %data : N*D

Kern1 =PW_paralleldists_two_videos(TDATA','CHI2',class,1); 
Kern2 =PW_paralleldists_two_videos(HOGDATA','CHI2',class,2); 
Kern3 =PW_paralleldists_two_videos(HOFDATA','CHI2',class,3); 
Kern4 =PW_paralleldists_two_videos(MBHxDATA','CHI2',class,4); 
Kern5 =PW_paralleldists_two_videos(MBHyDATA','CHI2',class,5); 
Kern= ((((Kern1.*Kern2).*Kern3).*Kern4).*Kern5);
% Kern =Kern1;
% tmpKern=[Kern1(:)';Kern2(:)';Kern4(:)';Kern4(:)';Kern5(:)'];
% maxKern= max(tmpKern);
% Kern = reshape(maxKern, size(Kern1,1),size(Kern1,2));
save(['./data/Kernel/',num2str(class),'_two_videos.mat'],'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');


load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'

% load(['./data/Kernel/',num2str(class),'.mat']);%,'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');
h=figure; imshow(uint8(Kern*255));

nVideos=50;
nnodes = zeros(nVideos,1);


for v=vididx
    aidx =(class-1)*nVideos+v;
    nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
end


print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'_two_videos.pdf']);
close(h);
total_nodes =  sum(nnodes);
mask=ones(total_nodes,total_nodes);
for v=vididx
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    mask(startidx:endidx,startidx:endidx) =0;
end
idx =1:total_nodes;
kidx=idx(sumhists>=len);
mask =mask(kidx,:);
mask =mask(:,kidx);
figure;imshow(mask,[]);
Kern = Kern.*mask;
figure; imshow(uint8(Kern*255));
density =sum(Kern); %1*N

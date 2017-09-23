function density=ParzenWindow_load(class,len,nodesize,sumhists) %data : N*D

% dist =vl_alldist2(data','CHI2');
% Kern1 =PW_paralleldists(TDATA','CHI2'); 
% Kern2 =PW_paralleldists(HOGDATA','CHI2'); 
% Kern3 =PW_paralleldists(HOFDATA','CHI2'); 
% Kern4 =PW_paralleldists(MBHxDATA','CHI2'); 
% Kern5 =PW_paralleldists(MBHyDATA','CHI2'); 
% Kern= ((((Kern1.*Kern2).*Kern3).*Kern4).*Kern5);
% save(['./data/Kernel/',num2str(class),'.mat'],'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');


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
h=figure; imshow(uint8(floor(Kern*255)));
print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_0.pdf']);
close(h);

h=figure; imshow(uint8(floor(Kern1*255)));
print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_Traj.pdf']);
close(h);

h=figure; imshow(uint8(floor(Kern2*255)));
print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_HOG.pdf']);
close(h);

h=figure; imshow(uint8(floor(Kern3*255)));
print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_HOF.pdf']);
close(h);

h=figure; imshow(uint8(floor(Kern4*255)));
print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_MBHx.pdf']);
close(h);

h=figure; imshow(uint8(floor(Kern5*255)));
print(h,'-dpdf',['./data/kernel_img/',ucf_annotation{aidx}.label,'/',ucf_annotation{aidx}.label,'_MBHy.pdf']);
close(h);




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

Kern = Kern.*mask;
density =sum(Kern); %1*N
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
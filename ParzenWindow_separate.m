function ParzenWindow_separate(class,pTDATA, pHOGDATA, pHOFDATA, pMBHxDATA, pMBHyDATA,nTDATA, nHOGDATA, nHOFDATA, nMBHxDATA, nMBHyDATA) %data : N*D
kpospath ='./data/Kernel_pos/';
if ~exist(kpospath ,'dir')
    mkdir(kpospath );
end
knegpath ='./data/Kernel_neg/';
if ~exist(knegpath ,'dir')
    mkdir(knegpath );
end
kpimgpath ='./data/Kernel_pos_img/';
if ~exist(kpimgpath ,'dir')
    mkdir(kpimgpath );
end
knimgpath ='./data/Kernel_neg_img/';
if ~exist(knimgpath ,'dir')
    mkdir(knimgpath );
end

pKern1 =PW_paralleldists(pTDATA','CHI2'); 
pKern2 =PW_paralleldists(pHOGDATA','CHI2'); 
pKern3 =PW_paralleldists(pHOFDATA','CHI2'); 
pKern4 =PW_paralleldists(pMBHxDATA','CHI2'); 
pKern5 =PW_paralleldists(pMBHyDATA','CHI2'); 
pKern= ((((pKern1.*pKern2).*pKern3).*pKern4).*pKern5);
save([kpospath,num2str(class),'_pos.mat'],'pKern1','pKern2','pKern3','pKern4','pKern5','pKern');
nKern1 =PW_paralleldists(nTDATA','CHI2'); 
nKern2 =PW_paralleldists(nHOGDATA','CHI2'); 
nKern3 =PW_paralleldists(nHOFDATA','CHI2'); 
nKern4 =PW_paralleldists(nMBHxDATA','CHI2'); 
nKern5 =PW_paralleldists(nMBHyDATA','CHI2'); 
nKern= ((((nKern1.*nKern2).*nKern3).*nKern4).*nKern5);
save([knegpath,num2str(class),'_neg.mat'],'nKern1','nKern2','nKern3','nKern4','nKern5','nKern');
% load([kpospath,num2str(class),'_pos.mat']);%,'pKern1','pKern2','pKern3','pKern4','pKern5','pKern');
% load([knegpath,num2str(class),'_neg.mat']);%,'nKern1','nKern2','nKern3','nKern4','nKern5','nKern');
nVideos=50;
load('./data/KDE_ucf50_annotation.mat');%'ucf_annotation'
aidx =(class-1)*nVideos+1;
% load(['./data/Kernel/',num2str(class),'.mat']);%,'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');
h=figure; imshow(pKern,[]);
print(h,'-dpdf',[kpimgpath,ucf_annotation{aidx}.label,'_pos.pdf']);
close(h);
h=figure; imshow(nKern,[]);
print(h,'-dpdf',[knimgpath,ucf_annotation{aidx}.label,'_neg.pdf']);
close(h);
% total_nodes =  sum(nnodes);
% mask=ones(total_nodes,total_nodes);
% for v=1:nVideos
%     startidx = sum(nnodes(1:v-1))+1;
%     endidx = sum(nnodes(1:v));
%     mask(startidx:endidx,startidx:endidx) =0;
% end
% idx =1:total_nodes;
% kidx=idx(sumhists>=len);
% mask =mask(kidx,:);
% mask =mask(:,kidx);
% 
% Kern = Kern.*mask;
% density =sum(Kern); %1*N
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
function [maxitv1 maxitv2]= Find_best_pair_multi(Kern, mask,len,nodesize,class,nnodes)
% load('./test.mat');
% close all;
% len=75;
% nodesize=5;
Kern = Kern.*mask;
for i = 1:length(Kern)
    Kern(i,i:end)=0;
end
    
M=sum(Kern(:))/sum(mask(:));
Block = zeros(size(Kern));
Block(Kern>M) =1;

figure;
imshow(uint8(Block*255));
CC= bwconncomp(Block,4);

cnt=0;
th = (len/nodesize)*(len/nodesize);
N = length(Kern);
tmpimg = zeros(size(Kern));
max_val= 0;
max_idx= 0;
max_img=tmpimg;
Npix=0;
val=0;
vididx=zeros(2,1);
cumnnodes = cumsum(nnodes);
for i=1:CC.NumObjects
    idx = CC.PixelIdxList{i};
    Npix =length(idx);
    
    if Npix>th
        tmpimg = zeros(size(Kern));
        rows =rem(idx-1,N)+1;
        cols = ceil(idx/N);
        tmpimg(rows,cols)=1;
        tmpvididx =find((cumnnodes>=max(cols)));
        vididx(1) =tmpvididx(1);
        tmpvididx =find((cumnnodes>=max(rows)));
        vididx(2) =tmpvididx(1);
        
        tmpimg =Kern.*tmpimg;
%         val=sum(tmpimg(:))/Npix;
        %     figure;
        %     imshow(uint8(tmpimg*255));
%         fprintf('AVG %f\n',val);
        K = Kern(min(rows):max(rows), min(cols):max(cols)); %row -> second seq, col -> first seq
%         G=-ones(size(K));
        %     val2 =DTAK(size(K,1), size(K,2),K,G) / (size(K,1)+size(K,2));
        %         fprintf('DTAK %f\n\n',val2(end));
        [p,q,D]=dp(K);
        val = D(end)/(size(K,1)+size(K,2));
        
        itv1 = [q(1),q(end)]+min(cols)-sum(nnodes(1:vididx(1)-1));
        itv2 =[p(1), p(end)]+min(rows)-sum(nnodes(1:vididx(2)-1));

        
        %     fprintf('DTAK2 %f\n\n',D(end) / (size(K,1)+size(K,2)));
        if val>max_val
            max_idx = i;
            max_val= val;
            max_img = tmpimg;
            maxitv1 = itv1;
            maxitv2= itv2;
            maxvidx=vididx;
            
        end
    end
end
max_img(mask==0)=1;
figure;
imshow(uint8(max_img*255));
fprintf('seq %d : %d, %d \nseq %d : %d, %d\n', maxvidx(1),maxitv1(1)*nodesize,(maxitv1(2)+len/nodesize-1)*nodesize,maxvidx(2),maxitv2(1)*nodesize,(maxitv2(2)+len/nodesize-1)*nodesize);
function [itv1 itv2]= Find_best_pair_by_sort(Kern,class,vididx,nodesize,len)
Block=zeros(size(Kern));

[res idx]=sort(Kern(:),'descend');

nlabels=0;
[R C]=size(Kern);
N =length(Kern(:));
Labels= zeros(N,1);
Labels_per_points=zeros(N,1);
Points_per_label = zeros(N,N);
N_per_label= zeros(N,1);
blockidx = reshape(1:N, R,C);
newpoint = zeros(2,1);
figure;
imshow(Block);
hold on;
drawnow();
for z= 1:length(Kern(:))
    i=idx(z);
    Block(i)=255;
%     imshow(Block);
%     drawnow();
%     CC=bwconncomp(Block,8);
    newpoint(1)= rem(i-1,R)+1;
    newpoint(2)= ceil(i/R);
    if z==6 && vididx(2)==4
        fprintf('what?');
    end
    [nlabels,Labels,Labels_per_points, Points_per_label,N_per_label]=online_connectivity_check(nlabels,Labels,Labels_per_points, Points_per_label,N_per_label,newpoint,blockidx);
    fprintf('nlabels : %d  z : %d \n',nlabels,z);
    if nlabels==1 && z>=len
        fprintf('%d / %d\n',z,length(Kern(:)));
        imshow(Block);
        drawnow();
        ginput(1);
        break;
    end
end
itv1=0;
itv2=0;
% 
% 
% CC= bwconncomp(Block,4);
% 
% cnt=0;
% th = (len/nodesize)*(len/nodesize);
% N = length(Kern);
% tmpimg = zeros(size(Kern));
% max_val= 0;
% max_idx= 0;
% max_img=tmpimg;
% Npix=0;
% val=0;
% for i=1:CC.NumObjects
%     idx = CC.PixelIdxList{i};
%     Npix =length(idx);
%     
%     if Npix>th
%         tmpimg = zeros(size(Kern));
%         rows =rem(idx-1,N)+1;
%         cols = ceil(idx/N);
%         tmpimg(rows,cols)=1;
%         
%         tmpimg =Kern.*tmpimg;
% %         val=sum(tmpimg(:))/Npix;
%         %     figure;
%         %     imshow(uint8(tmpimg*255));
% %         fprintf('AVG %f\n',val);
%         K = Kern(min(rows):max(rows), min(cols):max(cols)); %row -> second seq, col -> first seq
% %         G=-ones(size(K));
%         %     val2 =DTAK(size(K,1), size(K,2),K,G) / (size(K,1)+size(K,2));
%         %         fprintf('DTAK %f\n\n',val2(end));
%         [p,q,D]=dp(K);
%         val = D(end)/(size(K,1)+size(K,2));
%         
%         itv1 = [q(1),q(end)]+min(cols);
%         itv2 =[p(1), p(end)]+min(rows)-sum(nnodes(1:vididx(2)-1));
% 
%         
%         %     fprintf('DTAK2 %f\n\n',D(end) / (size(K,1)+size(K,2)));
%         if val>max_val
%             max_idx = i;
%             max_val= val;
%             max_img = tmpimg;
%             maxitv1 = itv1;
%             maxitv2= itv2;
%         end
%     end
% end
% max_img(mask==0)=1;
% figure;
% imshow(uint8(max_img*255));
% fprintf('seq1 : %d, %d \nseq 2 : %d, %d\n', maxitv1(1)*nodesize,(maxitv1(2)+len/nodesize-1)*nodesize,maxitv2(1)*nodesize,(maxitv2(2)+len/nodesize-1)*nodesize);
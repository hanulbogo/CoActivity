% function x = PageRank(Kern, stds)
function x = PageRankTemp(Kern, tempKern)
p=1;%0.85;
% p=0.7;

n = length(Kern);
tol = 1e-15;
% G = Kern .* repmat(stds', 1, length(Kern));
G = Kern;
% ci =sum(G,2);
% ni =sum(mask,2);
% ci= ci./ni;
% sumc = sum(ci);
% 
% delta =(1-p)*ci/sumc;
% A = p*(G./repmat(sum(G),length(G),1))+repmat(delta,1,length(G));
WeightSumorg= sum(Kern);
Kern= Kern+tempKern.* repmat(WeightSumorg,[length(tempKern),1]);

delta =(1-p)/length(Kern);
A = p*(G./repmat(sum(G),length(G),1))+delta;
A(isnan(A))=0;
% A(isnan(A)) = 1/length(Kern);
% sigma = 0;%0.9;
% B = tempKern./(repmat(sum(tempKern),length(tempKern),1)+tol);
% B(isnan(B))=0;
% A =A*(1-sigma)+(B*sigma);

A = (A./repmat(sum(A),length(A),1));
%  imshow(A,[]);
x = ones(n,1)/n;

lastdiff=100;

while(1)
    newx = A*x;
%     cnt=cnt+1;
%     newx= newx/sum(newx);
%     fprintf('\ncnt %d maximum difference',cnt,max(abs(x-newx)));
    
    if max(abs(x-newx))<tol || lastdiff ==max(abs(x-newx)) 
        x=newx;
        break;
    end
    lastdiff =max(abs(x-newx));
    x=newx;
end
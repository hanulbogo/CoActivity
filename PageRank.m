% function x = PageRank(Kern, stds)
function x = PageRank(Kern)
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

delta =(1-p)/length(Kern);
A = p*(G./repmat(sum(G),length(G),1))+delta;

A(isnan(A)) = 1/length(Kern);
%  imshow(A,[]);
x = ones(n,1)/n;
cnt=0;
lastdiff=100;
while(1)
    newx = A*x;
    cnt=cnt+1;
%     newx= newx/sum(newx);
%     fprintf('\ncnt %d maximum difference',cnt,max(abs(x-newx)));
    
    if max(abs(x-newx))<tol || lastdiff ==max(abs(x-newx)) || cnt>100
        x=newx;
        break;
    end
    lastdiff =max(abs(x-newx));
    x=newx;
end
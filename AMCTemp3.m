function x = AMCTemp3(Kern,tempKern)
Wcon = Kern;
NumIn = length(Kern);
EdgSup= ones(NumIn,1);
tol = 1e-15;


global tempconst;

B = tempKern./(repmat(sum(tempKern,2),[1,length(tempKern)])+tol);

WeightSum = sum(Wcon,2);
Wcon = Wcon*(1-tempconst);
Wcon =Wcon+B.*repmat((WeightSum*tempconst),[1,length(tempKern)]);
% WeightSum2 = sum(Wcon,2);
AbsWcon= ones(NumIn,1);%1; %0.2


D = diag( WeightSum + AbsWcon);
Wcon =  D \ Wcon;
I = eye( NumIn );
N = ( I - Wcon);
x=N\EdgSup;

% A =(G./repmat(sum(G),length(G),1));
% 
% A(isnan(A)) = 1/NumIn;
% sigma = 0.9;
% B = tempKern./(repmat(sum(tempKern),length(tempKern),1)+tol);
% B(isnan(B))=0;
% A =A*(1-sigma)+(B*sigma);
% 
% A = (A./repmat(sum(A),length(A),1));
% %  imshow(A,[]);
% x = ones(n,1)/n;
% 
% lastdiff=100;
% 
% while(1)
%     newx = A*x;
% %     cnt=cnt+1;
% %     newx= newx/sum(newx);
% %     fprintf('\ncnt %d maximum difference',cnt,max(abs(x-newx)));
%     
%     if max(abs(x-newx))<tol || lastdiff ==max(abs(x-newx)) 
%         x=newx;
%         break;
%     end
%     lastdiff =max(abs(x-newx));
%     x=newx;
end
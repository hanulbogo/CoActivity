function [p,q,NormD,minscore] = dp_query_all_ends(M,len,nodesize)
% [p,q] = dp(M) 
%    Use dynamic programming to find a min-cost path through matrix M.
%    Return state sequence in p,q
% 2003-03-15 dpwe@ee.columbia.edu

% Copyright (c) 2003 Dan Ellis <dpwe@ee.columbia.edu>
% released under GPL - see file COPYRIGHT

[r,c] = size(M);

% costs
D = zeros(r+1, c+1);
D(1,:) = 0;
D(:,1) = NaN;
D(1,1) = 0;
D(2:(r+1), 2:(c+1)) = M;

% traceback
phi = zeros(r,c);
pl = zeros(r+1,c+1);
for i = 1:r; 
  for j = 1:c;
    [dmax, tb] = min([D(i, j), D(i, j+1), D(i+1, j)]);
    
    pb =[pl(i,j) pl(i,j+1),pl(i+1,j)];
    pmax =pb(tb);

    if tb==1
%             D(i+1,j+1) = D(i+1,j+1)+dmax;
            D(i+1,j+1) = D(i+1,j+1)+dmax;
            pl(i+1,j+1) = pmax+2;
    else 
%             D(i+1,j+1) = D(i+1,j+1)+dmax;
            D(i+1,j+1) = D(i+1,j+1)+dmax;
            pl(i+1,j+1) = pmax+1;
    end
    phi(i,j) = tb;
  end
end
longpref = 1.05;
pl(pl==0)=1;
NormD = D./(pl.^longpref);
clen = pl;
clen = clen - repmat([0:r]',1, c+1);
NormD(clen<len/nodesize) = inf;
NormD(isnan(NormD))=inf;
[minscore idx]= min(NormD(:));
j = floor(idx/(r+1))-1;
i = (rem(idx-1,(r+1))+1)-1;

p = i;
q = j;
while i > 1 && j > 1
  tb = phi(i,j);
  if (tb == 1)
    i = i-1;
    j = j-1;
  elseif (tb == 2)
    i = i-1;
  elseif (tb == 3)
    j = j-1;
  end
  p = [i,p];
  q = [j,q];
end

% Strip off the edges of the D matrix before returning
NormD = NormD(2:(r+1),2:(c+1));
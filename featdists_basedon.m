function dist=featdists_basedon(distorg,data,metric,nnodes)%data D*N

% LINF   max |X  - Y|
%    L2     sum (X  - Y).^2
%    L1     sum |X  - Y|
%    L0     sum (X ~= Y)
%    CHI2   sum (X  - Y).^2 ./ (X + Y)
%    HELL   sum (X^.5 - Y^.5) .^ 2

[D N]=size(data);
dist =zeros(N,N);
dist(1:sum(nnodes(1:10)),1:sum(nnodes(1:10))) = distorg(1:sum(nnodes(1:10)),1:sum(nnodes(1:10)));
nstart = sum(nnodes(1:10))+1;

if strcmp(metric,'CHI2')
    parfor  i=nstart:N
%         parfor  i=2:N
        dist(i,:) = PW_chi2(data,i);
        fprintf(' %d / %d \n',i,N);
    end
end
% matlabpool close;

for i=1:N
    for j=1:i-1
        dist(j,i)= dist(i,j);
    end
end


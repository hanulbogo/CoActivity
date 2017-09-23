function dist=Affinity_parallel(data,metric)%data D*N

% LINF   max |X  - Y|
%    L2     sum (X  - Y).^2
%    L1     sum |X  - Y|
%    L0     sum (X ~= Y)
%    CHI2   sum (X  - Y).^2 ./ (X + Y)
%    HELL   sum (X^.5 - Y^.5) .^ 2

[D N]=size(data);
dist =zeros(N,N);
if strcmp(metric,'CHI2')
    parfor  i=2:N
        dist(i,:) = PW_chi2(data,i);
        fprintf('%d / %d \n',i,N);
    end
end


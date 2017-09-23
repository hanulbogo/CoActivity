function [dist]=PW_paralleldists_two_videos(data,metric,class,idx)%data D*N

% LINF   max |X  - Y|
%    L2     sum (X  - Y).^2
%    L1     sum |X  - Y|
%    L0     sum (X ~= Y)
%    CHI2   sum (X  - Y).^2 ./ (X + Y)
%    HELL   sum (X^.5 - Y^.5) .^ 2
% 
[D N]=size(data);
dist =zeros(N,N);
if strcmp(metric,'CHI2')
    parfor  i=2:N
    %for i=2:N
        dist(i,:) = PW_chi2(data,i);
        %fprintf('%d / %d \n',i,N);
    end
end
% matlabpool close;

for i=1:N
    for j=1:i-1
        dist(j,i)= dist(i,j);
    end
end

%save([distpath,'dist_',num2str(class),'_',num2str(idx(1)),'_',num2str(idx(2)),'_one.mat'],'dist');

function dist=PW_paralleldists_multi_vid(data,metric)%data D*N

N=size(data,2);
dist =zeros(N,N);
if strcmp(metric,'CHI2')
    parfor  i=2:N
        dist(i,:) = PW_chi2(data,i);
    end
end

%% Symmeteric matrix
for i=1:N
    for j=1:i-1
        dist(j,i)= dist(i,j);
    end
end


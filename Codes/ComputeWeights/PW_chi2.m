function Distance =PW_chi2(data, i) %data1 D*1 data2 D*N
data1= data(:,i);
data2= data(:,1:i-1);
%    CHI2   sum (X  - Y).^2 ./ (X + Y)
%m1 =mean(data1);
%std1 = std(data1);
%M2 = mean(data2);
%STD2 = std(data2);
[D N]= size(data2);
%M1 =repmat(m1,1, N);
%STD1 = repmat(std1,1,N);

%LB=((M1-M2).^2+(STD1-STD2).^2);
% kern =exp(-LB/D*100);
%cand=exp(-LB/mean(LB))>0.8;

distance = -ones(1,N);
%data2= data2(:,cand);
data1= repmat(data1, 1, size(data2,2));
subd=(data1-data2).^2;
sumd= data1+data2;
subd((data1+data2)~=0) = subd((data1+data2)~=0) ./ sumd((data1+data2)~=0);
%distance(cand) = sum(subd);
distance = sum(subd);
Distance = -ones(1,size(data,2));
Distance(1:i-1) = distance;

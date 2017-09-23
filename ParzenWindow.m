function density=ParzenWindow(data) %data : N*D
% dist =vl_alldist2(data','CHI2');
Kern =exp(-(1/size(data,2))*vl_alldist2(data','CHI2')); %N*N to kernel feature must be normalized

density =sum(Kern); %1*N
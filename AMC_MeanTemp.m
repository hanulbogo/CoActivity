function x = AMC_MeanTemp(Kern,tempKern,mask)
global cumtime;
Wcon = Kern;
NumIn = length(Kern);
EdgSup= ones(NumIn,1);
tol =1e-15;

B=tempKern;
WeightSumorg= sum(Wcon,2);
MeanSum = WeightSumorg./(sum(mask,2));
Wcon = Wcon+B.* repmat(WeightSumorg,[1,length(tempKern)]);
% Wcon = Wcon+B.* repmat(10*normalize(MeanSum),[1,length(tempKern)]);

WeightSum = sum(Wcon,2);

AbsWcon= (max(MeanSum)*ones(NumIn,1)- MeanSum);
% AbsWcon= (max(WeightSumorg)*ones(NumIn,1)- WeightSumorg)/1000;
tic;
D = diag( WeightSum + AbsWcon);
Wcon =  D \ Wcon;
I = eye( NumIn );
N = ( I - Wcon);
x=N\EdgSup;
a=toc;
cumtime =a+cumtime;
function x = AMC_Mean(Kern,mask)
Wcon = Kern;
NumIn = length(Kern);
EdgSup= ones(NumIn,1);
tol =1e-15;


WeightSum = sum(Wcon,2);
MeanSum = WeightSum./sum(mask,2);

AbsWcon= (max(MeanSum)*ones(NumIn,1)- MeanSum);
% AbsWcon= (max(WeightSum)*ones(NumIn,1)- WeightSum)/1000;
%������� TemporalEdgƢ�����
%������«. Temporal Edge����
D = diag( WeightSum + AbsWcon);
Wcon =  D \ Wcon;
I = eye( NumIn );
N = ( I - Wcon);
x=N\EdgSup;

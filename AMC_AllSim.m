function x = AMC_AllSim(Kern)
Wcon = Kern;
NumIn = length(Kern);
EdgSup= ones(NumIn,1);
tol =1e-15;

WeightSum = sum(Wcon,2);

WMax = max(WeightSum);
% Wcon = Wcon+B;
% Wcon = Wcon+B.* repmat(WeightSum,[1,length(tempKern)]);
% Wcon = Wcon+B.* repmat(WMax,[1,length(tempKern)]);
% Wcon = Wcon+B.* repmat(min(WeightSum,1),[1,length(tempKern)]);
%  Wcon = B;
% Wcon = repmat(WeightSum,[1,length(tempKern)]);
% Wcon(tempKern==1) = 1;%tempconst*mean(WeightSum);

% WeightSum = sum(Wcon,2);
% AbsWcon= ones(NumIn,1);%1; %0.2
% AbsWcon= ones(NumIn,1)- normalize(MeanSum);%1; %0.2
AbsWcon= (WMax- WeightSum)/length(Kern);%1; %0.2
% AbsWcon= max(WeightSum)*ones(NumIn,1)- WeightSum;%1; %0.2

%여기부터 TemporalEdg튀어나오기
%아직안짬. Temporal Edge없음
D = diag( WeightSum + AbsWcon);
Wcon =  D \ Wcon;
I = eye( NumIn );
N = ( I - Wcon);
x=N\EdgSup;

function x = AMCTemp(Kern,tempKern)
Wcon = Kern;
NumIn = length(Kern);
EdgSup= ones(NumIn,1);
tol =1e-15;

% WeightSum = sum(Wcon,2);
% 
global tempconst;
% B = tempKern./(repmat(sum(tempKern,2),[1,length(tempKern)]))*2;
% B(isnan(B))=0;
% B2 = tempKern./(repmat(sum(tempKern,1),[length(tempKern),1]))*2;
% B2(isnan(B2))=0;
% B = zeros(size(B1));
% B(B1==2) =2;
% B(B2==2) =2;
% B(B1==1&B2==1) =1;

WeightSum = sum(Wcon,2);
% WMax = max(Wcon,[],2);
% Wcon = Wcon+B;
% Wcon = Wcon+B.* repmat(WeightSum,[1,length(tempKern)]);
% Wcon = Wcon+B.* repmat(WMax,[1,length(tempKern)]);
% Wcon = Wcon+B.* repmat(min(WeightSum,1),[1,length(tempKern)]);
%  Wcon = B;
Wcon = repmat(WeightSum,[1,length(tempKern)]);
% Wcon(tempKern==1) = 1;%tempconst*mean(WeightSum);

WeightSum = sum(Wcon,2);

AbsWcon= ones(NumIn,1)*1;%1; %0.2

%여기부터 TemporalEdg튀어나오기
%아직안짬. Temporal Edge없음
D = diag( WeightSum + AbsWcon);
Wcon =  D \ Wcon;
I = eye( NumIn );
N = ( I - Wcon);
x=N\EdgSup;

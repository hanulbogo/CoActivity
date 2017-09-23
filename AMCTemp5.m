function x = AMCTemp5(Kern,tempKern)
Wcon = Kern;
NumIn = length(Kern);
EdgSup= ones(NumIn,1);
tol = 1e-15;


global tempconst;

B = tempKern./(repmat(sum(tempKern,2),[1,length(tempKern)])+tol);

% WeightSum = sum(Wcon,2);
Wcon =Wcon+B;%.*repmat((WeightSum*tempconst),[1,length(tempKern)]);
WeightSum = sum(Wcon,2);
% WeightSum2 = sum(Wcon,2);
AbsWcon= ones(NumIn,1);%1; %0.2


D = diag( WeightSum + AbsWcon);
Wcon =  D \ Wcon;
I = eye( NumIn );
N = ( I - Wcon);
x=N\EdgSup;

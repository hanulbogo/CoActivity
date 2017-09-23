function density=TH_N_AMC(Kern,mask,len,nodesize,nData,nnodes,Comb) %data : N*D

load('./data/TH_annotation.mat');%'TH_annotation'

step =len/nodesize;
%% Temporal Mask
tempKern = zeros(size(mask));

for i=1:length(Kern)
        tempKern(i,max(1,i-step*1):min(i+step*1,length(Kern)) )=1;
end
tempKern=tempKern(1:length(Kern),1:length(Kern));
tempKern= tempKern+tempKern';
tempKern=tempKern.*(1-mask);
tempKern(tempKern>=1)=1;
% PageRank()
%  x = AMCTemp(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5));
%  x = AMC_Mean(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5),mask(nData>=len*.5,nData>=len*.5));
 x = AMC_MeanTemp(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5),mask(nData>=len*.5,nData>=len*.5));
%  x = AMC(Kern(nData>=len*.5,nData>=len*.5));
 x= normalize(x);
 density = zeros(size(nData));
 density(nData>=len*.5) = x;
 density(nData<len*0.5) =0;
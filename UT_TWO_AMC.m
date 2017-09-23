function density=UT_TWO_AMC(Kern,mask,len,nodesize,nData,nnodes,Comb) %data : N*D

load('./data/UT_annotation.mat');%'UT_annotation'

startidx = [0;0];
endidx =[0;0];

startidx(1) = sum(nnodes(1:Comb(1)-1))+1;
endidx(1) = startidx(1) -1 + nnodes(Comb(1));

startidx(2) = sum(nnodes(1:Comb(2)-1))+1;
endidx(2) = startidx(2) -1 + nnodes(Comb(2));

Kern =Kern([startidx(1):endidx(1), startidx(2):endidx(2)], [startidx(1):endidx(1), startidx(2):endidx(2)]);
mask = mask([startidx(1):endidx(1), startidx(2):endidx(2)], [startidx(1):endidx(1), startidx(2):endidx(2)]);
nData = nData([startidx(1):endidx(1), startidx(2):endidx(2)]);

step =len/nodesize;
%% Temporal Mask
tempKern = zeros(size(mask));
for i=1:length(Kern)
    if i> step && i<length(Kern)-step
        tempKern(i,[max(1,i-step*1):i-step*1,i+step*1:min(i+step*1,length(Kern)) ])=1;
    elseif i<=step
        tempKern(i,i+step*1:i+step*1)=1;
    else
        tempKern(i,i-step*1:i-step)=1;
    end
end

tempKern=tempKern(1:length(Kern),1:length(Kern));
tempKern= tempKern+tempKern';
tempKern=tempKern.*(1-mask);
tempKern(tempKern>=1)=1;
stk =sum(tempKern,2);
stklist =find((stk==1));
for ss = 1:length(stklist)
    tempKern(stklist(ss),stklist(ss))=1;
end
%  x = AMCTemp(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5));
%  x = AMC_Mean(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5),mask(nData>=len*.5,nData>=len*.5));
 x = AMC_MeanTemp(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5),mask(nData>=len*.5,nData>=len*.5));
%  x = AMC(Kern(nData>=len*.5,nData>=len*.5));
 x= normalize(x);
 density = zeros(size(nData));
 density(nData>=len*.5) = x;
 density(nData<len*0.5) =0;
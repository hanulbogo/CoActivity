function density=HW_N_AMC(Kern,mask,len,nodesize,nData,mname) %data : N*D

load('./data/HW_annotation.mat');%'HW_annotation'

% startidx = zeros(length(Comb),1);
% endidx = zeros(length(Comb),1);

step =len/nodesize;
%% Temporal Mask
tempKern = zeros(size(mask));
% for i=1:length(Kern)
%     if i> step && i<length(Kern)-step
%         tempKern(i,[max(1,i-step*1):i-step*1,i+step*1:min(i+step*1,length(Kern)) ])=1;
%     elseif i<=step
%         tempKern(i,i+step*1:i+step*1)=1;
%     else
%         tempKern(i,i-step*1:i-step)=1;
%     end
% end

for i=1:length(Kern)
%     if i> step && i<length(Kern)-step
        tempKern(i,max(1,i-step*1):min(i+step*1,length(Kern)) )=1;
%     elseif i<=step
%         tempKern(i,i:i+step*1)=1;
%     else
%         tempKern(i,i-step*1:i-step)=1;
%     end
end
tempKern=tempKern(1:length(Kern),1:length(Kern));
tempKern= tempKern+tempKern';
tempKern=tempKern.*(1-mask);
tempKern(tempKern>=1)=1;
% stk =sum(tempKern,2);
% stklist =find((stk==1));
% for ss = 1:length(stklist)
%     tempKern(stklist(ss),stklist(ss))=1;
% end
if strcmp(mname,'AMC-')
    x = AMC_Mean(Kern(nData>=len*.5,nData>=len*.5),mask(nData>=len*.5,nData>=len*.5));
elseif strcmp(mname,'AMC');    
    x = AMC_MeanTemp(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5),mask(nData>=len*.5,nData>=len*.5));
elseif strcmp(mname,'PR');    
    x= PageRankTemp(Kern(nData>=len*.5,nData>=len*.5),tempKern(nData>=len*.5,nData>=len*.5));
end
 x= normalize(x);
 density = zeros(size(nData));
 density(nData>=len*.5) = x;
 density(nData<len*0.5) =0;
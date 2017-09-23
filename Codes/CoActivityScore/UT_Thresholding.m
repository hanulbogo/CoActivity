function dth =UT_Thresholding(density_map,nVideos, class)

global dpath;
load([dpath ,'UT_nVideos.mat']);%nVideolist
load([dpath ,'UT_annotation.mat']);

pos_frames= cell(nVideos, 1);
neg_frames = cell(nVideos,1);

dth = zeros(1,nVideos);
GMModel = cell(nVideos,1);
lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;

PFpath = [dpath ,'UT_POS_Frames/'];
if ~exist(PFpath,'dir')
    mkdir(PFpath);
end
PFcpath = [PFpath lname '/'];
if ~exist(PFcpath,'dir')
    mkdir(PFcpath);
end


for v=1:nVideos
    frames = 1: length(density_map{v});
    idx =ones(length(density_map{v}),1);
    inith= mean(density_map{v});
    idx(density_map{v}<=inith)=2;
    option.MaxIter=10000;
    
    S.mu = [max(density_map{v}(idx==1)); max(density_map{v}(idx==2))];
    S.Sigma =zeros(1,1,2);
    S.Sigma(1,1,1) = var(density_map{v}(idx==1));
    S.Sigma(1,1,2) = var(density_map{v}(idx==2));
    nidx1 =length(find(idx==1));
    nidx2 =length(find(idx==2));
    
    S.ComponentProportion = [nidx1/(nidx1+nidx2),nidx2/(nidx1+nidx2)];
    GMModel{v} = fitgmdist(density_map{v}',2,'RegularizationValue',1e-3,'Options',option,'Start',S);
    
    
    idx = cluster(GMModel{v},density_map{v}');
    m1 =mean(density_map{v}(idx==1));
    m2 =mean(density_map{v}(idx==2));
    if isempty(find(idx==1,1)) ||isempty(find(idx==1,1))
        idx =ones(length(density_map{v}),1);
        inith= mean(density_map{v});
        idx(density_map{v}<=inith)=2;
        pos_frames{v} = frames(idx==1);
        neg_frames{v} = frames(idx==2);
        dth(v) = inith;
    else
        if m1>m2
            pos_frames{v} = frames(idx==1);
            neg_frames{v} = frames(idx==2);
            dth(v) = max(density_map{v}(idx==2));
        else
            pos_frames{v} = frames(idx==2);
            neg_frames{v} = frames(idx==1);
            dth(v) = max(density_map{v}(idx==1));
        end
        
    end
end


gt_start= cell(nVideos,1);
gt_end= cell(nVideos,1);
gt_cen= cell(nVideos,1);
v_start= zeros(nVideos,1);
v_end= zeros(nVideos,1);

precisiondenom=0;
recalldenom =0;
precisiondenom2=0;
recalldenom2 =0;
tp=0;
tp2=0;
for v=1:nVideos
    aidx =sum(nVideolist(1:(class-1)))+v;
    
    v_start(v)=1;
    v_end(v)= sum(UT_annotation{aidx}.nFrames);
    
    
    gt_start{v} = UT_annotation{aidx}.gt_start;
    gt_end{v}= UT_annotation{aidx}.gt_end;
    
    tmp =zeros(v_end(v),1);
    
    gt_cen{v} = (gt_start{v}+gt_end{v})/2;
    for gg= 1: length(gt_start{v})
        tmp(gt_start{v}(gg):gt_end{v}(gg))=1;
    end
    tmp2=zeros(v_end(v),1);
    pos_frames{v}=pos_frames{v}(pos_frames{v}<v_end(v));
    tmp2(pos_frames{v})=1;
    tp = tp+sum((tmp.*tmp2));
    precisiondenom =precisiondenom +sum(tmp2);
    recalldenom = recalldenom+sum(tmp);
    
    tmp2=zeros(v_end(v),1);
    neg_frames{v}=neg_frames{v}(neg_frames{v}<v_end(v));
    tmp2(neg_frames{v})=1;
    tp2 = tp2+sum((tmp.*tmp2));
    precisiondenom2 =precisiondenom2 +sum(tmp2);
    recalldenom2 = recalldenom2+sum(tmp);
end
precision = tp/precisiondenom;
recall= tp/recalldenom;

precision2 = tp2/precisiondenom2;
recall2= tp2/recalldenom2;

fmeasure = (1+1^2)*(precision*recall)/((1^2)*precision+recall);
fmeasure2=-1;
if fmeasure>fmeasure2
    fprintf(' %.2f  %.2f  %.2f ',precision, recall,fmeasure);
else
    fprintf(' %.2f  %.2f  %.2f ',precision2, recall2,fmeasure2);
end

global mname;
save([PFcpath, mname '.mat'],'pos_frames','density_map');

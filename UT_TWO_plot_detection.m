function [precision ,recall,fmeasure,dth] =UT_TWO_plot_detection(density_map, class,Comb)
load('./data/UT_nVideos.mat');%nVideolist
nVideos = nVideolist(class);
load('./data/UT_annotation.mat');
pos_frames= cell(2, 1);
neg_frames = cell(2,1);

dth = zeros(1,length(Comb));
for v=1:length(Comb)
    dth(v)= mean(density_map{v})/1;
end

for v=1:length(Comb)
    frames = 1: length(density_map{v});
    pos_frames{v} = frames(density_map{v}>dth(v));
    neg_frames{v} =frames(density_map{v}<=dth(v));
end

gt_start= cell(length(Comb),1);
gt_end= cell(length(Comb),1);
gt_cen= cell(length(Comb),1);
v_start= zeros(length(Comb),1);
v_end= zeros(length(Comb),1);

precisiondenorm=0;
recalldenorm =0;

tp=0;

for v=1:length(Comb)
    cc= Comb(v);
    aidx =sum(nVideolist(1:(class-1)))+cc;
    
    v_start(v)=1;
    v_end(v)= sum(UT_annotation{aidx}.nFrames);
    tmp =zeros(v_end(v),1);
    gt_start{v} = UT_annotation{aidx}.gt_start;
    gt_end{v}= UT_annotation{aidx}.gt_end;
    
    gt_cen{v} = (gt_start{v}+gt_end{v})/2;
    for gg= 1: length(gt_start{v})
        tmp(gt_start{v}(gg):gt_end{v}(gg))=1;
    end
    
  
%     tmp(gt_start(v,1):gt_end(v,1))=1;
    tmp2=zeros(v_end(v),1);
    pos_frames{v}=pos_frames{v}(pos_frames{v}<v_end(v));
    tmp2(pos_frames{v})=1;
    tp = tp+sum((tmp.*tmp2));
    precisiondenorm =precisiondenorm +sum(tmp2);
    recalldenorm = recalldenorm+sum(tmp);
    
end
precision = tp/precisiondenorm;
recall= tp/recalldenorm;

fmeasure = (1+1^2)*(precision*recall)/((1^2)*precision+recall+1e-15);
% fprintf(' %d %d %.2f  %.2f  %.2f\n ',Comb(1), Comb(2),precision, recall,fmeasure);

v_cen = (v_start+v_end)/2;

h=figure(1);
lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
title([lname ':' sprintf('%.2f',fmeasure)]);
axis([0,length(Comb)+2,0, max(length(density_map{1}), length(density_map{2}))]);
hold on;
errorbar(Comb, v_cen,v_cen-v_start,v_end-v_cen,'k.');

for v= 1: length(Comb)  
    for gg= 1: length(gt_start{v})
        errorbar(Comb(v),gt_cen{v}(gg),gt_cen{v}(gg)-gt_start{v}(gg),gt_end{v}(gg)-gt_cen{v}(gg),'b.','LineWidth',2);
    end
    plot(Comb(v)+0.5, pos_frames{v},'r.');
end

hold off;
drawnow();
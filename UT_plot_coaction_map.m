function UT_plot_coaction_map(rpath,nVideos, class,nodesize,Dim)
load('./data/UT_annotation.mat');%'UT_annotation'
% dpath ='./data/UT_density_map/';
pdfpath ='./data/UT_density_img/';
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end

load([rpath,'co_action_result_',num2str(class),'_nodesize_',num2str(nodesize),'_Dim_',num2str(Dim),'_org.mat']);%'pos_frames','neg_frames');

gt_start= zeros(nVideos,1);
gt_end= zeros(nVideos,1);
v_start= zeros(nVideos,1);
v_end= zeros(nVideos,1);
sumco =0;
sumuni=0;
sumco2 =0;
sumuni2=0;

precisiondenorm=0;
recalldenorm =0;
precisiondenorm2=0;
recalldenorm2 =0;
tp=0;
tp2=0;
for v=1:nVideos
    aidx =(class-1)*nVideos+v;
    
    v_start(v)=1;
    v_end(v)= sum(UT_annotation{aidx}.nFrames);
    
    gt_start(v,1) = UT_annotation{aidx}.gt_start(1);
    gt_end(v,1)= UT_annotation{aidx}.gt_end(1);
     
    tmp =zeros(v_end(v),1);
    tmp(gt_start(v,1):gt_end(v,1))=1;
    tmp2=zeros(v_end(v),1);
    pos_frames{v}=pos_frames{v}(pos_frames{v}<v_end(v));
    tmp2(pos_frames{v})=1;
    tp = tp+sum((tmp.*tmp2));
    precisiondenorm =precisiondenorm +sum(tmp2);
    recalldenorm = recalldenorm+sum(tmp);
    
    tmp2=zeros(v_end(v),1);
    neg_frames{v}=neg_frames{v}(neg_frames{v}<v_end(v));
    tmp2(neg_frames{v})=1;
    tp2 = tp2+sum((tmp.*tmp2));
    precisiondenorm2 =precisiondenorm2 +sum(tmp2);
    recalldenorm2 = recalldenorm2+sum(tmp);
      
    uni_v = ones(1, v_end(v));
    uni_v(neg_frames{v})=0;
    uni_v(gt_start(v,1):gt_end(v,1))=1;
    co_v = zeros(1,v_end(v));
    co_v(pos_frames{v})=1;
    co_v(gt_start(v,1):gt_end(v,1)) = co_v(gt_start(v,1):gt_end(v,1))+1;
    co_v(co_v<2)=0;
    co_v(co_v>0)=1;
    sumco =sumco+sum(co_v);
    sumuni = sumuni+sum(uni_v);
    
    uni_v = ones(1, v_end(v));
    uni_v(pos_frames{v})=0;
    uni_v(gt_start(v,1):gt_end(v,1))=1;
    co_v = zeros(1,v_end(v));
    co_v(neg_frames{v})=1;
    co_v(gt_start(v,1):gt_end(v,1)) = co_v(gt_start(v,1):gt_end(v,1))+1;
    co_v(co_v<2)=0;
    co_v(co_v>0)=1;
    sumco2 =sumco2+sum(co_v);
    sumuni2 = sumuni2+sum(uni_v);
end
precision = tp/precisiondenorm;
recall= tp/recalldenorm;

precision2 = tp2/precisiondenorm2;
recall2= tp2/recalldenorm2;

fmeasure = (1+0.3^2)*(precision*recall)/((0.3^2)*precision+recall);
fmeasure2 = (1+0.3^2)*(precision2*recall2)/((0.3^2)*precision2+recall2);
fprintf('fmeasure %.2f\n',max(fmeasure,fmeasure2));

gt_cen = (gt_start+gt_end)/2;
v_cen = (v_start+v_end)/2;
h=figure(1);
lname =UT_annotation{(class-1)*nVideos+1}.label;
acc=sumco/sumuni;
acc2=sumco2/sumuni2;
% fprintf('acc : %.2f\n',max(acc,acc2));
title([lname ':' sprintf('%.2f',max(acc,acc2));]);
hold on;
% errorbar((1:nVideos), v_cen,v_cen-v_start,v_end-v_cen,'k.');
% errorbar((1:nVideos), gt_cen(:,1),gt_cen(:,1)-gt_start(:,1),gt_end(:,1)-gt_cen(:,1),'b.','LineWidth',2);
for v= (1: nVideos)
    
    
    %   if size(pos_frames{v},2)>0
    %       plot(v+ pos_score{v},pos_frames{v},'g.');
    if fmeasure>fmeasure2
        if ~isempty(pos_frames{v})
            plot(v-0.25, pos_frames{v},'.','Color',[0 0.7 0],'MarkerSize',4);
        end
    else
        if ~isempty(neg_frames{v})
            plot(v- 0.25,neg_frames{v},'.','Color',[0 0.7 0],'MarkerSize',4);
        end
    end
%   end
%   if size(neg_frames{v},2)>0
%     plot(v+ neg_score{v},neg_frames{v},'g.');
%   end
end

hold off;
print(h,'-dpdf',['./data/UT_density_img/',lname,'.pdf']);
% %     close(h);


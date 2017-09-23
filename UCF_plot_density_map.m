function dth=UCF_plot_density_map(density_map,nVideos, class)
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'

% dpath ='./data/UCF_density_map/';
pdfpath ='./data/UCF_density_img/';
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end
pos_frames= cell(nVideos, 1);
neg_frames = cell(nVideos,1);

dth = zeros(1,nVideos);
GMModel = cell(nVideos,1);
lname =ucf_annotation{(class-1)*nVideos+1}.label;
PFpath = './data/UCF_ALL_POS_Frames/';
if ~exist(PFpath,'dir')
    mkdir(PFpath);
end
PFcpath = [PFpath lname '/'];
if ~exist(PFcpath,'dir')
    mkdir(PFcpath);
end
% figure(10);
for v=1:nVideos
      frames = 1: length(density_map{v});
    idx =ones(length(density_map{v}),1);
    inith= mean(density_map{v});
    idx(density_map{v}<=inith)=2;
    option.MaxIter=10000;
    %     mm(2) =mean(density_map{v}(density_map{v}>inith));
    %     try
    %         flag =2;
    S.mu = [max(density_map{v}(idx==1)); max(density_map{v}(idx==2))];
    S.Sigma =zeros(1,1,2);
    S.Sigma(1,1,1) = var(density_map{v}(idx==1));
    S.Sigma(1,1,2) = var(density_map{v}(idx==2));
    nidx1 =length(find(idx==1));
    nidx2 =length(find(idx==2));
        S.ComponentProportion = [nidx1/(nidx1+nidx2),nidx2/(nidx1+nidx2)];%일부러이렇게 함. 이거더잘되네...ㅜㅜ
    %     GMModel{v} = fitgmdist(density_map{v}',2,'RegularizationValue',1e-3,'Options',option,'Start',idx);
    GMModel{v} = fitgmdist(density_map{v}',2,'RegularizationValue',1e-3,'Options',option,'Start',S);
    
    flag=1;
    %     catch
    
    %     end
    %     flag=2;
    if flag==1
        %         P = posterior(GMModel{v},density_map{v}');
        %         figure(1);
        %         bar(P(:,1)-P(:,2));
        
        idx = cluster(GMModel{v},density_map{v}');
        m1 =mean(density_map{v}(idx==1));
        m2 =mean(density_map{v}(idx==2));
        if isempty(find(idx==1,1)) ||isempty(find(idx==1,1))
            idx =ones(length(density_map{v}),1);
            inith= mean(density_map{v});
            idx(density_map{v}<=inith)=2;
            pos_frames{v} = frames(idx==1);
            neg_frames{v} = frames(idx==2);
            dth(v) = inith;%max(density_map{v}(idx==2));
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
        %        fprintf('init th %f mu1 %f, mu2 %f new th %f \n',inith, GMModel{v}.mu(1), GMModel{v}.mu(2), dth(v));
    else
        pos_frames{v} = frames(idx==1);
        neg_frames{v} = frames(idx==2);
%         dth(v) = inith;%max(density_map{v}(idx==2));
        %         fprintf('init th %f mu1 %f, mu2 %f new th %f \n',inith, GMModel{v}.mu(1), GMModel{v}.mu(2), dth(v));
    end
end

for v=1:nVideos
    frames = 1: length(density_map{v});
    pos_frames{v} = frames(density_map{v}>dth(v));
    neg_frames{v} =frames(density_map{v}<=dth(v));
end

gt_start= zeros(nVideos,2);
gt_end= zeros(nVideos,2);
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
    v_end(v)= sum(ucf_annotation{aidx}.nFrames);
    
 
    gt_start(v,1) = ucf_annotation{aidx}.gt_start(1);
    gt_end(v,1)= ucf_annotation{aidx}.gt_end(1);
    gt_start(v,2) = ucf_annotation{aidx}.gt_start(2);
    gt_end(v,2)= ucf_annotation{aidx}.gt_end(2);
         
    tmp =zeros(v_end(v),1);
    tmp(gt_start(v,1):gt_end(v,1))=1;
    tmp(gt_start(v,2):gt_end(v,2))=1;
    
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
end
precision = tp/precisiondenorm;
recall= tp/recalldenorm;

precision2 = tp2/precisiondenorm2;
recall2= tp2/recalldenorm2;

fmeasure = (1+1^2)*(precision*recall)/((1^2)*precision+recall);
fmeasure2=-1;
if fmeasure>fmeasure2
    fprintf(' %.2f  %.2f  %.2f ',precision, recall,fmeasure);
else 
    fprintf(' %.2f  %.2f  %.2f ',precision2, recall2,fmeasure2);
end

global mname;
save([PFcpath, mname '.mat'],'pos_frames');


% v_cen= (v_start+v_end)/2;
% gt_cen =(gt_start+gt_end)/2;
% h=figure;
% lname =ucf_annotation{nVideos*(class-1)+1}.label;
% title([lname ':' sprintf('%.2f',max(fmeasure,fmeasure2));]);
% hold on;
% errorbar((1:nVideos), v_cen,v_cen-v_start,v_end-v_cen,'k.');
% 
% % save([PFcpath,'AMC-.mat'],'pos_frames');
% % save([PFcpath,'PR.mat'],'pos_frames');
% 
% 
% for v= (1: nVideos)
%     for gg= 1: length(gt_start(v,:))
%         errorbar(v,gt_cen(v,gg),gt_cen(v,gg)-gt_start(v,gg),gt_end(v,gg)-gt_cen(v,gg),'b.','LineWidth',2);
%     end
%     if fmeasure>fmeasure2
%         if ~isempty(pos_frames{v})
%             plot(v+0.5, pos_frames{v},'r.');
%         end
%     else
%         if ~isempty(neg_frames{v})
%             plot(v+ 0.5,neg_frames{v},'r.');
%         end
%     end
% 
% end

% hold off;
% drawnow();
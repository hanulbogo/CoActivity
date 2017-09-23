function dth =HW_plot_denstiy_map(density_map,nVideos, class)
% if ~exist(pdfpath,'dir')
%     mkdir(pdfpath);
% end
load('./data/HW_nVideos.mat');%nVideolist

% sum(nVideolist(1:(class-1)))
load('./data/HW_annotation.mat');
pos_frames= cell(nVideos, 1);
neg_frames = cell(nVideos,1);

dth = zeros(1,nVideos);
GMModel = cell(nVideos,1);
 lname =HW_annotation{sum(nVideolist(1:(class-1)))+1}.label;
PFpath = './data/HW_ALL_POS_Frames/';
if ~exist(PFpath,'dir')
    mkdir(PFpath);
end
PFcpath = [PFpath lname '/'];
if ~exist(PFcpath,'dir')
    mkdir(PFcpath);
end
% figure(10);
% tic;
for v=1:nVideos
    frames = 1: length(density_map{v});
    idx =ones(length(density_map{v}),1);
    inith= mean(density_map{v});
    idx(density_map{v}<=inith)=2;
    option.MaxIter=10000;
%     mm(2) =mean(density_map{v}(density_map{v}>inith));
%     try
%         flag =2;
        S.mu = [max(density_map{v}(idx==2)); max(density_map{v}(idx==1))];
        S.Sigma =zeros(1,1,2);
        S.Sigma(1,1,1) = var(density_map{v}(idx==2))+eps;
        S.Sigma(1,1,2) = var(density_map{v}(idx==1))+eps;
        nidx1 =length(find(idx==1));
        nidx2 =length(find(idx==2));
        
        S.ComponentProportion = [nidx1/(nidx1+nidx2),nidx2/(nidx1+nidx2)];
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
        if m1>m2
            pos_frames{v} = frames(idx==1);
            neg_frames{v} = frames(idx==2);
            dth(v) = max(density_map{v}(idx==2));
        else
            idx =ones(length(density_map{v}),1);
            inith= mean(density_map{v});
            idx(density_map{v}<=inith)=2;
            pos_frames{v} = frames(idx==1);
            neg_frames{v} = frames(idx==2);
            dth(v) = inith;%max(density_map{v}(idx==2));
        end
%        fprintf('init th %f mu1 %f, mu2 %f new th %f \n',inith, GMModel{v}.mu(1), GMModel{v}.mu(2), dth(v));
    else
        pos_frames{v} = frames(idx==1);
        neg_frames{v} = frames(idx==2);
        dth(v) = inith;%max(density_map{v}(idx==2));
%         fprintf('init th %f mu1 %f, mu2 %f new th %f \n',inith, GMModel{v}.mu(1), GMModel{v}.mu(2), dth(v));
    end
end
% toc;

% for v=1:nVideos
%     frames = 1: length(density_map{v});
%     pos_frames{v} = frames(density_map{v}>dth(v));
%     neg_frames{v} =frames(density_map{v}<=dth(v));
% end
% load([rpath,'co_action_result_',num2str(class),'_nodesize_',num2str(nodesize),'_Dim_',num2str(Dim),'_org.mat']);%'pos_frames','neg_frames');

gt_start= cell(nVideos,1);
gt_end= cell(nVideos,1);
gt_cen= cell(nVideos,1);
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
    
        aidx =sum(nVideolist(1:(class-1)))+v;
    
    v_start(v)=1;
    v_end(v)= sum(HW_annotation{aidx}.nFrames);
    
 
    gt_start{v} = HW_annotation{aidx}.gt_start;
    gt_end{v}= HW_annotation{aidx}.gt_end;
    if gt_end{v}>v_end(v)
        gt_end{v}=v_end(v);
    end
    
    tmp =zeros(v_end(v),1);
    
    gt_cen{v} = (gt_start{v}+gt_end{v})/2;
    for gg= 1: length(gt_start{v})
        tmp(gt_start{v}(gg):gt_end{v}(gg))=1;
    end
    tmp2=zeros(v_end(v),1);
    pos_frames{v}=pos_frames{v}(pos_frames{v}<v_end(v));
    tmp2(pos_frames{v})=1;
    tp = tp+sum((tmp.*tmp2));
    precisiondenorm =precisiondenorm +sum(tmp2);
    recalldenorm = recalldenorm+sum(tmp);
end
precision = tp/precisiondenorm;
recall= tp/recalldenorm;


fmeasure = (1+1^2)*(precision*recall)/((1^2)*precision+recall);
    fprintf(' %.2f  %.2f  %.2f ',precision, recall,fmeasure);
global mname;
save([PFcpath,mname '.mat'],'pos_frames');

% 
% gt_cen = (gt_start+gt_end)/2;
% v_cen = (v_start+v_end)/2;
% h=figure;
% lname =HW_annotation{sum(nVideolist(1:(class-1)))+1}.label;
% title([lname ':' sprintf('%.2f',max(fmeasure,fmeasure2));]);
% hold on;
% errorbar((1:nVideos), v_cen,v_cen-v_start,v_end-v_cen,'k.');

% 
% for v= (1: nVideos)
%     for gg= 1: length(gt_start{v})
%         errorbar(v,gt_cen{v}(gg),gt_cen{v}(gg)-gt_start{v}(gg),gt_end{v}(gg)-gt_cen{v}(gg),'b.','LineWidth',2);
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
% % 
% hold off;
% drawnow();
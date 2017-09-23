function [precision ,recall,fmeasure,dth] =UT_N_plot_detection(density_map, class,Comb)
load('./data/UT_nVideos.mat');%nVideolist
nVideos = nVideolist(class);
load('./data/UT_annotation.mat');
pos_frames= cell(length(Comb), 1);
neg_frames = cell(length(Comb),1);

lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
PFpath ='./data/UT_TWO_POS_Frames/';
if ~exist(PFpath,'dir')
    mkdir(PFpath);
end
PFcpath = [PFpath lname '/'];
if ~exist(PFcpath,'dir')
    mkdir(PFcpath);
end
% dth = zeros(1,length(Comb));
% for v=1:length(Comb)
%     dth(v)= mean(density_map{v})/1;
% end
% 
% for v=1:length(Comb)
%     frames = 1: length(density_map{v});
%     pos_frames{v} = frames(density_map{v}>dth(v));
%     neg_frames{v} =frames(density_map{v}<=dth(v));
% end


dth = zeros(1,length(Comb));
GMModel = cell(length(Comb),1);

for v=1:length(Comb)
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
        if m1>m2
            pos_frames{v} = frames(idx==1);
            neg_frames{v} = frames(idx==2);
%             dth(v) = max(density_map{v}(idx==2));
        else
            pos_frames{v} = frames(idx==2);
            neg_frames{v} = frames(idx==1);
%             dth(v) = max(density_map{v}(idx==1));
        end
        %        fprintf('init th %f mu1 %f, mu2 %f new th %f \n',inith, GMModel{v}.mu(1), GMModel{v}.mu(2), dth(v));
    else
        pos_frames{v} = frames(idx==1);
        neg_frames{v} = frames(idx==2);
%         dth(v) = inith;%max(density_map{v}(idx==2));
        %         fprintf('init th %f mu1 %f, mu2 %f new th %f \n',inith, GMModel{v}.mu(1), GMModel{v}.mu(2), dth(v));
    end
end
global mname;
save([PFcpath,mname,'_' ,num2str(Comb(1)), '_',num2str(Comb(2)),'.mat'],'pos_frames');
gt_start= cell(length(Comb),1);
gt_end= cell(length(Comb),1);
gt_cen= cell(length(Comb),1);
v_start= zeros(length(Comb),1);
v_end= zeros(length(Comb),1);

precisiondenorm=0;
recalldenorm =0;

tp=0;
maxlen=0;
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
    
    if maxlen<length(density_map{v})
        maxlen =length(density_map{v});
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
% fprintf('%.2f  %.2f  %.2f\n',precision, recall,fmeasure);

% v_cen = (v_start+v_end)/2;

% 
% h = figure(1);
% clf;
% set(h, 'Position', [50, 50, 600, 200]);
% 



% h=figure(1);
% lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
% title([lname ':' sprintf('%.2f',fmeasure)]);
% axis([0,max(Comb)+2,0,maxlen *1.2]);
% hold on;
% errorbar(Comb, v_cen,v_cen-v_start,v_end-v_cen,'k.');
% 
% for v= 1: length(Comb)  
%     for gg= 1: length(gt_start{v})
%         errorbar(Comb(v),gt_cen{v}(gg),gt_cen{v}(gg)-gt_start{v}(gg),gt_end{v}(gg)-gt_cen{v}(gg),'b.','LineWidth',2);
%     end
%     plot(Comb(v)+0.5, pos_frames{v},'r.');
% end
% 
% hold off;
% drawnow();

% print(h,'-dpdf',['./data/UT_Res_img/',lname,'_',num2str(Comb(1)), num2str(Comb(2)) '.pdf']);
% print(h,'-depsc','-tiff',['./data/UT_Res_img/',lname,'_',num2str(Comb(1)), num2str(Comb(2)) '.eps']);
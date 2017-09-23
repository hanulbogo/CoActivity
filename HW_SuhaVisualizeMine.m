function [precision ,recall,fmeasure,dth] =HW_SuhaVisualizeMine(density_map, class,Comb)
load('./data/HW_nVideos.mat');%nVideolist
nVideos = nVideolist(class);
load('./data/HW_annotation.mat');
pos_frames= cell(length(Comb), 1);
neg_frames = cell(length(Comb),1);
lname =HW_annotation{sum(nVideolist(1:(class-1)))+1}.label;
PFpath ='./data/HW_TWO_POS_Frames/';
if ~exist(PFpath,'dir')
    mkdir(PFpath);
end
PFcpath = [PFpath lname '/'];
if ~exist(PFcpath,'dir')
    mkdir(PFcpath);
end

pdfpath = ['./data/HW_TWO_RES_IMG/',lname,'/'];
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
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
    option.MaxIter=1000;
    %     mm(2) =mean(density_map{v}(density_map{v}>inith));
    %     try
    %         flag =2;
    %     GMModel{v} = fitgmdist(density_map{v}',2,'Options',option,'Start',idx);
    %     flag=1;
    %     catch
    %
    %     end
    flag=2;
    if flag==1
        idx = cluster(GMModel{v},density_map{v}');
        m1 =mean(density_map{v}(idx==1));
        m2 =mean(density_map{v}(idx==2));
        if isempty(density_map{v}(idx==2)) || isempty(density_map{v}(idx==1))
            idx =ones(length(density_map{v}),1);
            inith= mean(density_map{v});
            idx(density_map{v}<=inith)=2;
            pos_frames{v} = frames(idx==1);
            neg_frames{v} = frames(idx==2);
            
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
        %         fprintf('init th %f mu1 %f, mu2 %f new th %f \n',inith, GMModel{v}.mu(1), GMModel{v}.mu(2), dth(v));
    else
        pos_frames{v} = frames(idx==1);
        neg_frames{v} = frames(idx==2);
        dth(v) = max(density_map{v}(idx==2));
        %         fprintf('init th %f mu1 %f, mu2 %f new th %f \n',inith, GMModel{v}.mu(1), GMModel{v}.mu(2), dth(v));
    end
end

save([PFcpath,'AMC_' ,num2str(Comb(1)), '_',num2str(Comb(2)),'.mat'],'pos_frames');
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
    v_end(v)= sum(HW_annotation{aidx}.nFrames);
    tmp =zeros(v_end(v),1);
    gt_start{v} = HW_annotation{aidx}.gt_start;
    gt_end{v}= HW_annotation{aidx}.gt_end;
    
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
fprintf('%.2f  %.2f  %.2f\n',precision, recall,fmeasure);
lname =HW_annotation{sum(nVideolist(1:(class-1)))+1}.label;
v_cen = (v_start+v_end)/2;

alg_names = {'GroundTruths', 'AMC'};
nalg = length(alg_names);

vis_names = cell(nalg+2, 1);
vis_names{1} = '';
for aidx = 1:nalg
    vis_names{aidx+1} = alg_names{aidx};
end
vis_names{end} = '';
rcolor = zeros(nalg + 1, 3);
rcolor(1, :) = [.1 .7 .1] .* 0.9;
rcolor(2, :) = [.7 .1 .7] .* 0.9;
rcolor(end, :) = ones(1, 3) .* 0.8;

for v= 1: length(Comb)
    % colors
    
    h = figure(1);
    clf;
    set(h, 'Position', [1, 1, 600, 200]);
    A = zeros(nalg,v_end(v));
    
    for gg= 1: length(gt_start{v})
        A(1,gt_start{v}(gg):gt_end{v}(gg))=1;
    end
    A(2,pos_frames{v})=1;
    
    for aidx = 1:nalg
        det_result = A(aidx, :);
        cc = bwconncomp(det_result);
        
        hold on;
        
        bar_height = (aidx / (nalg + 1));
        for idx = 1:cc.NumObjects
            sttt = cc.PixelIdxList{idx}(1);
            endt = cc.PixelIdxList{idx}(end);
            
            line([sttt, endt], ones(1,2) .* bar_height, 'color', rcolor(aidx, :), 'LineWidth', 10);
        end
        hold off;
        %         axis tight;
        axis([1,v_end(v),0 ,1]);
        
        %     axis auto;
        set(gca,'ytick', 0 : 1 / (nalg + 1) :1)
        set(gca, 'YTickLabel', vis_names);
        set(gcf,'PaperSize',[19.1 2.1]);
        
        set(gcf,'PaperPositionMode','Manual');
        set(gcf,'PaperPosition',[-0.4 0.2 21 2]);
        
        set(gca, 'DataAspectRatio',[100*v_end(v)/1200, 1,2]);
        Nkey=6;
%         flist=zeros(2,Nkey);
        %             flist(2,:) =[99,330,420,680,1963,2300];%drum 12 6
        %                  flist(2,:) =[99,330,420,680,1963];%drum 12 5
        nFrame = v_end(v);
        flist =ceil(nFrame/(Nkey)): ceil(nFrame/(Nkey)):nFrame;
        if length(flist)<Nkey
            flist = [10,flist];
        end
        %           if v==1
        % %               nFrame = v_end(1);
        % %                  flist(1,:) = [156 494 648 1077 1436 1795];
        % %                     flist(1,:) = [367 648 1077 1436 1795];%drum 8 5
        %                  flist(v,:) =ceil(nFrame/(Nkey)): ceil(nFrame/(Nkey)):nFrame;
        %           end
%         set(gca,'xtick', flist)
    end
    print(h,'-dpdf',['./data/HW_TWO_RES_IMG/',lname,'/',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '_' num2str(Nkey) '.pdf']);
    print(h,'-dpng',['./data/HW_TWO_RES_IMG/',lname,'/',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '_' num2str(Nkey) '.png']);
    
    
    close all;
    
end
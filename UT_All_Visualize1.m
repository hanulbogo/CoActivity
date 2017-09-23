function [precision ,recall,fmeasure,dth] =UT_All_Visualize1(density_map, class,Comb)
load('./data/UT_nVideos.mat');%nVideolist
nVideos = nVideolist(class);
load('./data/UT_annotation.mat');
pos_frames= cell(length(Comb), 1);
neg_frames = cell(length(Comb),1);
lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
PFpath ='./data/UT_ALL_POS_Frames/';
PFcpath = [PFpath lname '/'];
pdfpath = ['./data/UT_ALL_RES_PLOT1/',lname,'/'];
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end
alg_names = {'GT' 'AMC','AMC-','PR','Xiong'};
%  alg_names = {'GroundTruths', 'AMC'};
nalg = length(alg_names);

vis_names = cell(nalg+2, 1);
vis_names{1} = '';
for aidx = 1:nalg
    vis_names{aidx+1} = alg_names{aidx};
end
vis_names{end} = '';
 rcolor  = linspecer(nalg+2);
% rcolor = zeros(nalg + 1, 3);
% rcolor(1, :) = [.1 .7 .1] .* 0.9;
% rcolor(2, :) = [.7 .1 .7] .* 0.9;
% rcolor(end, :) = ones(1, 3) .* 0.8;
% for v=1:length(Comb)
%     cc= Comb(v);
%     aidx =sum(nVideolist(1:(class-1)))+cc;
%     
%     v_start(v)=1;
%     v_end(v)= sum(UT_annotation{aidx}.nFrames);
%     tmp =zeros(v_end(v),1);
%     gt_start{v} = UT_annotation{aidx}.gt_start;
%     gt_end{v}= UT_annotation{aidx}.gt_end;
%     
%     gt_cen{v} = (gt_start{v}+gt_end{v})/2;
%     for gg= 1: length(gt_start{v})
%         tmp(gt_start{v}(gg):gt_end{v}(gg))=1;
%     end
%     
%     if maxlen<length(density_map{v})
%         maxlen =length(density_map{v});
%     end
%     %     tmp(gt_start(v,1):gt_end(v,1))=1;
%     tmp2=zeros(v_end(v),1);
%     pos_frames{v}=pos_frames{v}(pos_frames{v}<v_end(v));
%     tmp2(pos_frames{v})=1;
%     tp = tp+sum((tmp.*tmp2));
%     precisiondenorm =precisiondenorm +sum(tmp2);
%     recalldenorm = recalldenorm+sum(tmp);
%     
% end
gt_start= cell(length(Comb),1);
gt_end= cell(length(Comb),1);
        
h = figure(1);
clf;
hold on;
    set(h, 'Position', [1, 1, 600, 200]);
     set(gcf,'PaperSize',[13.97 2.6]);
        
        set(gcf,'PaperPositionMode','Manual');
        set(gcf,'PaperPosition',[-0.1 0.07 13.87 2.46]);
        
        
        
for v= 1: length(Comb)
    cc= Comb(v);
    aidx =sum(nVideolist(1:(class-1)))+cc;
    gt_start{v} = UT_annotation{aidx}.gt_start;
    gt_end{v}= UT_annotation{aidx}.gt_end;
    gt_start{v} = UT_annotation{aidx}.gt_start;
    gt_end{v}= UT_annotation{aidx}.gt_end;
    
    v_start(v)=1;
    v_end(v)= sum(UT_annotation{aidx}.nFrames);
    
    
    A = zeros(nalg,v_end(v));
    
    for gg= 1: length(gt_start{v})
        A(1,gt_start{v}(gg):gt_end{v}(gg))=1;
    end
    for mm =2:nalg
        load([PFcpath alg_names{mm}]);
        A(mm,pos_frames{cc})=1;
    end
    subaxis(1,length(Comb),v,'Spacing', 0, 'PaddingBottom',0.2,'PaddingLeft',0.07, 'Margin', 0);
    axis([-1,v_end(v),0 ,nalg+1]);
%     
%     for idx = 1:cc.NumObjects
%         sttt = cc.PixelIdxList{idx}(1);
%         endt = cc.PixelIdxList{idx}(end);
%         rectangle('Position',[sttt,0.1, endt-sttt,nalg+1-0.1], 'FaceColor', [0.9,0.9,0.9],'EdgeColor','none');
%     end
    
    for aidx = 1:nalg
        
        det_result = A(aidx, :);
        cc = bwconncomp(det_result);
        
        
        bar_height = aidx ;
        line([1.5, v_end(v)], ones(1,2) .* bar_height, 'color', [0.95 0.95 0.95], 'LineWidth', 5);
        for idx = 1:cc.NumObjects
            sttt = cc.PixelIdxList{idx}(1);
            endt = cc.PixelIdxList{idx}(end);
%             if v==1
                
%             else
%                 line([2-v, v_end(v)], ones(1,2) .* bar_height, 'color', [0.95 0.95 0.95], 'LineWidth', 5);
%             end
            line([sttt, endt], ones(1,2) .* bar_height, 'color', rcolor(aidx, :), 'LineWidth', 5);
            
        end
%         hold off;
        %         axis tight;
        
        
        %     axis auto;
        set(gca,'ytick', 0 : 1 :nalg)
        set(gca, 'YTickLabel', vis_names ,'FontSize',6,'FontName','Times');
        nFrame = v_end(v);
        Nkey=6;
        flist =ceil(nFrame/(Nkey)): ceil(nFrame/(Nkey)):nFrame;
        set(gca,'xtick', flist)
       
        set(gca, 'DataAspectRatio',[150*v_end(v)/1200, 1,2]);
    end
%     pause;
    
    
    
%     close all;
    
end
hold off;
% print(h,'-dpdf',['./data/UT_TWO_RES_IMG/',lname,'/',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '.pdf']);
%     print(h,'-dpng',['./data/UT_TWO_RES_IMG/',lname,'/',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '.png']);

respath =[pdfpath,lname];
for cc = 1:length(Comb)
    respath = [respath '_' num2str(Comb(cc))];
end

print(h,'-dpdf',[respath '.pdf']);
print(h,'-dpng',[respath  '.png']);
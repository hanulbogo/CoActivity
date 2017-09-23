function [precision ,recall,fmeasure,dth] =UT_N_Visualize3(class,Comb)
load('./data/UT_nVideos.mat');%nVideolist
nVideos = nVideolist(class);
load('./data/UT_annotation.mat');
pos_frames= cell(length(Comb), 1);
neg_frames = cell(length(Comb),1);
lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
PFpath ='./data/UT_TWO_POS_Frames/';
PFcpath = [PFpath lname '/'];
pdfpath = ['./data/UT_TWO_RES_PLOT2/',lname,'/'];
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end
alg_names = {'GT' 'AMC','AMC-','PR', 'CS' 'TCD','Guo'};
vistemp = {'GT' 'AMC','AMC-','PR','CS' 'TCD','VCS'};
%  alg_names = {'GroundTruths', 'AMC'};
nalg = length(alg_names);

vis_names = cell(nalg+2, 1);
vis_names{1} = '';
for aidx = 1:nalg
    vis_names{aidx+1} = vistemp{aidx};
end
vis_names{end} = '';
rcolor  = linspecer(nalg);
gt_start= cell(length(Comb),1);
gt_end= cell(length(Comb),1);
        

        
        
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
        load([PFcpath alg_names{mm} '_' num2str(Comb(1)), '_',num2str(Comb(2)) '.mat']);
        A(mm,pos_frames{v})=1;
    end
    
    h = figure(1);
    clf;
    hold on;
    %�������� �׳� figure ������â�� ��ġ�ε�?!
    set(h, 'Position', [1, 1, 600, 200]);
    
    %paper size ����ü
   set(gcf,'PaperSize',[4 2.5]);
        
        set(gcf,'PaperPositionMode','Manual');
        %���ʾƷ����� �����ؼ� ������ ������ ������ �ϴ°�
        %�����ʳ��� ���� �Ѿ�� ������ ���ڰ� �ٳ���
        set(gcf,'PaperPosition',[-0.1 0 4.2 2.5]);
    
    subaxis(1,1,1,'Spacing', 0, 'PaddingTop',0.15,'PaddingBottom',0.15,'PaddingLeft',0.13,'PaddingRight',0.025,'Margin', 0);
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
        
        
           bar_height = nalg+1-aidx ;
        line([1, v_end(v)], ones(1,2) .* bar_height, 'color', [0.95 0.95 0.95], 'LineWidth', 3);
        for idx = 1:cc.NumObjects
            sttt = cc.PixelIdxList{idx}(1);
            endt = cc.PixelIdxList{idx}(end);
            if endt-sttt<3
                if endt ~=v_end(v)
                    endt=sttt+3;
                else
                    sttt= endt-3;
                end
            end
%             if v==1
                
%             else
%                 line([2-v, v_end(v)], ones(1,2) .* bar_height, 'color', [0.95 0.95 0.95], 'LineWidth', 5);
%             end
            line([sttt, endt], ones(1,2) .* bar_height, 'color', rcolor(aidx, :), 'LineWidth', 3);
            
        end
%         hold off;
        %         axis tight;
        
        
        %     axis auto;
        set(gca,'ytick', 0 : 1 :nalg)
        set(gca, 'YTickLabel', wrev(vis_names),'FontSize',7,'FontName','Times');
        nFrame = v_end(v);
        Nkey=5;
        flist=ceil(nFrame/10): ceil(nFrame/5):nFrame;
        set(gca,'xtick', flist); 
       
        set(gca, 'DataAspectRatio',[135*v_end(v)/1200*5/(nalg), 1,2]);
    end
    lname=changelname(lname);
    text(v_end(v)/2,nalg+2.0,[lname ' ' num2str(Comb(v))],'FontSize',8,'FontName','Times','HorizontalAlignment','center');
    hold off;
    print(h,'-dpdf',[pdfpath,lname,'_',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '.pdf']);
    print(h,'-dpng',[pdfpath,lname,'_',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '.png']);
%     pause;
    
    
    
    close all;
    
end
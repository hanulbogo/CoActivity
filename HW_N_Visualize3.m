function [precision ,recall,fmeasure,dth] =HW_N_Visualize3(class,Comb)
load('./data/HW_nVideos.mat');%nVideolist
nVideos = nVideolist(class);
load('./data/HW_annotation.mat');
pos_frames= cell(length(Comb), 1);
neg_frames = cell(length(Comb),1);
lname =HW_annotation{sum(nVideolist(1:(class-1)))+1}.label;
PFpath ='./data/HW_TWO_POS_Frames/';
PFcpath = [PFpath lname '/'];
pdfpath = ['./data/HW_TWO_RES_PLOT2/',lname,'/'];
if ~exist(pdfpath,'dir')
    mkdir(pdfpath);
end
alg_names = {'GT' 'AMC','AMC-','PR', 'CS' 'TCD'};
vistemp = {'GT' 'AMC','AMC-','PR','CS' 'TCD'};
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
    gt_start{v} = HW_annotation{aidx}.gt_start;
    gt_end{v}= HW_annotation{aidx}.gt_end;
    gt_start{v} = HW_annotation{aidx}.gt_start;
    gt_end{v}= HW_annotation{aidx}.gt_end;
    
    v_start(v)=1;
    v_end(v)= sum(HW_annotation{aidx}.nFrames);
    
    
    A = zeros(nalg,v_end(v));
    
    for gg= 1: length(gt_start{v})
        
        gt_start{v}(gt_start{v}==0)=1;
        gt_end{v}(gt_end{v}>v_end(v))=v_end(v);
        A(1,gt_start{v}(gg):gt_end{v}(gg))=1;
    end
    for mm =2:nalg
        if exist([PFcpath alg_names{mm} '_' num2str(Comb(1)), '_',num2str(Comb(2)) '.mat'],'file')
        load([PFcpath alg_names{mm} '_' num2str(Comb(1)), '_',num2str(Comb(2)) '.mat']);
        else
            pos_frames=[];
        end
        if ~isempty(pos_frames)
            A(mm,pos_frames{v})=1;
        end
    end
    
    h = figure(1);
    clf;
    hold on;
    %포지션은 그냥 figure 윈도우창의 위치인듯?!
    set(h, 'Position', [1, 1, 600, 200]);
    
    %paper size 그자체
   set(gcf,'PaperSize',[4 2.5]);
        
        set(gcf,'PaperPositionMode','Manual');
        %왼쪽아래에서 시작해서 오른쪽 끝에서 끝나게 하는거
        %오른쪽끝에 조금 넘어가서 끝나야 글자가 다나옴
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
                    endt=endt+1;
                else
                    sttt= sttt-1;
                end
            end
            line([sttt, endt], ones(1,2) .* bar_height, 'color', rcolor(aidx, :), 'LineWidth', 3);
            
        end
%         hold off;
        %         axis tight;
        
        
        %     axis auto;
        set(gca,'ytick', 0 : 1 :nalg)
        set(gca, 'YTickLabel', wrev(vis_names),'FontSize',7,'FontName','Times');
        nFrame = v_end(v);
        Nkey=5;
        flist =ceil(nFrame/(Nkey)): ceil(nFrame/(Nkey)):nFrame;
        set(gca,'xtick', flist); 
       
        set(gca, 'DataAspectRatio',[135*v_end(v)/1200*5/(nalg), 1,2]);
    end
%     lname=changelname(lname);
    text(v_end(v)/2,nalg+2.0,[changelname(lname) ' ' num2str(Comb(v))],'FontSize',8,'FontName','Times','HorizontalAlignment','center');
    hold off;
    print(h,'-dpdf',[pdfpath,lname,'_',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '.pdf']);
    print(h,'-dpng',[pdfpath,lname,'_',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '.png']);
%     pause;
    
    
    
    close all;
    
end
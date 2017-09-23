nCenters =4000;
% nc=;
NC =7;
cumacc = zeros(1001,1);
close all;
    nc=7;
    
    ptemp=0;
    rtemp=0;
    ftemp=0;

alg_names= {'GT' 'AMC','AMC-','PR','CS' 'TCD','VCS'};
nalg = length(alg_names);
rcolor  = linspecer(nalg);
all_alg= {'AMC','PR','CS'};

TH_All_P = [0.28,0.30,0.28];
TH_All_R = [0.82,0.16,0.57];
TH_All_F =[0.40,0.19,0.36];
TH_All =[TH_All_P;TH_All_R;TH_All_F];


h = figure(1);
clf;
hold on;
%포지션은 그냥 figure 윈도우창의 위치인듯?!
set(h, 'Position', [1, 1, 600, 600]);

%paper size 그자체
set(gcf,'PaperSize',[7 6]);

set(gcf,'PaperPositionMode','Manual');
%왼쪽아래에서 시작해서 오른쪽 끝에서 끝나게 하는거
%오른쪽끝에 조금 넘어가서 끝나야 글자가 다나옴
set(gcf,'PaperPosition',[-0.1 -1 7 8]);

subaxis(1,1,1,'Spacing', 0, 'PaddingTop',0.15,'PaddingBottom',0.15,'PaddingLeft',0.13,'PaddingRight',0.025,'Margin', 0);
% axis([-1,4,0 ,max(TH_All(:))+0.1]);

Y=bar(TH_All,'EdgeColor','none');%,'FaceColor',rcolor(2,:),'FaceColor',rcolor(4,:));
ax = get(gca);
cata = ax.Children;
%set the first bar chart style
set(cata(3),'FaceColor',rcolor(2,:));
set(cata(2),'FaceColor',rcolor(4,:));
set(cata(1),'FaceColor',rcolor(5,:));
legend(all_alg,'Orientation','horizontal','Location','southoutside','Interpreter','latex');

set(gca,'box','off');
set(gca,'xtick', 1:3);
set(gca, 'XTickLabel', {'Precision', 'Recall', 'F-measure'},'FontSize',7,'FontName','Times');
% set(gca, 'DataAspectRatio',[4,6 ,2]);
hold off;
print(h,'-dpdf','./TH_all.pdf');
% print(h,'-dpng',[pdfpath,lname,'_',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '.png']);
two_alg= {'AMC','PR','CS','TCD'};

TH_two_P = [0.30,	0.27,	0.25,	0.22];
TH_two_R = [0.57,		0.08,	0.63,	0.07];
TH_two_F =[0.35,		0.11,	0.32,	0.08];
TH_two =[TH_two_P;TH_two_R;TH_two_F];    


h = figure(1);
clf;
hold on;
%포지션은 그냥 figure 윈도우창의 위치인듯?!
set(h, 'Position', [1, 1, 600, 600]);

%paper size 그자체
set(gcf,'PaperSize',[10 6]);

set(gcf,'PaperPositionMode','Manual');
%왼쪽아래에서 시작해서 오른쪽 끝에서 끝나게 하는거
%오른쪽끝에 조금 넘어가서 끝나야 글자가 다나옴
set(gcf,'PaperPosition',[-0.1 -1 10 8]);

subaxis(1,1,1,'Spacing', 0, 'PaddingTop',0.15,'PaddingBottom',0.15,'PaddingLeft',0.13,'PaddingRight',0.025,'Margin', 0);
% axis([-1,4,0 ,max(TH_All(:))+0.1]);

Y=bar(TH_two,'EdgeColor','none');%,'FaceColor',rcolor(2,:),'FaceColor',rcolor(4,:));
ax = get(gca);
cata = ax.Children;
%set the first bar chart style
set(cata(4),'FaceColor',rcolor(2,:));
set(cata(3),'FaceColor',rcolor(4,:));
set(cata(2),'FaceColor',rcolor(5,:));
set(cata(1),'FaceColor',rcolor(6,:));


l_h = legend(two_alg,'Orientation','horizontal','Location','southoutside','Interpreter','latex');
% hLegendPatch = findobj(l_h, 'type', 'patch');
% set(hLegendPatch, 'XData', [.2, .2, .3, .3])
% object_h.Children.MarkerSize=3;
% v = get(object_h.Children, 'vertices');   % Get the vertices of the patch
% Length = v(3,1) - v(2,1) ;
% v(3,1) = v(3,1) - Length/2; % Change the length to half
% v(4,1) = v(4,1) - Length/2;
% set(l, 'vertices', v);

set(gca,'box','off');
set(gca,'xtick', 1:3);
set(gca, 'XTickLabel', {'Precision', 'Recall', 'F-measure'},'FontSize',10,'FontName','Times');
% set(gca, 'DataAspectRatio',[4,6 ,2]);
hold off;
print(h,'-dpdf','./TH_two.pdf');
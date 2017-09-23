%
%
nodesize =10;
classlist =[1:11];%:12;%11:12;%6%[1,2,3,4,7];
% len= nodesize*8;
len= nodesize*3;

load('./data/HW_annotation.mat');%'HW_annotation'
load('./data/HW_nVideos.mat');%nVideolist

% cpath ='./data/HW_feat/';
hpath='./data/HW_hist/';
spath ='./data/HW_seg_hists/';
dpath ='./data/HW_density_map/';
distpath = './data/HW_dists/';
npath ='./data/HW_L1NORM_seg_hists/';
% matlabpool(3);
% nVideos=10;
% nCenters =[50,125,250,500,1000,2000,4000];
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
all_alg= {'AMC','AMC-','PR','CS'};
HW_All_P = [0.344,0.346,0.399,0.35875];
HW_All_R = [0.639,0.64,0.463,0.65375];
HW_All_F =[0.434,0.431,0.42,0.45];
HW_All =[HW_All_P;HW_All_R;HW_All_F];


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

subaxis(1,1,1,'Spacing', 0, 'PaddingTop',0.15,'PaddingBottom',0.25,'PaddingLeft',0.13,'PaddingRight',0.025,'Margin', 0);
% axis([-1,4,0 ,max(HW_All(:))+0.1]);

Y=bar(HW_All,'EdgeColor','none');%,'FaceColor',rcolor(2,:),'FaceColor',rcolor(4,:));
ax = get(gca);
cata = ax.Children;
%set the first bar chart style
set(cata(4),'FaceColor',rcolor(2,:));
set(cata(3),'FaceColor',rcolor(3,:));
set(cata(2),'FaceColor',rcolor(4,:));
set(cata(1),'FaceColor',rcolor(5,:));
% legend(all_alg,'Orientation','horizontal','Location','southoutside','Interpreter','latex');

set(gca,'box','off');
set(gca,'xtick', 1:3);
set(gca, 'XTickLabel', {'Precision', 'Recall', 'F-measure'},'FontSize',10,'FontName','Times');
% set(gca, 'DataAspectRatio',[4,6 ,2]);
axis([0.5,3.5,0 ,1]);
hold off;
print(h,'-dpdf','./HW_all2.pdf');
% print(h,'-dpng',[pdfpath,lname,'_',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '.png']);
two_alg= {'AMC','AMC-','PR','CS','TCD'};

HW_two_P = [0.57,	0.57,	0.6,	0.4497,	0.57];
HW_two_R = [0.47,	0.41,	0.29,	0.595507,	0.39];
HW_two_F =[0.46,	0.43,	0.36,	0.45191,	0.41];
HW_two =[HW_two_P;HW_two_R;HW_two_F];    


h = figure(1);
clf;
hold on;
%포지션은 그냥 figure 윈도우창의 위치인듯?!
set(h, 'Position', [1, 1, 600, 600]);

%paper size 그자체
set(gcf,'PaperSize',[13 6]);

set(gcf,'PaperPositionMode','Manual');
%왼쪽아래에서 시작해서 오른쪽 끝에서 끝나게 하는거
%오른쪽끝에 조금 넘어가서 끝나야 글자가 다나옴
set(gcf,'PaperPosition',[-0.1 -1 13 8]);

subaxis(1,1,1,'Spacing', 0, 'PaddingTop',0.15,'PaddingBottom',0.25,'PaddingLeft',0.13,'PaddingRight',0.025,'Margin', 0);
% axis([-1,4,0 ,max(HW_All(:))+0.1]);

Y=bar(HW_two,'EdgeColor','none');%,'FaceColor',rcolor(2,:),'FaceColor',rcolor(4,:));
ax = get(gca);
cata = ax.Children;
%set the first bar chart style
set(cata(5),'FaceColor',rcolor(2,:));
set(cata(4),'FaceColor',rcolor(3,:));
set(cata(3),'FaceColor',rcolor(4,:));
set(cata(2),'FaceColor',rcolor(5,:));
set(cata(1),'FaceColor',rcolor(6,:));


% l_h = legend(two_alg,'Orientation','horizontal','Location','southoutside','Interpreter','latex');
% hLegendPatch = findobj(l_h, 'type', 'patch');
% set(hLegendPatch, 'XData', [.2, .2, .3, .3])
% object_h.Children.MarkerSize=3;
% v = get(object_h.Children, 'vertices');   % Get the vertices of the patch
% Length = v(3,1) - v(2,1) ;
% v(3,1) = v(3,1) - Length/2; % Change the length to half
% v(4,1) = v(4,1) - Length/2;
% set(l, 'vertices', v);

set(gca,'box','off');
% set(gca,'xtick', 1:3);
set(gca, 'XTickLabel', {'Precision', 'Recall', 'F-measure'},'FontSize',13,'FontName','Times');
% set(gca, 'DataAspectRatio',[4,6 ,2]);
axis([0.5,3.5,0 ,1]);
hold off;
print(h,'-dpdf','./HW_two2.pdf');
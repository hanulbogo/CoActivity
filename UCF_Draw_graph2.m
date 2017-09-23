%
%
nodesize =10;
classlist =[1:11];%:12;%11:12;%6%[1,2,3,4,7];
% len= nodesize*8;
len= nodesize*3;

load('./data/UCF_annotation.mat');%'UCF_annotation'
load('./data/UCF_nVideos.mat');%nVideolist

% cpath ='./data/UCF_feat/';
hpath='./data/UCF_hist/';
spath ='./data/UCF_seg_hists/';
dpath ='./data/UCF_density_map/';
distpath = './data/UCF_dists/';
npath ='./data/UCF_L1NORM_seg_hists/';
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
UCF_All_P = [0.61,0.64,0.69, 0.507426];
UCF_All_R = [0.68,0.69,0.41,0.583564];
UCF_All_F =[0.64,0.65,0.51,0.537723];
UCF_All =[UCF_All_P;UCF_All_R;UCF_All_F];



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
% axis([-1,4,0 ,max(UCF_All(:))+0.1]);

Y=bar(UCF_All,'EdgeColor','none');%,'FaceColor',rcolor(2,:),'FaceColor',rcolor(4,:));
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
print(h,'-dpdf','./UCF_all2.pdf');
% print(h,'-dpng',[pdfpath,lname,'_',num2str(Comb(1)), '_',num2str(Comb(2)),'_',num2str(Comb(v)) '.png']);
two_alg= {'AMC','AMC-','PR','CS','TCD'};

UCF_two_P = [0.63,0.64,0.65,0.456576,0.48];
UCF_two_R = [0.55,0.51,0.28,0.659033,0.39];
UCF_two_F =[0.57,0.55,0.37,0.522486,0.4];
UCF_two =[UCF_two_P;UCF_two_R;UCF_two_F];    
 


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
% axis([-1,4,0 ,max(UCF_All(:))+0.1]);

Y=bar(UCF_two,'EdgeColor','none');%,'FaceColor',rcolor(2,:),'FaceColor',rcolor(4,:));
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
print(h,'-dpdf','./UCF_two2.pdf');
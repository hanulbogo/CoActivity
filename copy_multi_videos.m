
orgpath='./../UCF101';
orglist = dir(orgpath);
orglist = orglist(3:end);
rootpath = './../UCF_multi/';
if ~exist(rootpath,'dir')
    mkdir(rootpath);
end
selectedlist = zeros(size(orglist));

for i=1:length(orglist)
    if strcmp(orglist(i).name,'Billiards')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'Drumming')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'GolfSwing')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'JugglingBalls')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'JumpRope')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'Nunchucks')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'PlayingGuitar')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'PlayingPiano')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'PlayingTabla')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'PommelHorse')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'PullUps')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'TaiChi')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'TennisSwing')
        selectedlist(i)=1;
    elseif strcmp(orglist(i).name,'YoYo')
        selectedlist(i)=1;
    end
end

if ~exist(rootpath,'dir')
    mkdir(rootpath);
end
Nsub=25;
Npos=3;
Nvid=5;
Nneg=25;
Nset=100;
selind =1:length(orglist);
selind =selind(logical(selectedlist));
gt_label = cell(3,Nset);
for i = 1: Nset;
    posind = selind(randperm(length(selind)));
    negind = 1:length(orglist);
    negind =negind(negind~=posind(1));
    negind =negind(negind~=posind(2));
    negind =negind(negind~=posind(3));
    negind =negind(randperm(length(negind)));
    spath = [rootpath, num2str(i,'%03d'),'/'];
    if ~exist(spath,'dir')
        mkdir(spath);
    end
    for p =1:Npos
        vind = randperm(25);
        gt_name{p} =orglist(posind(p)).name;
        
        for v=1:Nvid
            vlist = dir([orgpath,'/',orglist(posind(p)).name,'/v_',orglist(posind(p)).name,'_g',num2str(vind(v),'%02d'),'*.avi']);
            s =randi(length(vlist), 1,1);
            opath=[orgpath,'/',orglist(posind(p)).name,'/'];
            copyfile([opath,vlist(s).name], spath);
        end
    end
    gt_label(:,i)= gt_name;
    for n=1:Nneg
        Nind =negind(n);
        Npath = [orgpath,'/',orglist(Nind).name,'/'];
        nvlist =dir([Npath,'*.avi']);
        ns = randi(length(nvlist),1,1);
        copyfile([Npath,nvlist(ns).name],spath);
    end
    cvind =randperm(40);
    vlist = dir([spath,'*.avi']);
    for cv=1:10
        vpath = [spath, num2str(cv,'%02d'),'/'];
        if ~exist(vpath,'dir')
            mkdir(vpath)
        end
        for v=1:4
            movefile([spath,vlist(cvind((cv-1)*4+v)).name],vpath);
        end
        
    end
end
multi_gt_label = gt_label;
save('./data/multi_gt_label.mat','multi_gt_label');
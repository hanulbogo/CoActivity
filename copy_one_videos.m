
orgpath='./../UCF101';
orglist = dir(orgpath);
orglist = orglist(3:end);
rootpath = './../UCF_one/';
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
for i=1:length(orglist)
    if selectedlist(i) ==1
        cpath = [rootpath, orglist(i).name,'/'];
        if ~exist(cpath,'dir')
            mkdir(cpath);
        end
        negind =1:length(orglist);
        negind =negind(negind~=i);
        negind =negind(randperm(length(negind)));
        for v=1:Nsub
            vpath = [cpath,num2str(v,'%02d'),'/'];
            if ~exist(vpath,'dir')
                mkdir(vpath);
            end
            vlist = dir([orgpath,'/',orglist(i).name,'/v_',orglist(i).name,'_g',num2str(v,'%02d'),'*.avi']);
            s =randi(length(vlist), 1,1);
            opath=[orgpath,'/',orglist(i).name,'/'];
            copyfile([opath,vlist(s).name], vpath);
            
            for neg=1:3
                Nind =negind((v-1)*3+neg);
                Npath = [orgpath,'/',orglist(Nind).name,'/'];
                nvlist =dir([Npath,'*.avi']);
                ns = randi(length(nvlist),1,1);
                copyfile([Npath,nvlist(ns).name],vpath);
            end
        end
        
    end
end

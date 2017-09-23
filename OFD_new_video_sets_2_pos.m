
orgpath='./../UCF101';
orglist = dir(orgpath);
orglist = orglist(3:end);
rootpath = './../UCF_OFD_TWO_SET/';

if ~exist(rootpath,'dir')
    mkdir(rootpath);
end
Nsub=25;
Nneg =2;
NPos= 2;
for i=1:length(orglist)
    
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
        s =randperm(length(vlist));
        for si =1:NPos
            opath=[orgpath,'/',orglist(i).name,'/'];
            copyfile([opath,vlist(s(si)).name], vpath);
        end
        for neg=1:Nneg
            Nind =negind((v-1)*Nneg+neg);
            Npath = [orgpath,'/',orglist(Nind).name,'/'];
            nvlist =dir([Npath,'*.avi']);
            ns = randi(length(nvlist),1,1);
            copyfile([Npath,nvlist(ns).name],vpath);
        end
    end
    
end

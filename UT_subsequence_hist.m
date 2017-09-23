function UT_subsequence_hist(stepsize, class, len) % flag =1 ofd flag =2 org
global dpath;
global npath;
load([dpath ,'UT_nVideos.mat']);%nVideolist
load([dpath ,'UT_annotation.mat']);%'UT_annotation'
hpath=[dpath,'UT_hist/'];

if ~exist(npath,'dir')
    mkdir(npath);
end

nVideos=nVideolist(class);
lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;

nCenters =4000;


nnodes = zeros(nVideos,1);
for v=1:nVideos
    aidx =sum(nVideolist(1:(class-1)))+v;
    nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/stepsize)*stepsize - len)/stepsize +1;
end

total_nodes =  sum(nnodes);

TSEGHISTS =zeros(total_nodes,nCenters);
HOGSEGHISTS= TSEGHISTS;%zeros(total_nodes,nCenters);
HOFSEGHISTS= TSEGHISTS;%zeros(total_nodes,nCenters);
MBHxSEGHISTS= TSEGHISTS;%zeros(total_nodes,nCenters);
MBHySEGHISTS= TSEGHISTS;%zeros(total_nodes,nCenters);

hidx =1;

for v=1:nVideos
    aidx =sum(nVideolist(1:(class-1)))+v;
    load([hpath,UT_annotation{aidx}.name,'_stepsize_',num2str(stepsize),'_HISTS.mat']);
    oldhidx = hidx;
    
    hidx = oldhidx;
    Tcumhists = cumsum(Thists);
    HOGcumhists = cumsum(HOGhists);
    HOFcumhists = cumsum(HOFhists);
    MBHxcumhists = cumsum(MBHxhists);
    MBHycumhists = cumsum(MBHyhists);
    for n = 1: nnodes(v)
        n_start = n;
        n_end = n+(len/stepsize)-1;
        if n_start~=1
            TSEGHISTS(hidx,:) = Tcumhists(n_end,:)- Tcumhists(n_start-1,:);
            HOGSEGHISTS(hidx,:) = HOGcumhists(n_end,:)- HOGcumhists(n_start-1,:);
            HOFSEGHISTS(hidx,:) = HOFcumhists(n_end,:)- HOFcumhists(n_start-1,:);
            MBHxSEGHISTS(hidx,:) = MBHxcumhists(n_end,:)- MBHxcumhists(n_start-1,:);
            MBHySEGHISTS(hidx,:) = MBHycumhists(n_end,:)- MBHycumhists(n_start-1,:);
            hidx = hidx+1;
        else
            TSEGHISTS(hidx,:) = Tcumhists(n_end,:);
            HOGSEGHISTS(hidx,:) = HOGcumhists(n_end,:);
            HOFSEGHISTS(hidx,:) = HOFcumhists(n_end,:);
            MBHxSEGHISTS(hidx,:) = MBHxcumhists(n_end,:);
            MBHySEGHISTS(hidx,:) = MBHycumhists(n_end,:);
            hidx =hidx+1;
        end
    end
    
end


%% Histogram normalization

sT = sum(TSEGHISTS,2);
sT(sT==0)=1;
TDATA = TSEGHISTS./repmat(sT,1,size(TSEGHISTS,2));

sHOG = sum(HOGSEGHISTS,2);
sHOG(sHOG==0)=1;
HOGDATA = HOGSEGHISTS./repmat(sHOG,1,size(HOGSEGHISTS,2));

sHOF = sum(HOFSEGHISTS,2);
sHOF(sHOF==0)=1;
HOFDATA = HOFSEGHISTS./repmat(sHOF,1,size(HOFSEGHISTS,2));

sMx = sum(MBHxSEGHISTS,2);
sMx(sMx==0)=1;
MBHxDATA = MBHxSEGHISTS./repmat(sMx,1,size(MBHxSEGHISTS,2));

sMy = sum(MBHySEGHISTS,2);
sMy(sMy==0)=1;
MBHyDATA = MBHySEGHISTS./repmat(sMy,1,size(MBHySEGHISTS,2));
% end
NDATA=sT;

save([npath,lname,'_stepsize_',num2str(stepsize), '_subsequence_len_',num2str(len),'.mat'],'NDATA','TDATA','HOGDATA','HOFDATA','MBHxDATA','MBHyDATA');

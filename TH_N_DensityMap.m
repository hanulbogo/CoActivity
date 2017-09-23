function density_map=TH_N_DensityMap(nnodes,nodesize, class, len,density,Comb)
load('./data/TH_annotation.mat');%'TH_annotation'
dpath ='./data/TH_density_map/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end

load('./data/TH_nVideos.mat');%nVideolist
nVideos = nVideolist(class);

density_map=cell(length(Comb),1);
hidx =1;
for cc=1:length(Comb)
    v=Comb(cc);
    aidx =sum(nVideolist(1:(class-1)))+v;
    density_per_vid = zeros(1, sum(TH_annotation{aidx}.nFrames));
    denorm=zeros(1, sum(TH_annotation{aidx}.nFrames));
    
    
    for n = 1: nnodes(v)
        n_start = n;
        n_end = n+(len/nodesize)-1;
        fpos = (n_start-1)*nodesize+1:min(n_end*nodesize,length(density_per_vid));
        
        density_per_vid(fpos) = density_per_vid(fpos)+ density(hidx);
        denorm(fpos) = denorm(fpos)+1;
        
        hidx=hidx+1;
    end
    
    density_map{cc}= density_per_vid./denorm;
    
end

for v=1:length(Comb)
    density_map{v}=  (density_map{v}-min(density_map{v}))/max(density_map{v}-min(density_map{v}));%/(len/nodesize);%maxdensity;
end
%     save([dpath,TH_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_TH_',num2str(len),'_',num2str(nCenter),'_org.mat'],'density_map');

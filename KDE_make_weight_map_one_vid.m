function KDE_make_weight_map_one_vid(nodesize, classlist, len,density,vididx)
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
dpath ='./data/KDE_density_map_one/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end

nVideos=25;
maxdensity = 0;
for class =classlist
    
    nnodes = zeros(nVideos,1);
    for v=vididx
        aidx =(class-1)*nVideos+v;
        nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
    end
    
    hidx =1;
    density_map=cell(nVideos,1);
    for v=vididx
        aidx =(class-1)*nVideos+v;
        density_per_vid = zeros(1, sum(ucf_annotation{aidx}.nFrames));
        for n = 1: nnodes(v)
            n_start = n;
            n_end = n+(len/nodesize)-1;
            fpos = (n_start-1)*nodesize+1:min(n_end*nodesize,length(density_per_vid));
%             fpos = (n-1)*nodesize+len/2;
            density_per_vid(fpos) = density_per_vid(fpos)+ density(hidx);
            hidx=hidx+1;
        end
        
        density_map{v}= density_per_vid;
        if max(density_per_vid)>maxdensity
            maxdensity=max(density_per_vid);
        end
    end
    for v=vididx
        density_map{v}=  density_map{v}/ maxdensity;
    end
    save([dpath,ucf_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_KDE_',num2str(len),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'.mat'],'density_map');
end

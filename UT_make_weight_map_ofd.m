function UT_make_weight_map_ofd(nodesize, classlist, len,density,nCenter)
load('./data/UT_annotation.mat');%'UT_annotation'
dpath ='./data/UT_density_map/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end

nVideos=10;
maxdensity = 0;
for class =classlist
    
    nnodes = zeros(nVideos,1);
    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
    end
    
    hidx =1;
    density_map=cell(nVideos,1);
    for v=1:nVideos
        aidx =(class-1)*nVideos+v;
        density_per_vid = zeros(1, UT_annotation{aidx}.nFrames);
        for n = 1: nnodes(v)
            n_start = n;
            n_end = n+(len/nodesize)-1;
            fpos = (n_start-1)*nodesize+1:min(n_end*nodesize,length(density_per_vid));
%             fpos = (n-1)*nodesize+len/2;
            density_per_vid(fpos) = density_per_vid(fpos)+ density(hidx);
%             density_per_vid(fpos) = max(density_per_vid(fpos), density(hidx));
            hidx=hidx+1;
        end
        
        density_map{v}= density_per_vid;
%         density_map{v}= density_per_vid/max(density_per_vid);
        if max(density_per_vid)>maxdensity
            maxdensity=max(density_per_vid);
        end
        
    end
% %     fprintf('max density %f\n', maxdensity);
    for v=1:nVideos
        density_map{v}=  density_map{v}/maxdensity;%/(len/nodesize);%maxdensity;
    end
    save([dpath,UT_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_UT_',num2str(len),'_',num2str(nCenter),'_ofd.mat'],'density_map');
end

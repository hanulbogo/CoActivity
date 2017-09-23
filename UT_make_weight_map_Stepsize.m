function density_map=UT_make_weight_map_Stepsize(stepsize,nodesize, classlist, len,density)
load('./data/UT_annotation.mat');%'UT_annotation'
dpath ='./data/UT_density_map/';
if ~exist(dpath,'dir')
    mkdir(dpath);
end
load('./data/UT_nVideos.mat');%nVideolist

% sum(nVideolist(1:(class-1)))
nVideos=nVideolist(classlist);
maxdensity = 0;
mindensity = inf;
for class =classlist
    
    nnodes = zeros(nVideos,1);
    for v=1:nVideos
        aidx =sum(nVideolist(1:(class-1)))+v;
        nnodes(v) =(ceil(sum(UT_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
    end
    hidx =1;
      density_map=cell(nVideos,1);
    
    for v=1:nVideos
        aidx =sum(nVideolist(1:(class-1)))+v;
        density_per_vid = zeros(1, sum(UT_annotation{aidx}.nFrames));
        denorm=zeros(1, sum(UT_annotation{aidx}.nFrames));
        
        for n = 1:stepsize/nodesize:nnodes(v)
            n_start = (n-1)*nodesize+1;
            n_end = n_start+len-1;
%             fpos = (n_start-1)*nodesize+1:min(n_end*nodesize,length(density_per_vid));
            fpos = n_start:min(n_end,length(density_per_vid));

            density_per_vid(fpos) = density_per_vid(fpos)+ density(hidx);
            denorm(fpos) = denorm(fpos)+1;

            hidx=hidx+1;
        end
        
        density_map{v}= density_per_vid./(denorm+1e-15);

    end

    for v=1:nVideos
        density_map{v}=  (density_map{v}-min(density_map{v}))/(max(density_map{v})-min(density_map{v}))+rand(size(density_map{v}))*eps;%/(len/nodesize);%maxdensity;
    end
%     save([dpath,UT_annotation{aidx}.label,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_UT_',num2str(len),'_',num2str(nCenter),'_org.mat'],'density_map');
end

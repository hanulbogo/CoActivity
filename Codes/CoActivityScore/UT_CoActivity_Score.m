function co_activity_score=UT_CoActivity_Score(nodesize, classlist, len,absorption_time)
global dpath;
load([dpath,'UT_annotation.mat']);%'UT_annotation'
load([dpath,'UT_nVideos.mat']);%nVideolist

nVideos=nVideolist(classlist);

for class =classlist
    
    nnodes = zeros(nVideos,1);
    for v=1:nVideos
        aidx =sum(nVideolist(1:(class-1)))+v;
        nnodes(v) =(ceil(sum(UT_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
    end
    
    hidx =1;
      co_activity_score=cell(nVideos,1);
    
    for v=1:nVideos
        aidx =sum(nVideolist(1:(class-1)))+v;
        absorption_time_per_video = zeros(1, sum(UT_annotation{aidx}.nFrames));
        denorm=zeros(1, sum(UT_annotation{aidx}.nFrames));
        for n = 1: nnodes(v)
            n_start = n;
            n_end = n+(len/nodesize)-1;
            fpos = (n_start-1)*nodesize+1:min(n_end*nodesize,length(absorption_time_per_video));

            absorption_time_per_video(fpos) = absorption_time_per_video(fpos)+ absorption_time(hidx);
            denorm(fpos) = denorm(fpos)+1;

            hidx=hidx+1;
        end
        
        co_activity_score{v}= absorption_time_per_video./(denorm+1e-15);

    end

    for v=1:nVideos
        co_activity_score{v}=  (co_activity_score{v}-min(co_activity_score{v}))/(max(co_activity_score{v})-min(co_activity_score{v}));%/(len/nodesize);%maxdensity;
    end
end

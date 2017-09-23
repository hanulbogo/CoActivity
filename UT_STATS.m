load('./data/UT_nVideos.mat');%nVideolist
load('./data/UT_annotation.mat');%'UT_annotation'
for class=1:11
    
    nVideos = nVideolist(class);
    idxstart =sum(nVideolist(1:class-1))+1;
    idxend=sum(nVideolist(1:class));
%     cname =UT_annotation{idxstart}.cname;
    idxlist = idxstart:idxend;
    nFrames= zeros(nVideos,1);
    nC = zeros(nVideos,1);
    nO = zeros(nVideos,1);
    for vv= 1:nVideos
        idx = idxlist(vv);
        nFrames(vv) = UT_annotation{idx}.nFrames;
        for gg = 1:length(UT_annotation{idx}.gt_start)
                nC(vv)=nC(vv)+UT_annotation{idx}.gt_end(gg)-UT_annotation{idx}.gt_start(gg);
        end
        nO(vv) =length(UT_annotation{idx}.gt_start);
    end

    %NFrames
    fprintf('%f %f %f %f',mean(nFrames),max(nFrames),min(nFrames),std(nFrames) );
    %CFrames
    fprintf(' %f %f %f %f', mean(nC),max(nC),min(nC),std(nC) );
    fprintf(' %f %f %f %f', mean(nC./nFrames),max(nC./nFrames),min(nC./nFrames),std(nC./nFrames) );
    fprintf(' %f %f %f %f %d\n', mean(nO),max(nO),min(nO),std(nO),nVideos );
end
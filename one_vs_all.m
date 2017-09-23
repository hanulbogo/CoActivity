% function zstip_KDE_BASED_segmentation_run_this()
% close all;
nodesize =10;
classlist =11:14;
len= nodesize*8;
nVideos=25;

prpath2 = './data/pr_res_one/';
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
hpath='./data/KDE_concat_hist_one/';
spath ='./data/seg_hists_one/';
dpath ='./data/KDE_density_map_one/';
ppath ='./data/shortest_res/';


% matlabpool(3);
for class = classlist
    for vi =1:25
        aidx = (class-1)*nVideos+vi;
        nnodes = (ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
        density = zeros(nnodes,1);
        fprintf('%s GT video vi [%d %d]\n',ucf_annotation{aidx}.label,ucf_annotation{aidx}.gt_start(1),ucf_annotation{aidx}.gt_end(1));
        gt_start =ceil(ucf_annotation{aidx}.gt_start(1)/nodesize);
        gt_end = ceil((ucf_annotation{aidx}.gt_end(1)-len)/nodesize)+1;
        for vj =1:25
            if vi<vj
                vidx =[vi,vj];
            elseif vi>vj
                vidx=[vj,vi];
            else
                continue;
            end
            Kpath ='./data/dists_one_normalized/';
            load([Kpath,num2str(class),'_',num2str(vidx(1)),'_',num2str(vidx(2)),'nodesize_',num2str(nodesize),'_len_',num2str(len),'_two_videos.mat']);%'dists'
            
            for v=vidx
                aidx =(class-1)*nVideos+v;
                nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
            end
            startidx =[0,0];
            endidx = [0,0];
        
            for i=1:2
                v=vidx(i);
                aidx =(class-1)*nVideos+v;
                startidx(i) = sum(nnodes(1:v-1))+1;
                endidx(i) = sum(nnodes(1:v));
            end
            Kern = PW_calc_Kern_from_dist_one_vid(dists);
            Kern= Kern(startidx(1):endidx(1), startidx(2):endidx(2));
            if vi>vj
                Kern= Kern';
            end
            tmpd = sum(Kern,2);
            tmpd = tmpd/max(tmpd);
            density = density +  sum(tmpd,2);
            
            figure(1);
            plot(1:length(density),density,'r-');
            hold on;
            plot(gt_start:gt_end,min(density)*ones(gt_end-gt_start+1,1), 'g-');
            hold off;
            drawnow();
            clear Kern tmpd nnodes;
        end
        figure(1);
        plot(1:length(density),density,'r-');
        hold on;
        plot(gt_start:gt_end,min(density)*ones(gt_end-gt_start+1,1), 'g-');
        ginput(1);
        hold off;
        drawnow();
    end

    
end

% matlabpool close;
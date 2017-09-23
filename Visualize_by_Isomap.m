% function Visualize_by_Isomap(class,len,nodesize,vididx) %data : N*D
Kpath ='./data/dists_one/';
class = 1;
len=75;
nodesize=5;
for vi=1:25
    for vj = vi+1:25
        vididx=[vi,vj];
        
        load([Kpath,num2str(class),'_',num2str(vididx(1)),'_',num2str(vididx(2)),'_two_videos_all.mat']);%'dists'
        D =zeros(size(dists{1}));
        Kern = PW_calc_Kern_from_dist_one_vid(dists);
        close all;
        for i=1:5
            D = D+dists{i};
        end
        load('./data/ucf_one_annotation.mat');%'ucf_annotation'
        
        nVideos=25;
        nnodes = zeros(nVideos,1);
        
        for v=vididx
            aidx =(class-1)*nVideos+v;
            nnodes(v) =(ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
        end
        total_nodes =  sum(nnodes);
        mask=zeros(total_nodes,total_nodes);
        for i=1:2
            v=vididx(i);
            startidx(i) = sum(nnodes(1:v-1))+1;
            endidx(i) = sum(nnodes(1:v));
            mask(startidx(i):endidx(i),startidx(i):endidx(i)) =1;
        end
        idx =1:total_nodes;
        figure;
        imshow(uint8(Kern*255));
        % D= D.*mask;
        % D(mask==1)=inf;
        % for i=1:length(D)
        %     D(i,i)=0;
        % % end
        figure;
        imshow(D,[]);
        options.dims = 1:2;
        aidx1= (class-1)*25+vididx(1);
        aidx2= (class-1)*25+vididx(2);
        itv(1,1)=ceil(ucf_annotation{aidx1}.gt_start(1)/nodesize);
        itv(1,2) = (ceil(ucf_annotation{aidx1}.gt_end(1)/nodesize)*nodesize - len)/nodesize +1;
        itv(2,1)=ceil(ucf_annotation{aidx2}.gt_start(1)/nodesize)+endidx(1);
        itv(2,2) = (ceil(ucf_annotation{aidx2}.gt_end(1)/nodesize)*nodesize - len)/nodesize +1+endidx(1);
        [Y, R, E] = Isomap(D, 'k', 15, options,startidx, endidx,itv);
    end
end
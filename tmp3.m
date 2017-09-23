nodesize =5;
classlist =1;
len= nodesize*15;
nVideos=25;
szmax =50;

prpath2 = './data/pr_res_one/';
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
% cpath ='./data/KDE_concat/';
hpath='./data/KDE_concat_hist_one/';
spath ='./data/seg_hists_one/';
dpath ='./data/KDE_density_map_one/';
rpath ='./data/Overlap_res/';
if ~exist(rpath,'dir')
    mkdir(rpath);
end
rpath2 ='./data/NonOver_res/';
if ~exist(rpath2,'dir')
    mkdir(rpath2);
end
rpath3 = './data/BOW_res/';
if ~exist(rpath3,'dir')
    mkdir(rpath3);
end


% matlabpool(2);
for class = classlist
    for vi =1:25
        for vj =1:25
            
            vididx =[vi,vj];
            
            close all;
            tic;
            lname =ucf_annotation{(class-1)*nVideos+1}.label;
            gt_start=ucf_annotation{(class-1)*nVideos+vj}.gt_start(1);
            gt_end=ucf_annotation{(class-1)*nVideos+vj}.gt_end(1);
            
            fprintf('Class %s\n',lname);
%             fprintf('Query : %d Domain : %d\n', vi,vj);
%             fprintf('GT : %d - %d\n', gt_start,gt_end);
            itv=Get_interval(class,vididx,nodesize,len);
            
            %%BlockWise Overlapping
            if ~exist([spath,ucf_annotation{(class-1)*nVideos+1}.label,'_nodesize_',num2str(nodesize),'_SEGHISTS_KDE_',num2str(len),'_',num2str(vididx(1)),'_gt.mat'],'file') || ~exist([spath,ucf_annotation{(class-1)*nVideos+1}.label,'_nodesize_',num2str(nodesize),'_SEGHISTS_KDE_',num2str(len),'_',num2str(vididx(2)),'_all.mat'],'file')
                KDE_make_segments_one_vid_with_itv(nodesize, class, len,vididx,itv);
            end
            M =Get_Dist_Map(class, vididx, nodesize, len);
            [p,q,blockD]=dp_query(M);
%             figure;
%             imshow(M,[])
            
%        
            blockDTWPath =zeros(size(M));
%             blockDTWPath(p,q)=blockDTWPath(p,q)+122;
            blockDTWPath(:,ceil(gt_start/nodesize):ceil((gt_end-len)/nodesize))=blockDTWPath(:,ceil(gt_start/nodesize):ceil((gt_end-len)/nodesize))+122;
            for i=1:length(p)
                blockDTWPath(p(i),q(i))=255;
            end
%             figure;
%             imshow(uint8(blockDTWPath))
%             hold on;
%             ginput(1);
%             hold off;
            blockcost =blockD(p(end),q(end))/sum(size(M));
            fprintf('Overlapping Block Cost :%f\n', blockcost);
%             fprintf('GT : %d - %d\n', gt_start,gt_end);
%             fprintf('Overlapping Block Result : %d - %d\n',(q(1)-1)*nodesize+1, (q(end)-1)*nodesize+len);
            overstart = (q(1)-1)*nodesize;
            overend =(q(end)-1)*nodesize+len;
            
            save([rpath,num2str(class),'_',num2str(vi),'_',num2str(vj),'.mat'],'overstart','overend');
                      
%             %% Blockwise Non_overlapping
%             for sz =1:0
%                 newnodesize = nodesize*sz;
%                 m=Get_Dist_Map3(class, vididx, newnodesize );
%                 [nonover_p,nonover_q,nonover_d]=dp_query(m);
%                 
%                 
%                 nonover_cost = nonover_d(nonover_p(end),nonover_q(end))/sum(size(m));
%                 
% %                 fprintf('non overlapping block cost :%f\n', nonover_cost);
% %                 fprintf('gt : %d - %d\n', gt_start,gt_end);
% %                 fprintf('non overlpaaing blocksize %d : %d - %d\n',newnodesize, (nonover_q(1)-1)*newnodesize+1 , nonover_q(end)*newnodesize );
%                 
%                 nonoverstart(sz) =(nonover_q(1)-1)*newnodesize+1;
%                 nonoverend(sz) =  nonover_q(end)*newnodesize;
%             end
%             save([rpath2,num2str(class),'_',num2str(vi),'_',num2str(vj),'.mat'],'nonoverstart','nonoverend');
            
            %% TCD with one sequence with GT
            tic;
            if ~exist([rpath3,num2str(class),'_',num2str(vi),'_',num2str(vj),'.mat'],'file');
                Exhaustive_search(class,vi,vj);
            end
            toc;
            
            Evaluate_overlap_better_per_pair(class,vi,vj,szmax);
            
        end
        
    end
end

for class = classlist
    Evaluate_overlap_better_per_class(class,szmax);
end

% for class = classlist
%     for vi=1:25
%         for vj=1:25
%             Evaluate_overlap_better_all(class,vi,vj,szmax);
%         end
%     end
% end
% matlabpool close;

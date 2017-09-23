function Evaluate_DTW_per_each_video(class,vidx,nodesize)
nclass=14;
tp=zeros(nclass,1);
rec_denom= zeros(nclass,1);
cnt=0;
% for class=1
    tp(class)=0;
    rec_denom(class)=0;
    for vi=vidx
        for vj=1:25
            if vi<vj
                vidx =[vi,vj];
            elseif vi>vj
                vidx=[vj,vi];
            else
                continue;
            end
            rec_denom(class)=rec_denom(class)+1;
            
            nVideos=25;
            ppath ='./data/shortest_res/';
            load('./data/ucf_one_annotation.mat');%'ucf_annotation'
            for v=1:2
                gt_start(v)=ucf_annotation{(class-1)*nVideos+vidx(v)}.gt_start(1);
                gt_end(v)=ucf_annotation{(class-1)*nVideos+vidx(v)}.gt_end(1);
            end
            
            load([ppath,num2str(class),'_',num2str(vidx(1)),'_',num2str(vidx(2)),'_nodesize_',num2str(nodesize),'.mat']);%
            %,'maxitv1','maxitv2');
            
            gt_map = zeros(sum(ucf_annotation{(class-1)*nVideos+vidx(1)}.nFrames),sum(ucf_annotation{(class-1)*nVideos+vidx(2)}.nFrames));
            gt_map(gt_start(1):gt_end(1),gt_start(2):gt_end(2)) =1;
%                         figure;
%                         imshow(gt_map,[]);
            
            res_map = zeros(sum(ucf_annotation{(class-1)*nVideos+vidx(1)}.nFrames),sum(ucf_annotation{(class-1)*nVideos+vidx(2)}.nFrames));
            maxitv1(2)=min(size(res_map,1),maxitv1(2));
            maxitv2(2)=min(size(res_map,2),maxitv2(2));
            res_map(maxitv1(1):maxitv1(2),maxitv2(1):maxitv2(2))=1;
            if vi <vj
                fprintf('%d %d\n',maxitv1(1), maxitv1(2));
                fprintf('%d %d\n',maxitv2(1), maxitv2(2));
            end
            if vj <vi
                fprintf('%d %d\n',maxitv2(1), maxitv2(2));
                fprintf('%d %d\n',maxitv1(1), maxitv1(2));
            end
%             figure;
%             imshow(res_map,[]);
%             hold on;
%             title([num2str(vidx(1)),' ',num2str(vidx(2))]);
%             ginput(1);
%             hold off;
%             close all;
            inter_map = gt_map.*res_map;
            union_map = gt_map+res_map;
            union_map(union_map>0) = 1;
%                         figure;
%                         imshow(inter_map,[]);
%                         figure;
%                         imshow(union_map,[]);

            over_ratio = sum(inter_map(:))/sum(union_map(:));
            cnt=cnt+1;
            all_over_ratio(cnt)=over_ratio;
            
            if over_ratio>=0.5
                tp(class)=tp(class)+1;
            end
            fprintf('Video %d, %d over_ratio : %f\n  ',vi,vj,over_ratio);
            gt_itv1 = gt_start(1):gt_end(1);
            over_itv1 =maxitv1(1):maxitv1(2);
            over_inter1 = intersect(gt_itv1,over_itv1);
            over_union1 = union(gt_itv1,over_itv1);
            
            over_ratio1 =length(over_inter1)/length(over_union1);
            fprintf('over_ratio in Video %d : %f ',vidx(1),over_ratio1);

            gt_itv2 = gt_start(2):gt_end(2);
            over_itv2 =maxitv2(1):maxitv2(2);
            over_inter2 = intersect(gt_itv2,over_itv2);
            over_union2 = union(gt_itv2,over_itv2);
            
            over_ratio2 =length(over_inter2)/length(over_union2);
            fprintf('over_ratio in Video %d : %f\n',vidx(2),over_ratio2);
            
            
            clear inter_map union_map;
        end
    end
    fprintf('Recall : %f\n',tp(class)/rec_denom(class));
    fprintf('Mean Overlapping ratio: %f\n',mean(all_over_ratio));
    
% end
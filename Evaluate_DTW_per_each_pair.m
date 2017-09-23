function Evaluate_DTW_per_each_pair(classlist,vidx,nodesize)
nclass=14;
tp=zeros(nclass,1);
rec_denom= zeros(nclass,1);
cnt=0;

nVideos=25;
ppath ='./data/shortest_res/';
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
for class=classlist
    tp(class)=0;
    rec_denom(class)=0;
    for vi=vidx(1)
        for vj=vidx(2)
            if vi<vj
                vidx =[vi,vj];
            elseif vi>vj
                vidx=[vj,vi];
            else
                continue;
            end
            rec_denom(class)=rec_denom(class)+1;

            for v=1:2
                gt_start(v)=ucf_annotation{(class-1)*nVideos+vidx(v)}.gt_start(1);
                gt_end(v)=ucf_annotation{(class-1)*nVideos+vidx(v)}.gt_end(1);
            end
            
            load([ppath,'res_',num2str(class),'_',num2str(vidx(1)),'_',num2str(vidx(2)),'_nodesize_',num2str(nodesize),'.mat']);
            %,'maxitv1','maxitv2');
            
            gt_map = zeros(sum(ucf_annotation{(class-1)*nVideos+vidx(1)}.nFrames),sum(ucf_annotation{(class-1)*nVideos+vidx(2)}.nFrames));
            gt_map(gt_start(1):gt_end(1),gt_start(2):gt_end(2)) =1;
            %             figure;
            %             imshow(gt_map,[]);
            
            res_map = zeros(sum(ucf_annotation{(class-1)*nVideos+vidx(1)}.nFrames),sum(ucf_annotation{(class-1)*nVideos+vidx(2)}.nFrames));
            maxitv1(2)=min(size(res_map,1),maxitv1(2));
            maxitv2(2)=min(size(res_map,2),maxitv2(2));
            res_map(maxitv1(1):maxitv1(2),maxitv2(1):maxitv2(2))=1;
            %             figure;
            %             imshow(res_map,[]);
            predenorm = sum(res_map(:));
            inter_map = gt_map.*res_map;
            union_map = gt_map+res_map;
            union_map(union_map>0) = 1;
            
            for i=1:2
                v=vidx(i);
                aidx =(class-1)*nVideos+v;
                gt_start(i) =ucf_annotation{aidx}.gt_start(1);
                gt_end(i) =ucf_annotation{aidx}.gt_end(1);
            end
%             figure;
%             imshow(res_map);
%             hold on;
%             drawbox([gt_start(2), gt_end(2)],[gt_start(1),gt_end(1)],'g-');
%             ginput(1);
%             hold off;
            
            %             figure;
            %             imshow(inter_map,[]);
            %             figure;
            %             imshow(union_map,[]);
            
            
            over_ratio = sum(inter_map(:))/sum(union_map(:));
            cnt=cnt+1;
            all_over_ratio(cnt)=over_ratio;
            prec = sum(inter_map(:))/predenorm;
            if over_ratio>=0.5
                tp(class)=tp(class)+1;
            end
            fprintf('Video %d, %d over_ratio : %f PRECISION %f\n',vi,vj,over_ratio,prec);
            clear inter_map union_map;
        end
    end
%     fprintf('Recall : %f\n',tp(class)/rec_denom(class));
%     fprintf('Mean Overlapping ratio: %f\n',mean(all_over_ratio));
    
end
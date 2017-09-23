function evaluate_TCD()
nclass=11;
tp=zeros(nclass,1);
rec_denom= zeros(nclass,1);
load('./data/ucf_one_annotation.mat');%'ucf_annotation'
nodesize=10;
rpath ='./data/TCD_res/';
nVideos=25;
cnt=0;

for class=1
    tp(class)=0;
    rec_denom(class)=0;
    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    for vi=1:25
        for vj=vi+1:25
            rec_denom(class)=rec_denom(class)+1;
            vidx=[vi,vj];
            nVideos=25;
            for v=1:2
                gt_start(v)=ucf_annotation{(class-1)*nVideos+vidx(v)}.gt_start(1);
                gt_end(v)=ucf_annotation{(class-1)*nVideos+vidx(v)}.gt_end(1);
            end
            
            load([rpath,lname,'_',num2str(vidx(1)),'_',num2str(vidx(2)),'.mat']);%resTCD

            gt_map = zeros(sum(ucf_annotation{(class-1)*nVideos+vidx(1)}.nFrames),sum(ucf_annotation{(class-1)*nVideos+vidx(2)}.nFrames));
            gt_map(gt_start(1):gt_end(1),gt_start(2):gt_end(2)) =1;
%             figure;
%             imshow(gt_map,[]);
            
            res_map = zeros(sum(ucf_annotation{(class-1)*nVideos+vidx(1)}.nFrames),sum(ucf_annotation{(class-1)*nVideos+vidx(2)}.nFrames));
            resTCD{1}.e1=min(size(res_map,1),resTCD{1}.e1);
            resTCD{1}.e2=min(size(res_map,2),resTCD{1}.e2);
            res_map(resTCD{1}.b1:resTCD{1}.e1,resTCD{1}.b2:resTCD{1}.e2)=1;
%             figure;
%             imshow(res_map,[]);
%             
            inter_map = gt_map.*res_map;
            union_map = gt_map+res_map;
            union_map(union_map>0) = 1;
%             figure;
%             imshow(inter_map,[]);
%             figure;
%             imshow(union_map,[]);
%             hold on;
%             ginput(1);
%             hold off;
%             close all;
            over_ratio = sum(inter_map(:))/sum(union_map(:));
            cnt=cnt+1;
            all_over_ratio(cnt)=over_ratio;
            if over_ratio>=0.5
                tp(class)=tp(class)+1;
            end
            fprintf('%f\n',over_ratio);
            clear inter_map union_map;
        end
    end
    fprintf('Recall : %f\n',tp(class)/rec_denom(class));
    fprintf('Mean Overlapping ratio: %f\n',mean(all_over_ratio));
end

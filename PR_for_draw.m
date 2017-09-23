function [final_recall, final_precision] = PR_for_draw(recall, precision)

final_recall = recall(1);
final_precision = precision(1);
cnt=1;
for i =2:length(recall)
    if recall(i)==recall(i-1)
        if final_precision(cnt)<precision(i)
            final_precision(cnt)=precision(i);
        end
    else 
        cnt=cnt+1;
        final_recall(cnt) = recall(i);
        final_precision(cnt)= precision(i);
    end
        
end
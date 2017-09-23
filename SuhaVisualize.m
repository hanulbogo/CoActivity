function SuhaVisualize(A)
alg_names = {'GroundTruths', 'AMC'};
nalg = length(alg_names);

vis_names = cell(nalg+2, 1);
vis_names{1} = '';
for aidx = 1:nalg
    vis_names{aidx+1} = alg_names{aidx};
end
vis_names{end} = '';


% colors
rcolor = zeros(nalg + 1, 3);
rcolor(1, :) = [.1 .7 .1] .* 0.9;
rcolor(2, :) = [.7 .1 .7] .* 0.9;
rcolor(end, :) = ones(1, 3) .* 0.8;


for aidx = 1:nalg
    det_result = A(aidx, :); 
    cc = bwconncomp(det_result);

    hold on;
    bar_height = (aidx / (nalg + 1));    
    for idx = 1:cc.NumObjects
        sttt = cc.PixelIdxList{idx}(1);
        endt = cc.PixelIdxList{idx}(end);
        
        line([sttt, endt], ones(1,2) .* bar_height, 'color', rcolor(aidx, :), 'LineWidth', 10);        
    end
    hold off;
%     axis auto;
    set(gca,'ytick', 0 : 1 / (nalg + 1) : 1)
    set(gca, 'YTickLabel', vis_names);
    
end
function [nlabels,Labels,Labels_per_points, Points_per_label,N_per_label]=online_connectivity_check(nlabels,Labels,Labels_per_points, Points_per_label,N_per_label,newpoint,blockidx)
%nlabels,Labels_per_points, Points_per_label,newpoint,blockidx)
% Labels: 1 if the label is used
% nlabels : the number of labels
% Labels_per_points : label for each point
% Points_per_label : list of points that belongs to each label, 
%                    max_n_Label X max_n_Points
% N_per_label : the number of points in each label
myidx = blockidx(newpoint(1),newpoint(2));
blockidx(newpoint(1),newpoint(2))=0;
startrow = max(newpoint(1)-1,1);
endrow = min(newpoint(1)+1,size(blockidx,1));
startcol = max(newpoint(2)-1,1);
endcol = min(newpoint(2)+1,size(blockidx,2));
selected =blockidx(startrow:endrow,startcol:endcol);
selected =selected(selected~=0);
newlabel=0;
if myidx==0
    fprintf('what?');
end
for i=1:length(selected)
    idx= selected(i);
    if Labels_per_points(idx)~=0
        if newlabel==0
            newlabel=Labels_per_points(idx);
            N_per_label(newlabel)=N_per_label(newlabel)+1;
            Points_per_label(newlabel,N_per_label(newlabel))=myidx;
            Labels_per_points(myidx)=newlabel;
        else
            if newlabel ~= Labels_per_points(idx)
                newn =N_per_label(Labels_per_points(idx))+N_per_label(newlabel);
                oldlabel = Labels_per_points(idx);
                Points_per_label(newlabel,1:newn)= [Points_per_label(newlabel,1:N_per_label(newlabel)),Points_per_label(oldlabel,1:N_per_label(oldlabel))];
                Labels_per_points(Points_per_label(oldlabel,1:N_per_label(oldlabel))) = newlabel;

                Points_per_label(oldlabel,:)= zeros(size(Points_per_label(oldlabel,:)));

                N_per_label(newlabel) = newn;
                N_per_label(oldlabel) = 0;
                Labels(oldlabel)=0;
                nlabels=nlabels-1;
            end
        end
    end
end
if newlabel==0
    candlabel =find(Labels==0);
    newlabel =candlabel(1);
    Points_per_label(newlabel,1) = myidx;
    N_per_label(newlabel)=N_per_label(newlabel)+1;
    Labels_per_points(myidx)=newlabel;
    Labels(newlabel)=1;
    nlabels=nlabels+1;
end

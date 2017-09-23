function img =UT_drawbox(img,rows,cols,copt,thickness)

rowval = [rows(1):rows(1)+thickness-1, rows(2)-thickness+1:rows(2)];
colval = [cols(1):cols(1)+thickness-1, cols(2)-thickness+1:cols(2)];

img(rowval,cols(1):cols(2),:) =repmat(copt,[thickness*2 cols(2)-cols(1)+1 1]);
img(rows(1):rows(2),colval,:) =repmat(copt,[rows(2)-rows(1)+1 thickness*2 1]);

% plot(rows, [cols(1),cols(1)],'-', 'Color',copt);
% 
% plot([rows(2),rows(2)], cols,'-', 'Color',copt);
% plot(rows, [cols(2),cols(2)], '-','Color',copt);
% plot([rows(1),rows(1)], cols,'-', 'Color',copt);

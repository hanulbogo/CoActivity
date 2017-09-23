function drawbox(rows,cols,copt)

plot(rows, [cols(1),cols(1)], copt);
plot([rows(2),rows(2)], cols, copt);
plot(rows, [cols(2),cols(2)], copt);
plot([rows(1),rows(1)], cols, copt);

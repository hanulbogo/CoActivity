
for class=1:4
    load(['./data/Kernel/',num2str(class),'.mat'],'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');
    figure;
    imshow(Kern,[]);
end
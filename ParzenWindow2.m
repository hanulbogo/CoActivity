function density=ParzenWindow2(class,TDATA, HOGDATA, HOFDATA, MBHxDATA, MBHyDATA) %data : N*D
% dist =vl_alldist2(data','CHI2');
Kern1 =PW_paralleldists(TDATA','CHI2'); 
Kern2 =PW_paralleldists(HOGDATA','CHI2'); 
Kern3 =PW_paralleldists(HOFDATA','CHI2'); 
Kern4 =PW_paralleldists(MBHxDATA','CHI2'); 
Kern5 =PW_paralleldists(MBHyDATA','CHI2'); 
Kern= ((((Kern1.*Kern2).*Kern3).*Kern4).*Kern5);
save(['./data/Kernel/',num2str(class),'.mat'],'Kern1','Kern2','Kern3','Kern4','Kern5','Kern');
figure; imshow(Kern,[]);
density =sum(Kern); %1*N
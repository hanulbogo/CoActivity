function OFD_gt_boxing(Kern,img,class,scale)
nVideos =25;

load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
copt2 ='r-';
copt ='y-';
gtpos = zeros(2*nVideos,1);
for i =1: nVideos
    idx = (class-1)*nVideos+i;
    for gti=1:2
        
        gtpos(2*(i-1)+gti) = 4*(i-1)+ucf_annotation{idx}.gt(gti);
        
    end
end

density=sum(Kern);
figure;
plot(1:length(density),density,'r*');
hold on;
for i=1:nVideos
    
    plot(gtpos((i-1)*2+1),density(gtpos((i-1)*2+1)),'b*');
    plot(gtpos((i-1)*2+2),density(gtpos((i-1)*2+2)),'b*');
end
hold off;

mimg = mean(img(:));


figure;
imshow(img,[]);
hold on;

for i =1: nVideos
    rows1 = [(gtpos(2*(i-1)+1)-1)*scale+1, (gtpos(2*(i-1)+1))*scale];
    rows2 = [(gtpos(2*(i-1)+2)-1)*scale+1, (gtpos(2*(i-1)+2))*scale];
    plot([1,length(img)],[4*i*scale,4*i*scale],'b-');
    plot([4*i*scale,4*i*scale],[1,length(img)],'b-');
    for j=i+1:nVideos
        cols1 = [(gtpos(2*(j-1)+1)-1)*scale+1, (gtpos(2*(j-1)+1))*scale];
        cols2 = [(gtpos(2*(j-1)+2)-1)*scale+1, (gtpos(2*(j-1)+2))*scale];
        if img(rows1(1), cols1(1))>mimg
            drawbox(rows1,cols1,copt);
        else
            drawbox(rows1,cols1,copt2);
        end
        if img(rows1(1), cols2(1))>mimg
            drawbox(rows1,cols2,copt);
        else
            drawbox(rows1,cols2,copt2);
        end
        if img(rows2(1), cols1(1))>mimg
            drawbox(rows2,cols1,copt);
        else
            drawbox(rows2,cols1,copt2);
        end
        if img(rows2(1), cols2(1))>mimg
            drawbox(rows2,cols2,copt);
        else
            drawbox(rows2,cols2,copt2);
        end
        
        if img(rows1(1), cols1(1))>mimg
            drawbox(cols1,rows1,copt);
        else
            drawbox(cols1,rows1,copt2);
        end
        if img(rows2(1), cols1(1))>mimg
            drawbox(cols1,rows2,copt);
        else
            drawbox(cols1,rows2,copt2);
        end
        if img(rows1(1), cols2(1))>mimg
            drawbox(cols2,rows1,copt);
        else
            drawbox(cols2,rows1,copt2);
        end
        if img(rows2(1), cols2(1))>mimg
            drawbox(cols2,rows2,copt);
        else
             drawbox(cols2,rows2,copt2);
        end
        
    end
end
ginput(1);
hold off;


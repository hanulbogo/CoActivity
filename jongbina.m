dpath ='C:\Users\JEC\Desktop\MOV\��ũ������\��ũ�� ����.HDTV.XViD-HANrel\��ũ�� ����.E05.101127.HDTV.XViD-HANrel.avi';


vid = VideoReader(dpath);

for i=1:vid.NumberOfFrames
    img = read(vid, i);
    
    imshow(img);
    title(sprintf('%d', i));
    drawnow;
end

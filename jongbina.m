dpath ='C:\Users\JEC\Desktop\MOV\矫农复啊电\矫农复 啊电.HDTV.XViD-HANrel\矫农复 啊电.E05.101127.HDTV.XViD-HANrel.avi';


vid = VideoReader(dpath);

for i=1:vid.NumberOfFrames
    img = read(vid, i);
    
    imshow(img);
    title(sprintf('%d', i));
    drawnow;
end

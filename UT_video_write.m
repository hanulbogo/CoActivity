function UT_video_write(nodesize,classlist,len,nCenter,th)
% nodesize= 10;
% classlist =1;
% len =80;
% nCenter =50;
load('./data/UT_annotation.mat');%'UT_annotation'
dpath ='./data/UT_density_map/';
vdpath ='./../YoutubeDataset/';
recpath = './data/UT_Res_Vid/';
if ~exist(recpath,'dir')
    mkdir(recpath);
end
dlist =dir(vdpath);
isdirlist =zeros(size(dlist));
for i=1:length(dlist)
    isdirlist(i) = isdir([vdpath,dlist(i).name]);
end
dlist = dlist(3:end);

nVideos=10;
nFrame =0;
% th=0.1;
for class =classlist
    lname =UT_annotation{(class-1)*nVideos+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_UT_',num2str(len),'_',num2str(nCenter),'_org.mat']); %density_map
    cname = dlist(class).name;   
    cpath = [vdpath,cname,'/'];
    rcpath = [recpath,cname,'/'];
    if ~exist(rcpath,'dir')
        mkdir(rcpath);
    end

    vlist = dir([cpath,'*.avi']);
  
  
    for v = 1: length(vlist)

        vname =vlist(v).name;
        vpath = [cpath, vname];
        fprintf('%s \n',vname);
        vobj = VideoReader(vpath);
        nFrame =vobj.NumberOfFrames;
        video = read(vobj);
        resvideo = video;
        
        figure(2);
        for f =1: nFrame
            coloropt =zeros(1,1,3);
            if density_map{v}(f)>th
                coloropt(1,1,1)= 255;%*max((1-density_map{v}(f))+0.5,1);
                coloropt(1,1,2) = 0;
                coloropt(1,1,3) = 0;
%                 
%                 coloropt(1,1,1)= 0;
%                 coloropt(1,1,2) = 0;
%                 coloropt(1,1,3) = 255*max(1,density_map{v}(f)+0.5);
            else
                coloropt(1,1,1)= 0;%255*max((1-density_map{v}(f))+0.5,1);
                coloropt(1,1,2) = 0;
                coloropt(1,1,3) = 255;
            end
%             coloropt(1,1,1) = 255*(1-density_map{v}(f));
%             coloropt(1,1,2) = 0;
%             coloropt(1,1,3) = 255*density_map{v}(f);
%             
            
            img =video(:,:,:,f);
            if density_map{v}(f)>th
                resvideo(:,:,:,f) = UT_drawbox(img, [1,size(img,1)],[1,size(img,2)],coloropt,10);         
            else
                resvideo(:,:,:,f)=img;
            end
            imshow(resvideo(:,:,:,f));
            title(sprintf('%d', f));
%             hold on;
            drawnow();
%             hold off;
            pause(0.01);
            
        end
%         close all;

        clear vobj;

        
        writerObj = VideoWriter([rcpath,vname]);
        open(writerObj);
        writeVideo(writerObj,resvideo)
        close(writerObj);
        clear writerObj;
    end
end
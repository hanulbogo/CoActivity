function OFD_video_write(nodesize,classlist,len,nCenter,nVideos)
% nodesize=10;
% classlist=9;
% len = 80;
% nCenter=50;
% nVideos=25;

load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'

dpath ='./data/OFD_density_map/';
vdpath ='./../UCF_OFD_TWO_SET/';
recpath = './data/OFD_Res_Vid/';
if ~exist(recpath,'dir')
    mkdir(recpath);
end
dlist =dir(vdpath);
isdirlist =zeros(size(dlist));
for i=1:length(dlist)
    isdirlist(i) = isdir([vdpath,dlist(i).name]);
end
dlist =dlist(isdirlist==1);
dlist = dlist(3:end);


nFrame =0;
th=0.4;
for class =classlist
    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    load([dpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenter),'_org.mat']); %density_map
    cname = dlist(class).name;
    cpath = [vdpath,cname,'/'];
    rcpath = [recpath,cname,'/'];
    if ~exist(rcpath,'dir')
        mkdir(rcpath);
    end
    lvlist = dir(cpath);
    isdirlist =zeros(size(lvlist));
    for i=1:length(lvlist)
        isdirlist(i) = isdir([cpath,lvlist(i).name]);
    end
    lvlist =lvlist(isdirlist==1);
    lvlist = lvlist(3:end);
    for l = 1: length(lvlist)
        lvpath = [cpath, lvlist(l).name,'/'];
        vlist = dir([lvpath,'*.avi']);
        rc =ucf_annotation{(class-1)*nVideos+l}.rc;
         nFrames = ucf_annotation{(class-1)*nVideos+l}.nFrames;
         writerObj = VideoWriter([rcpath,cname,lvlist(l).name,'.avi']);
         open(writerObj);
        for v = 1: length(rc)
            vidx = rc(v);
            vname =vlist(vidx).name;
            vpath = [lvpath, vname];
            fprintf('%s \n',vname);
            vobj = VideoReader(vpath);
            video = read(vobj);
            
            nFrame = nFrames(v);
            figure(2);
            for f =1: nFrame
                coloropt =zeros(1,1,3);
                if density_map{l}(f+sum(nFrames(1:v-1)))>th
                    coloropt(1,1,1)= 0;
                    coloropt(1,1,2) = 0;
                    coloropt(1,1,3) = 255;
                else
                    coloropt(1,1,1)= 255;
                    coloropt(1,1,2) = 0;
                    coloropt(1,1,3) = 0;
                end
                %             coloropt(1,1,1) = 255*(1-density_map{v}(f));
                %             coloropt(1,1,2) = 0;
                %             coloropt(1,1,3) = 255*density_map{v}(f);
                %
                
                img =video(:,:,:,f);
                
                img2 = UT_drawbox(img, [1,size(img,1)],[1,size(img,2)],coloropt,10);
                img2=imresize(img2,[240,320]);
                writeVideo(writerObj,img2);
                imshow(img2);
                hold on;
                drawnow();
                hold off;
                
            end
            %         close all;
            
            clear vobj;
        end
        
        
        
        close(writerObj);
        clear writerObj;
    end
end
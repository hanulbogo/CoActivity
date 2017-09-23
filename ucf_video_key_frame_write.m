% function ucf_video_key_frame_write(classlist,len,nCenter,th)
classlist = 1:101;
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'
dpath ='./data/ucf_density_map/';
vdpath ='./../UCF_OFD_TWO_SET/';
recpath = './data/ucf_key_frame/';
if ~exist(recpath,'dir')
    mkdir(recpath);
end

dlist =dir(vdpath);
isdirlist =zeros(size(dlist));
for i=1:length(dlist)
    isdirlist(i) = isdir([vdpath,dlist(i).name]);
end
dlist = dlist(3:end);

nVideos=25;
nFrame =0;
% th=0.1;
for class =classlist
    lname =ucf_annotation{(class-1)*nVideos+1}.label;
    cname = dlist(class).name;   
    cpath = [vdpath,cname,'/'];
    rcpath = [recpath,cname,'/'];
    if ~exist(rcpath,'dir')
        mkdir(rcpath);
    end
    
    vvlist = dir(cpath);
    vvlist = vvlist(3:end);
    
    for v = 1: length(vvlist)
        aidx = (class-1)*nVideos + v;
        vname =vvlist(v).name;
        vpath = [cpath, vname,'/'];
        
         rcvpath = [rcpath,vname,'/'];
        if ~exist(rcvpath,'dir')
            mkdir(rcvpath);
        end
        
        fprintf('%s \n',vname);
        nFrame = sum(ucf_annotation{aidx}.nFrames);
        f_start = ceil(nFrame/12);
        flist =f_start: ceil(nFrame/6):nFrame;
        cc=0;
        for sv = 1: 4
            svpath = [vpath ucf_annotation{aidx}.vnames(sv).name];
            fprintf('%s \n',svpath);
            vobj = VideoReader(svpath);
            nFrame =vobj.NumberOfFrames;
            video = read(vobj);
            
            flist2 = flist-sum(ucf_annotation{aidx}.nFrames(1:sv-1));
            flist2 =flist2(flist2>0);
            flist2 = flist2(flist2<ucf_annotation{aidx}.nFrames(sv));
            for ff = flist2
                img =uint8(video(:,:,:,ff));
                cc=cc+1;
                imwrite(img, [rcvpath, num2str(cc),'.jpg']);
            end
            clear vobj;
        end
       
        
        
        %         writerObj = VideoWriter([rcpath,vname]);
        %         open(writerObj);
        %         writeVideo(writerObj,resvideo)
        %         close(writerObj);
        %         clear writerObj;
    end
    
end
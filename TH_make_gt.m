function TH_make_gt()

aroot ='D:/Coactivity/TH14_Temporal_annotations_test/';
load([aroot 'test_set_meta.mat']); %test_videos
apath =[aroot 'annotation/'];
clist= dir([apath '*.txt']);
nvid =length(test_videos);
aidx =0;
nVideolist=zeros(length(clist),1);
for cc= 1:length(clist)
   fid=fopen([apath clist(cc).name],'r');
   atmp=textscan(fid,'%s%f%f');
   fclose(fid);
   ntmp =length(atmp{1});
   name_tmp =atmp{1};
   gt_start_tmp =atmp{2};
   gt_end_tmp =atmp{3};
   prev_name =[];
   
   cvidx =0;
   gidx=1;
   for aa =1: ntmp
       if strcmp(prev_name,name_tmp{aa})
           gidx = gidx+1;
           TH_annotation{aidx}.gt_start(gidx) = floor(TH_annotation{aidx}.fps*gt_start_tmp(aa));
           TH_annotation{aidx}.gt_end(gidx) = floor(TH_annotation{aidx}.fps*gt_end_tmp(aa));
       else
           aidx= aidx+1;
           cvidx = cvidx+1;
           gidx=1;
           TH_annotation{aidx}.name = name_tmp{aa};
           TH_annotation{aidx}.label = clist(cc).name(1:end-9);
           for vv =1:nvid
               if strcmp(test_videos(vv).video_name,name_tmp{aa})
                   TH_annotation{aidx}.fps =test_videos(vv).frame_rate_FPS;
                   TH_annotation{aidx}.nFrames= floor(test_videos(vv).video_duration_seconds*TH_annotation{aidx}.fps);
                   break;
               end
           end
           TH_annotation{aidx}.gt_start(gidx) = floor(TH_annotation{aidx}.fps*gt_start_tmp(aa));
           TH_annotation{aidx}.gt_end(gidx) = floor(TH_annotation{aidx}.fps*gt_end_tmp(aa));
           
       end
       
       prev_name =name_tmp{aa};
   end
   nVideolist(cc)= cvidx;
    
end


  

save('./data/TH_nVideos.mat','nVideolist');%
save('./data/TH_annotation.mat','TH_annotation');%'TH_annotation'

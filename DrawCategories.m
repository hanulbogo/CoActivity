function DrawCategories()
load('./data/UT_annotation.mat');%'UT_annotation'
load('./data/UT_nVideos.mat');
dpath ='./data/UT_density_map/';
vdpath ='./../AddDataset/';
recpath = './data/UT_Key_Frames/';
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
Nkey=5;

% th=0.1;
for class =1:11
    nVideos =nVideolist(class);
%     conimg = cell(nVideos ,1);
    cname = dlist(class).name;
    cpath = [vdpath,cname,'/'];
    rcpath = [recpath,cname,'/'];
    if ~exist(rcpath,'dir')
        mkdir(rcpath);
    end
    vlist = dir([cpath,'*.avi']);
    
    stepsize=5;
    
    for v = 1: length(vlist)
        startidx =1;
        aidx = sum(nVideolist(1:(class-1)))+v;
        vname =vlist(v).name;
        vpath = [cpath, vname];
        fprintf('%s \n',vname);
        vobj = VideoReader(vpath);
        nFrame =vobj.NumberOfFrames;
        video = read(vobj);
        [row, col,~,~]=size(video);
        scale =(180/row);
%         fstart = 1;
%                  flist =[99,330,420,680,1963,2300];%drum 12 6
%                  flist =[99,330,420,680,1963];%drum 12 5
%                     flist =[156 494 648 1077 1436 1795];%drum 8 6
%                     flist = [367 648 1077 1436 1795];%drum 8 5
                 flist =ceil(nFrame/(Nkey*2)): ceil(nFrame/(Nkey)):nFrame;
                 if length(flist)<Nkey
                     flist = [10,flist];
                 end
        for ff =1:length(flist)
            f= flist(ff);
            %         f = ceil((UT_annotation{aidx}.gt_start(1)+UT_annotation{aidx}.gt_end(1))/2);
            img =video(:,:,:,f);
            img =imresize(img,scale);
            img=insertText(img,[10 10],num2str(f),'FontSize',ceil(28*Nkey/5),'TextColor','yellow','BoxColor','black','BoxOpacity',0.7);
            conimg(1:180,startidx:startidx+size(img,2)-1,1:3) = img;
            if f~=flist(end)
            conimg(1:180,startidx+size(img,2):startidx+size(img,2)+stepsize-1,1:3)=255;
            end
            figure(1);imshow(uint8(conimg));
%             pause;
            
            startidx = startidx+size(img,2)+stepsize;
        end
        imwrite(conimg, [rcpath,vname,'_',num2str(Nkey),'.tiff']);
        clear conimg;
        %             imwrite(img, [rcpath,vname,'_',num2str(f),'.jpg']);
        
        
        clear vobj;
        
        
    end
end
% fullimg = zeros(2025,3240, 3);
% startidx =1;
% for class=1:11
%     dest = imresize(conimg{class},[180,3240]);
%     fullimg(startidx:startidx+180-1,:,:) =dest;
%     figure(1);imshow(uint8(fullimg));
%     startidx = startidx +5+180;
% end
% fullimg2 =uint8(fullimg);
% fullimg2 = insertText(fullimg2,[100 50],'heyheyhey') ;
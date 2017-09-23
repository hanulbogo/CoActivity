function mocap_downsample()
cpath = './data/mocap_codes/';
cpath2 = './data/mocap_codes_down_4/';
if ~exist(cpath2,'dir');
    mkdir(cpath2);
end
ass=0;
for vidx=1:14
    load([cpath,num2str(vidx,'%02d'),'_code.mat']);
    len = length(ass);
    idx = 1:4:len;
    ASS= ass(idx);
    save([cpath2,num2str(vidx,'%02d'),'_code.mat'],'ASS');
end
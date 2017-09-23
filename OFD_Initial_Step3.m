% OFD_make_new_ann();  
% OFD_make_con_feats();
cpath ='./data/OFD_concat/';
hpath='./data/OFD_concat_hist/';
% fpath ='F:/伙己苞力 内靛沥府/DownloadFiles/features/';

fpath ='D:/Share_with_linux/DenseTrajectory_OFD/features/';
spath ='./data/OFD_seg_hists/';
dmpath ='./data/OFD_density_map/';
npath ='./data/OFD_L1NORM_seg_hists/';
classlist =67:101;
nodesize=10;
len=80;
NC=7;
nodesize=10;
% matlabpool(3);
for class =classlist
%     OFD_make_con_feats_50(1,class,fpath,cpath);
    OFD_make_con_feats_NC(2,class,fpath,cpath,NC);
   
    OFD_make_nodes(nodesize,class,cpath,hpath,NC);
%     OFD_make_nodes_org(nodesize,class,cpath,hpath);
end
% matlabpool close ;
% OFD_RUN_THIS_ofdorgNCenters(classlist,spath,npath,nodesize, len);
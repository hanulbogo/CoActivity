% ������ ����Ǿ��ִ� ����
dpath ='./../UCF_OFD_TWO_SET/';

% �� ������ feature�� ���� �Ǿ��ִ� ����
fpath ='F:\YDH\features\';

%���� 4���� �������� feature�� ������ �����ϴ� �ܰ�
cpath ='./data/OFD_concat/';

%����� video�� sliding window�� step size�� ���� histogram�������
hpath='./data/OFD_concat_hist/';

%sliding window�� ���� ����� sub-video�� histogram�� �����ϴ� ����
spath ='./data/OFD_seg_hists/';

%sliding window�� ���� ����� sub-video�� histogram�� L1-Normalization�� �� ������ �����ϴ� ����
npath ='./data/OFD_L1NORM_seg_hists/';

%�� Video���� Density���� ����Ǵ� ����
dmpath ='./data/OFD_density_map/';

%4���� ������ � ������ ��� ������ �����ϰ�(����) ��������� Evalutation�� ���� Ground Truth�� �����ϴ� �ܰ�
% OFD_make_new_ann(dpath);  
% �̹� �����ؼ� ������ ������, �����Ϸ��� video�� �ʿ��ѵ� video�� ��� ÷���ϱ⿡ �뷮�� Ŀ�� ����.
% �׽�Ʈ�� Youtube Dataset Test Code�� �̿��ϸ� ������ ������ ���� ����.

%101���� class
classlist = 1:101;

%SlidingWindow stepsize
nodesize=10;

%Subvideo frame length
len=nodesize*3;
% 
% for class =classlist
%     
%     %DenseSampling�Ҷ� ���� trajectory�� �ֺ����� ������ ���� ���� ����� ���� 2�̻��϶� feature�� �̿�
%     SamplingThreshold =2;
%     %4���� ������ feature��  OFD_make_new_ann���� ������ ������� �̾� ���̴� �ܰ�
%     OFD_make_con_feats_50(SamplingThreshold ,class,fpath, cpath);
%     
%     %4���� ������ SlidingWindow step size ũ��� ������ histogram�� ����
%     %(sub-video�� histogram�� ������ ����� ���� ���)
%     %�츮�� ������ Camera motion invariant sampling ������� ���� feature
%     OFD_make_nodes(nodesize,class,cpath, hpath);
%     
%     %DenseTrajectory feature�� orginal sampling������� ���� feature
%     OFD_make_nodes_org(nodesize,class,cpath, hpath);
% end

% co-activity�� ã�� function
CoActDiscovery_Main(classlist,hpath,spath, dmpath, npath,nodesize, len)
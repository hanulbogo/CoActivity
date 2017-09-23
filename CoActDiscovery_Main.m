function CoActDiscovery_Main(classlist,hpath,spath, dmpath, npath,nodesize, len)

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
%���� ����(�̸�, ��ü �����Ӽ� ��) �ε�
load('./data/OFD_TWO_annotation.mat');%'ucf_annotation'

% hpath='./data/OFD_concat_hist/';
% spath ='./data/OFD_seg_hists/';
% dmpath ='./data/OFD_density_map/';
% npath ='./data/OFD_L1NORM_seg_hists/';
% dpath ='./data/OFD_density_map/';

%ī�װ��� ���� ����
nVideos=25;

%BoW�� Codeword ����
% nCenters =50;
nCenters =4000;
% nCenter =4000;
% nc=1;
global mname;
mlist ={'AMC','AMC-','PR'};
for mm =1:3
    
    mname = mlist{mm};
    fprintf('%s\n',mname);
    dmpath =['./data/OFD_density_map/', mname '/'];
    %classlist�� �ִ� ��� class�鿡 ���� co-activity����
    for class =  classlist
        close all;
        
        lname =ucf_annotation{(class-1)*nVideos+1}.label;
        
        % label ���
        fprintf('%s ',lname);
        
        %% Camera Motion Invariant Sampling�� ���� ����� co-activity
        %         L1Normalization_SEGHISTS(nodesize, class, len,spath, npath,2,7) % flag =1 ofd flag =2 org
%         if ~exist([dmpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenters),'_org.mat'],'file')
            load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_OFD_',num2str(len),'L1Norm_org.mat']); %NDATA
            density= UCF_AMC(TDATA{7},HOGDATA{7},HOFDATA{7},MBHxDATA{7},MBHyDATA{7},class,len,nodesize,NDATA,nCenters) ;
            density(NDATA<len*0.5) =0;
            OFD_make_weight_map_org(nodesize, class, len,density,nCenters,dmpath);
            load([dmpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenters),'_org.mat']); %density_map
%         else
%             load([dmpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenters),'_org.mat']); %density_map
            Threshold=UCF_plot_density_map(density_map,nVideos, class);
             OFD_plot_denstiy_map_org(nodesize, class, len,nCenters,Threshold);
%         end
        %�� Video�� Density�� �׸�
%                
%                 pause;

        %PR curve�� �׸���, Average Precision ���
        %     OFD_evaluate_per_frame_org(nodesize, class, len,nCenters);
        
        fprintf('\n');
    end
end
end
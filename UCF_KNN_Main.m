function UCF_KNN_Main(classlist,hpath,spath, dmpath, npath,nodesize, len)

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
nc=1;
global K;
for kk =1:10
    K =0.1*kk;
    
    fprintf('\n\n%f\n',K);
    %classlist�� �ִ� ��� class�鿡 ���� co-activity����
    for class = classlist
        close all;
        
        lname =ucf_annotation{(class-1)*nVideos+1}.label;
        
        % label ���
        fprintf('%s ',lname);
        
        %% Camera Motion Invariant Sampling�� ���� ����� co-activity
        
        load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_OFD_',num2str(len),'L1Norm_org.mat']); %NDATA
        density= UCF_KNN(class,len,nodesize,NDATA,nCenters) ;
        density(NDATA<len*0.5) =0;
        
        OFD_make_weight_map_org(nodesize, class, len,density,nCenters);
        load([dmpath,lname,'_nodesize_',num2str(nodesize), '_DENSITY_MAP_OFD_',num2str(len),'_',num2str(nCenters),'_org.mat']); %density_map
        Threshold=UCF_plot_density_map(density_map,nVideos, class);
        %�� Video�� Density�� �׸�
        OFD_plot_denstiy_map_org(nodesize, class, len,nCenters,Threshold);
        
        %PR curve�� �׸���, Average Precision ���
        %     OFD_evaluate_per_frame_org(nodesize, class, len,nCenters);
        
        fprintf('\n');
    end
end
%
%
nodesize =10;

% len= nodesize*8;
len= nodesize*3;

load('./data/HW_annotation.mat');%'HW_annotation'
load('./data/HW_nVideos.mat');%nVideolist

classlist =1:length(nVideolist);%:12;%11:12;%6%[1,2,3,4,7];
% cpath ='./data/HW_feat/';
hpath='./data/HW_hist/';
spath ='./data/HW_seg_hists/';
dpath ='./data/HW_density_map/';
distpath = './data/HW_dists/';
npath ='./data/HW_L1NORM_seg_hists/';
% matlabpool(3);
% nVideos=10;
% nCenters =[50,125,250,500,1000,2000,4000];
nCenters =4000;
% nc=;
NC =7;
cumacc = zeros(1001,1);
close all;

% nVideos=10;
didx =[1,3,10,11,12];

global tempconst;
% for tc =1%[2 3 4 5 6 7 8 9 10 ]%10 is the best
%     tempconst =tc;
%         fprintf('\n\n%f\n',tempconst);
    nc=7;
    
    ptemp=0;
    rtemp=0;
    ftemp=0;
    
%     Precision = cell(12,1);
%     Recall = Precision;
%     Fmeasure = Precision;
mlist={'AMC','AMC-','PR'};
    
for mm=[2, 3,1]
    mname=mlist{mm};
    fprintf('%s\n',mname);
    for Ncomb = 2%:10
        for class =1:8%classlist
            close all;
            nVideos=nVideolist(class);
            AllComb= combntns(1:nVideos,Ncomb );
            lname =HW_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s ',lname);
            
            load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_HW_',num2str(len),'L1Norm_org.mat']); %NDATA
            
            load([distpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenters),'_org.mat']); %dists{12}
            for i=1:12
                dists{i}(NDATA<len*.5,:)=2;
                dists{i}(:,NDATA<len*.5)=2;
            end
            
            nnodes = zeros(nVideos,1);
            for v=1:nVideos
                aidx =sum(nVideolist(1:(class-1)))+v;
                nnodes(v) =(ceil(HW_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
            end
            
            mask= ones(size(dists{1}));
            
            %% 같은 video 사이의 connection 제거 mask
            for v=1:nVideos
                startidx = sum(nnodes(1:v-1))+1;
                endidx = sum(nnodes(1:v));
                mask(startidx:endidx,startidx:endidx) =0;
            end
            %normalization을 하기때문에 여기서 normalization을 하면.... 결과가 달라지네......!!
            
            Precision{class}= zeros(length(AllComb),1);
            Recall{class}= zeros(length(AllComb),1);
            Fmeasure{class}= zeros(length(AllComb),1);
            
            for cc =1:100%size(AllComb,1)
                                 
                Comb = AllComb(cc,:);
%                 fprintf('%d %d ',Comb(1),Comb(2));
                allidx =[];
                for aa = 1: length(Comb)
                    startidx(aa) = sum(nnodes(1:(Comb(aa)-1)))+1;
                    endidx(aa) = startidx(aa) -1 + nnodes(Comb(aa));
                    allidx = [allidx,startidx(aa):endidx(aa)];
                end
                mask2 = mask(allidx,allidx);
                NDATA2= NDATA(allidx);
                Kern =KernMaskidx(dists,didx,mask2,allidx);
                Kern = Kern.*mask2;
                Kern(NDATA2<len*.5,:)=0;
                Kern(:,NDATA2<len*.5)=0;
                
                density= HW_N_AMC(Kern,mask2,len,nodesize,NDATA2, mname) ;
%                 density= HW_N_PR(Kern,mask2,len,nodesize,NDATA2, nnodes,AllComb(cc,:)) ;
                density_map=HW_N_DensityMap(nnodes,nodesize, class, len,density,AllComb(cc,:));
                
                [Precision{class}(cc), Recall{class}(cc), Fmeasure{class}(cc),Threshold]=HW_N_plot_detection(density_map, class,AllComb(cc,:));
%                [Precision{class}(cc), Recall{class}(cc), Fmeasure{class}(cc),Threshold]= HW_SuhaVisualizeMine(density_map, class,AllComb(cc,:));
%                         HW_plot_denstiy_map_org(density_map,nodesize, class, len,4000,Threshold);
                %                 HW_evaluate_per_frame_org(nodesize, class, len,nCenters);
                %                 HW_video_write(nodesize,class,len,nCenters,Threshold);
%                 pause;
                close all;
                
            end
        end
        fprintf('\n');
        for class =classlist
            lname =HW_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s %f %f %f\n',lname,mean(Precision{class}),mean(Recall{class}), mean(Fmeasure{class}));
            %         fprintf('%s %f %f %f\n',lname,mean(Precision{class}),mean(Recall{class}), mean(Fmeasure{class}));
        end
    end
end
% matlabpool close;
% [val th] =max(cumacc);
% fprintf('org_average acc : %.2f theshold th %d\n', val/length(classlist), th);
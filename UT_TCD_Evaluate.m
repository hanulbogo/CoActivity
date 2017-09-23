%
%
nodesize =10;
classlist =[1:11];%:12;%11:12;%6%[1,2,3,4,7];
% len= nodesize*8;
len= nodesize*3;

load('./data/UT_annotation.mat');%'UT_annotation'
load('./data/UT_nVideos.mat');%nVideolist

% cpath ='./data/UT_feat/';
hpath='./data/UT_hist/';
spath ='./data/UT_seg_hists/';
dpath ='./data/UT_density_map/';
distpath = './data/UT_dists/';
npath ='./data/UT_L1NORM_seg_hists/';
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
    for Ncomb = 2%:10
        for class =1:11%classlist
            close all;
            nVideos=nVideolist(class);
%             nVideos=10;
            
            AllComb= combntns(1 :nVideos,Ncomb );
            lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s ',lname);
            
            load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_UT_',num2str(len),'L1Norm_org.mat']); %NDATA
            
            load([distpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenters),'_org.mat']); %dists{12}
            for i=1:12
                dists{i}(NDATA<len*.5,:)=2;
                dists{i}(:,NDATA<len*.5)=2;
            end
            
            nnodes = zeros(nVideos,1);
            for v=1:nVideos
                aidx =sum(nVideolist(1:(class-1)))+v;
                nnodes(v) =(ceil(UT_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
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
            
            for cc = 1:length(AllComb)
                                 
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
                
%                 density= UT_N_AMC(Kern,mask2,len,nodesize,NDATA2, nnodes,AllComb(cc,:)) ;
%                 density= UT_N_PR(Kern,mask2,len,nodesize,NDATA2, nnodes,AllComb(cc,:)) ;
%                 density_map=UT_N_DensityMap(nnodes,nodesize, class, len,density,AllComb(cc,:));
                
%                 [Precision{class}(cc), Recall{class}(cc), Fmeasure{class}(cc),Threshold]=UT_N_plot_detection(density_map, class,AllComb(cc,:));
               [Precision{class}(cc), Recall{class}(cc), Fmeasure{class}(cc)]= EvalTCD( class,AllComb(cc,:));
                %         UT_plot_denstiy_map_org(nodesize, class, len,nCenters,Threshold);
                %                 UT_evaluate_per_frame_org(nodesize, class, len,nCenters);
                %                 UT_video_write(nodesize,class,len,nCenters,Threshold);
                %         pause;
                close all;
                
            end
        end
        fprintf('\n');
        for class =classlist
            lname =UT_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s %f %f %f\n',lname,mean(Precision{class}),mean(Recall{class}), mean(Fmeasure{class}));
            %         fprintf('%s %f %f %f\n',lname,mean(Precision{class}),mean(Recall{class}), mean(Fmeasure{class}));
        end
    end
% end
% matlabpool close;
% [val th] =max(cumacc);
% fprintf('org_average acc : %.2f theshold th %d\n', val/length(classlist), th);
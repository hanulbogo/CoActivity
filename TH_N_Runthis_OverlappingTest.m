%
%
nodesize =10;
classlist =[1:11];%:12;%11:12;%6%[1,2,3,4,7];
% len= nodesize*8;

% len= nodesize*6;

load('./data/TH_annotation.mat');%'TH_annotation'
load('./data/TH_nVideos.mat');%nVideolist

% cpath ='./data/TH_feat/';
hpath='./data/TH_hist/';
spath ='./data/TH_seg_hists/';
dpath ='./data/TH_density_map/';
distpath = './data/TH_dists/';
npath ='./data/TH_L1NORM_seg_hists/';
% matlabpool(3);
% nVideos=10;
% nCenters =[50,125,250,500,1000,2000,4000];
nCenters =4000;
% nc=;
NC =7;
cumacc = zeros(1001,1);
close all;

didx =[1,3,10,11,12];
nc=7;

ptemp=0;
rtemp=0;
ftemp=0;
for stepsize=[10,20 ,30]
    fprintf('%d \n',stepsize);
    for Ncomb = 2
        for class =1:length(nVideolist)
            close all;
            nVideos=nVideolist(class);
            
            AllComb= combntns(1 :nVideos,Ncomb );
            lname =TH_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s ',lname);
            
            load([npath,lname,'_nodesize_',num2str(nodesize), '_DATA_TH_',num2str(len),'L1Norm_org.mat']); %NDATA
            
            load([distpath, 'Dists_class_',num2str(class),'_nodesize_',num2str(nodesize),'_len_',num2str(len),'_',num2str(nCenters),'_org.mat']); %dists{12}
            for i=1:12
                dists{i}(NDATA<len*.5,:)=2;
                dists{i}(:,NDATA<len*.5)=2;
            end
            
            nnodes = zeros(nVideos,1);
            for v=1:nVideos
                aidx =sum(nVideolist(1:(class-1)))+v;
                nnodes(v) =(ceil(TH_annotation{aidx}.nFrames/nodesize)*nodesize - len)/nodesize +1;
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
                    allidx = [allidx,startidx(aa):stepsize/nodesize:endidx(aa)];
                end
                mask2 = mask(allidx,allidx);
                NDATA2= NDATA(allidx);
                
                mask2(NDATA2<len*.5,:)=0;
                mask2(:,NDATA2<len*.5)=0;
                
                Kern =KernMaskidx(dists,didx,mask2,allidx);
                Kern = Kern.*mask2;
                Kern(NDATA2<len*.5,:)=0;
                Kern(:,NDATA2<len*.5)=0;
                density= TH_N_AMC(Kern,mask2,len,nodesize,NDATA2, nnodes,AllComb(cc,:)) ;
                
                density_map=TH_N_DensityMap_Stepsize(stepsize,nnodes,nodesize, class, len,density,AllComb(cc,:));
                
                [Precision{class}(cc), Recall{class}(cc), Fmeasure{class}(cc),Threshold]=TH_N_plot_detection(density_map, class,AllComb(cc,:));
                close all;
                
            end
        end
        fprintf('\n');
        for class =classlist
            lname =TH_annotation{sum(nVideolist(1:(class-1)))+1}.label;
            fprintf('%s %f %f %f\n',lname,mean(Precision{class}),mean(Recall{class}), mean(Fmeasure{class}));
           end
    end
    
end
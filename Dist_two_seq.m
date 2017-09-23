function sim = Dist_two_seq(class,vididx, itv1, itv2,nodesize,len)

%      CHI2   sum (X  - Y).^2 ./ (X + Y)
    load('./data/ucf_one_annotation.mat');
    hpath = './data/KDE_concat_hist_one/';
    vi = vididx(1);
    vj = vididx(2);
    aidx = (class-1)*25+vi;
    fprintf('%s\n',[ucf_annotation{aidx}.label,'_',num2str(vi),'_',num2str(vj)]);
    load([hpath,ucf_annotation{aidx}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
    %, 'Thists','HOGhists','HOFhists','MBHxhists','MBHyhists');
    %             load('./../data/KDE_concat_hist_one/Billiards_01_nodesize_5_HISTS.mat');
    s1 = [Thists, HOGhists,HOFhists,MBHxhists,MBHyhists];
    
    h1 =sum(s1(itv1(1):itv1(2)+(len/nodesize)-1,:));
    h1 = h1/sum(h1);

    nnodes = (ceil(sum(ucf_annotation{aidx}.nFrames)/nodesize)*nodesize - len)/nodesize +1;
    clear Thists HOGhists HOFhists MBHxhists MBHyhists;
    itv2 = itv2- nnodes;
    
    aidx2 = (class-1)*25+vj;
    load([hpath,ucf_annotation{aidx2}.name,'_nodesize_',num2str(nodesize),'_HISTS.mat']);
    %             load('./../data/KDE_concat_hist/Billards_24_nodesize_5_HISTS.mat');
    s2= [Thists, HOGhists,HOFhists,MBHxhists,MBHyhists];
    
    h2 =sum(s2(itv2(1):itv2(2)+(len/nodesize)-1,:));
    h2 = h2/sum(h2);
    sumh = h1+h2;
    sumh(sumh==0)=1;
    sim =-sum(((h1-h2).^2)./(sumh));
    
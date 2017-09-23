function evaluate_for_each_class_one_vid()
for class=1:14
    tp_all=zeros(101,1);
    precisiondenom_all =0;
    recalldenom_all=0;
    precision_all = zeros(101,1);
    recall_all = zeros(101,1);
    
    nVideos=25;
    prpath= './data/pr_curve_img_one/';
    prpath2 = './data/pr_res_one/';
    load('./data/ucf_one_annotation.mat');%'ucf_annotation'
    
    
    lname =ucf_annotation{(class-1)*25+1}.label;
    nth=101;
    for vi =1:nVideos
        for vj = vi+1:nVideos
            load([prpath2, 'PR_',lname,'_',num2str(vi),'_',num2str(vj),'.mat']);
            %'tp','precisiondenom','recalldenom','precision','recall'
            tp_all =tp_all+tp;
            precisiondenom_all =precisiondenom_all+ precisiondenom;
            recalldenom_all=recalldenom_all+recalldenom;
        end
    end
    precision = tp_all./precisiondenom_all;
    recall = tp_all/recalldenom_all;
    precision(isnan(precision))=0;
    
    [sorted_recall recall_idx]=sort(recall);
    sorted_precision = precision(recall_idx);
    ap = sorted_recall(1)*sorted_precision(1);
    for t= 2:nth
        delta_r=sorted_recall(t)-sorted_recall(t-1);
        ap=ap+delta_r*sorted_precision(t);
    end
    h=figure;
    title([lname,' AP : ',num2str(floor(ap*100))]);
    hold on;
    axis([0 1 0 1]);
    plot(recall, precision,'ro-');
    hold off;
    % fprintf('%f , %f\n',ap*100, sorted_precision(end)*100);
    print(h,'-dpdf',[prpath,lname,'_all.pdf']);
    % close(h);
    fprintf('class %d %s %f %f\n',class,lname,ap,min(sorted_precision(sorted_recall==1)));
end
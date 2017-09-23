%D:\Share_with_linux\UCF_OFD_TWO_SET\FrontCrawl\13% v_Rowing_g05_c01_1.feats','./copyfeatures/');
%D:\Share_with_linux\UCF_OFD_TWO_SET\CricketBowling\07% copyfile('./features/v_CricketBowling_g07_c02_1.
vname ='v_CricketBowling_g07_c02.avi';
label = 'CricketBowling';
num = 07;
flag = 1;

if flag==1

order =['DenseTrajectory_org.exe ./../UCF_OFD_TWO_SET/',label,'/',num2str(num,'%02d'),'/',vname,' -o ./features/',vname(1:end-4),'_1.feats']

else
    order =['DenseTrajectory_flipped.exe ./../UCF_OFD_TWO_SET/',label,'/',num2str(num,'%02d'),'/',vname,' -o ./features/',vname(1:end-4),'_2.feats']
end
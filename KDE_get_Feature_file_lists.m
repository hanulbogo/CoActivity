fid = fopen('./filelist.txt','w');

fpath = 'd:\Share_with_linux\dense_flipped_sampling_ofd\SampledFeatures\';
dirlist =dir(fpath);
dirlist = dirlist(3:end);
for i=1:length(dirlist)
    s =[fpath,dirlist(i).name];
    fprintf(fid,'%s\n',s);
end
fclose(fid);
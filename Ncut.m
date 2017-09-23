function Ncut(Kern,len,mask,nnodes,vididx)
close all;
% gen_nn_distance(data, num_neighbors, block_size, save_type)
% 
%            -data:
%                N-by-D data matrix, where N is the number of data, D is the number of dimensions.
%            -num_neighbors:
%                Number of nearest neighbors.
%            -block_size:
%                Block size for partitioning the data matrix. We process the data matrix in a
%                divide-and-conquer manner to alleviate memory use. This is useful for processing
%                very large data set when physical memory is limited.
%            -save_type:
%                0 for .mat file, 1 for .txt file, 2 for both.
%                [Note] The file format of .txt is as follows:
%                data_id #_of_neighbors data_id:distance_value data_id:distance_value ...
% 
%  [cluster_labels evd_time kmeans_time total_time] = sc(A, sigma, num_clusters);
% 
%            -A:
%                N-by-N sparse symmetric distance matrix, where N is the number of data.
%            -sigma:
%                Sigma value used in similarity function S, where S_ij = exp(-dist_ij^2 / 2*sigma*sigma);
%                if sigma is 0, apply self-tunning technique, where S_ij = exp(-dist_ij^2 /2*avg_dist_i*avg_dist_j).
%            -num_clusters:
%                Number of clusters.
%  [cluster_labels evd_time kmeans_time total_time] = nystrom(data, num_samples, sigma, num_clusters);
% 
%            -data:
%                N-by-D data matrix, where N is the number of data, D is the number of dimensions.
%            -num_samples:
%                Number of random samples.
%            -sigma:
%                Sigma value used in similarity function S, where S = exp(-dist^2 / 2*sigma*sigma).
%            -num_clusters:
%                Number of clusters.

% Kern = zeros(50);
% Kern(10:15, 15:20) = rand(6,6)*0.5+0.5;
% Kern(25:35, 35:40) = rand(11,6)*0.5+0.5;
figure;
imshow(uint8(Kern*255));
maskKern = Kern.*mask;
idata= maskKern(:);

total_nodes =  sum(nnodes);
rowmask=zeros(total_nodes,total_nodes);
colmask=zeros(total_nodes,total_nodes);
for v=vididx
    startidx = sum(nnodes(1:v-1))+1;
    endidx = sum(nnodes(1:v));
    mgrid = meshgrid(1:endidx-startidx+1, 1: endidx-startidx+1);
    rowmask(startidx:endidx,startidx:endidx) =mgrid;
    colmask(startidx:endidx,startidx:endidx) =mgrid';
end
sdata= [rowmask(:), colmask(:)];

% mgrid = meshgrid(1:endidx-startidx+1, 1: endidx-startidx+1);
% coldata = mgrid(:);
% mgrid = mgrid';
% rowdata = mgrid(:);
% sdata = [rowdata,coldata];
% sdata = sdata/max(sdata(:));
% a = 0.0;
% data =[idata,sdata*a]/(1+a);


num_neighbors =len;
block_size=2000;
sigma = 0.5;
num_clusters = 2;
save_type=0;
num_samples=1000;
% outfile = [ num2str(num_neighbors), '_NN_sym_distance.mat'];
% if ~exist(outfile,'file')
% %     As = sparse(length(data), length(data));
%     
%     A =gen_nn_distance(idata, num_neighbors, block_size, save_type);
% %     As = gen_nn_distance(sdata, num_neighbors, block_size, save_type);
% %     As(mask(:)==1,mask(:)==1)=0.5;
% %     A=A+As;
% else
%     load(outfile);
% end
% % [cluster_labels evd_time kmeans_time total_time] = sc(A, sigma, num_clusters);

[cluster_labels evd_time kmeans_time total_time]=nystrom(idata, num_samples, sigma, num_clusters);

res = zeros(size(Kern));
res(cluster_labels==1) = 255;
figure; imshow(uint8(res));

res=res.*mask;
figure; imshow(uint8(res));




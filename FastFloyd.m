% FastFloyd - quickly compute the all pairs shortest path matrix
% 
% Uses a vectorized version of the Flyod-Warshall algorithm
% see: http://en.wikipedia.org/wiki/Floyd_Warshall
% 
% USAGE:
%
% D = FastFloyd(A)
% 
% D - the distance (geodesics, all pairs shortest path, etc.) matrix.
% A - the adjacency matrix, where A(i,j) is the cost for moving from vertex i to
%     vertex j.  If vertex i and vertex j are not connected then A(i,j) should
%     be >= the diameter of the network (Inf works fine).
%      
% EXAMPLE:
% 
% Here I create a random binary matrix and convert it to an integer format. Then
% I take the reciprocal of the matrix so that all non-adjacent pairs get a value
% of Inf.  The result is stored in D.
%
% A = int32(rand(100,100) < 0.05);
% D = FastFloyd(1./A)
%

function D = FastFloyd(D,row,col)

n = size(D, 1);
idx =1:n;
idx =reshape(idx,row,col);
N=row;
for k=1:n
    rowidx =rem((k-1),N)+1;
    colidx = ceil(k/N);
    iusing = idx(1:rowidx,1:colidx);
    iusing = iusing(1:end-1);
    
    if rowidx <row && colidx<col
        jusing = [idx(rowidx+1,colidx),idx(rowidx,colidx+1),idx(rowidx+1,colidx+1)];
        i2k = repmat(D(iusing,k), 1, 3); % :->possible i , n->possible j =3
        k2j = repmat(D(k,jusing),length(iusing), 1);
        i2jtmp =i2k+k2j;
        D(iusing,jusing(1))= min(D(iusing,jusing(1)), i2jtmp(:,1));
        D(iusing,jusing(2))= min(D(iusing,jusing(2)), i2jtmp(:,2));
        D(iusing,jusing(3))= min(D(iusing,jusing(3)), i2jtmp(:,3));
    elseif rowidx==row && colidx~=col
        jusing = idx(rowidx,colidx+1);
        i2k = repmat(D(iusing,k), 1, 1); 
        k2j = repmat(D(k,jusing),length(iusing), 1);
        i2jtmp =i2k+k2j;
        D(iusing,jusing(1))= min(D(iusing,jusing(1)), i2jtmp(:,1));
    elseif colidx==col && rowidx~=row
        jusing = idx(rowidx+1,colidx);
        i2k = repmat(D(iusing,k), 1, 1); 
        k2j = repmat(D(k,jusing),length(iusing), 1);
        i2jtmp =i2k+k2j;
        D(iusing,jusing(1))= min(D(iusing,jusing(1)), i2jtmp(:,1));
    end
end

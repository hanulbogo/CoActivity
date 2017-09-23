function img =OFD_Kern_imresize(org,scale)

img = zeros(size(org)*scale);

for i =1: size(org,1)
    for j =1: size(org,2)
        img((i-1)*scale+1:i*scale, (j-1)*scale+1:j*scale) =org(i,j);
    end
end
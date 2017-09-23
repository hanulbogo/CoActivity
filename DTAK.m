function G=DTAK(i,j,Kern,G)
if i==1 || j==1
    G(i,j)=sum(Kern(1:i,1:j));%*i*j;
else
    if G(i-1,j)==-1
        G = DTAK(i-1,j,Kern,G);
    end
    if G(i-1,j-1)==-1
        G = DTAK(i-1,j-1,Kern,G);
    end
    if G(i,j-1)==-1
        G = DTAK(i,j-1,Kern,G);
    end
    
        
    G(i,j) = max([G(i-1,j)+Kern(i,j),G(i-1,j-1)+Kern(i,j)*2,G(i,j-1)+Kern(i,j)]);
    
%     if idx ==1
%         fprintf('%d %d\n', i-1,j);
%     elseif idx ==2
%         fprintf('%d %d\n', i-1,j-1);
%     elseif idx ==3
%         fprintf('%d %d\n', i,j-1);
%     end
end

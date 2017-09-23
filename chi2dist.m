function d= chi2dist(X,Y) %1*D N*D
X=repmat(X,size(Y,1),1);
XY =(X+Y);
XY(XY==0)=1;
d =sum((((X-Y).^2)./XY),2);

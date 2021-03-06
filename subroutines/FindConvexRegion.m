function maskOut = findConvexRegion(maskIn)
% function maskOut = findConvexRegion(maskIn)
% 
% Finds the region inside the convex hull of the maskIn
%
% N. Bozinovic, 08/26/08

N = size(maskIn);
k = 0;
for i = 1:N(1)
    for j = 1:N(2)
        if maskIn(i,j) == 1
            k = k + 1;
            X(k) = i;
            Y(k) = j;
        end
    end
end
K = convhull(X,Y);
xx = 1:N(1);
yy = 1:N(2);
[XX,YY] = meshgrid(xx,yy);
maskOut = inpolygon(YY,XX,X(K),Y(K));
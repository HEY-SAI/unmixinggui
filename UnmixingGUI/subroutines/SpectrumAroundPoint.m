function [array, pointsUsed] = SpectrumAroundPoint(cube, mask, xi, yi, delta)
% function [array, pointsUsed] = SpectrumAroundPoint(cube,mask,xi,yi,delta)
if nargin < 5
    delta = 5;
end

N = size(cube);
array = zeros( 1, N(3));
k = 0;
% array = shiftdim(mean(mean(cube(xi - delta : xi + delta, yi - delta : yi + delta,:),1),2),1);
for i = -delta : delta
    for j = -delta : delta
        k = k + 1;
        array = array + shiftdim( cube( xi + i, yi + j,:) , 1);
        pointsUsedX(k) = xi + i;
        pointsUsedY(k) = yi + j;
    end
end
array = array/k;

% array = zeros( 1, N(3));
% k = 0;
% for i = -delta : delta
%     for j = -delta : delta
%         if ((xi + i < 1)|| (xi + i > N(1))||(yi + j < 1)|| (yi + j > N(2)))
%             msgbox('You are too close to the border (make delta smaller or choose xi, yi more toward the center)');
%             return
%         end
%         if mask( xi + i, yi + j) == 1
%             k = k + 1;
%             array = array + shiftdim( cube( xi + i, yi + j,:) , 1);
%             pointsUsedX(k) = xi + i;
%             pointsUsedY(k) = yi + j;
%         end
%     end
% end
% if k ~= 0
%     array = array/k;
% else
%     % msgbox('no points near by');
%     % return;
% end

pointsUsed.X = pointsUsedX;
pointsUsed.Y = pointsUsedY;
%clc;
% this program shoud demonstrate functions like fminsearch and lp and
% fmincon
clc;
clear;
N = 200;
xx = linspace(0,20,N);
yy = sin(xx)+ 0.2*xx;
plot(xx,yy);
%y = @(x) sin(x)+ 0.2*x;
%[x,fmin] = fmincon(y,10,[-1;1],[-8 ; 14]);
options = optimset('Hessian','on');
y = @(x) -x(1) * x(2) * x(3);
[x,fmin] = fmincon(y,[10;10;10],[-1 -2 -2;1 2 2],[0 ; 72]);
% 
% [x,fmin] = fminsearch(y,12)

% 
%  y = @(x) (x(1)+1).^2  + (x(2) -4).^2 + 6; % function should have min at (x,y) = (-1,1);
%  [x,fmin] = fminsearch(y,[0,0])


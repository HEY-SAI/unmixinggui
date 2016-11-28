clc;
close all;
clear x;
x = cube;
N = size(x);

% section that converts x to y by stacking images as columns
y = zeros(N(1)*N(2),N(3));
for i = 1:N(3) 
    temp = x(:,:,i); 
    y(:,i) = temp(:); 
end
y = y';

% find the true reconstruction
[sImage, tImage] = FindCoeff(Atrue,y,N,1);
close all;
%% segment organs, obtains variable mask
M = size(organList);
mask = zeros(M);

% 1) segments the organs (so far only thresholds them, can be improved)
% 2) find the convex hulls and posibly dilates them
% 3) calculate overlaping and non-overlaping regions and gives the percentage of overlap for each organ
% 4) calulate the spectra based on everything
%     4.1) find the "pure" spectra using non overlap region
%     4.2) finds the "mixed" spectra usign overlap region

% 1) segments the organs (so far only thresholds them, can be improved)
for i = 1:M(3)
    image = organList(:,:,i);
    % different mask for background
    if i == 1
        mask(:,:,i) = image > 0.10 * ( max(image(:)) - min(image(:)) ) + min(image(:));
    else
        mask(:,:,i) = image > 0.25 * ( max(image(:)) - min(image(:)) ) + min(image(:));
    end
    Puti(mask(:,:,i),num2str(i),i,[0,1]);
end

% 2) find the convex hulls
for i = 1:M(3)
    mask(:,:,i) = FindConvexRegion(mask(:,:,i));
    Puti(mask(:,:,i),num2str(i),i,[0,1]);
end

% 3) dilates
for i = 2:M(3) 
    mask(:,:,i) = MaskDilate(mask(:,:,i));
    mask(:,:,i) = MaskDilate(mask(:,:,i));
    %mask(:,:,i) = MaskDilate(mask(:,:,i));
end

% 3) find A, B, A+B;

mask1only = mask(:,:,1) - mask(:,:,2) - mask(:,:,3) > 0;

mask2only = mask(:,:,2) - mask(:,:,3) > 0;

mask3only = mask(:,:,3) - mask(:,:,2) > 0;

mask23 = (mask(:,:,2) + mask(:,:,3) == 2);


puti(mask1only,'1',1);
puti(mask2only,'2',2);
puti(mask3only,'3',3);
puti(mask23,'2-3',4);

close all;
clear A;
A = zeros(N(3),M(3));
B = zeros(N(3),1);
for i = 1:M(3)
    for j = 1:N(3)
        A(j,1) = mean(mean(  x(:,:,j).*mask1only ));
        A(j,2) = mean(mean(  x(:,:,j).*mask2only ));
        A(j,3) = mean(mean(  x(:,:,j).*mask3only ));
        B(j,1) = mean(mean(  x(:,:,j).*mask23 ));
    end
end
Pos(3); A = NormalizeSpectra(A); plot(A); title('A');

for i = 2:M(3)
    A(:,i) = Shrink(A(:,i),B);
%    A(:,i) = Shrink(A(:,i),A(:,1));
%     plot(A(:,i),'r');
%     hold on
%     plot(B,'g');
%     close;
    
end

Pos(3);
% A = NormalizeSpectra(A);
plot(A); title('A');

%% 
[sImage, tImage] = FindCoeff(A,y,N,1);
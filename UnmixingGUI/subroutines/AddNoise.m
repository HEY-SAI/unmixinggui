function noisyCube = addNoise(cube,sigma)
% Adds gaussian noise to the cube with sigma standard deviation .
%
% N.Bozinovic, 08/28/08
N = size(cube);
for i = 1:N(1)
    for j = 1:N(2)
        for k = 1:N(3)
            noisyCube(i,j,k) = cube(i,j,k) + sqrt(cube(i,j,k)*randn(1,1);
        end
    end
end
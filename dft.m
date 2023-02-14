function [X] = dft(z, M)
%DFT Calculate the first M+1 coefficients of the DFT of a complex signal z[n]
%   Inputs:
%       z:  Complex signal z[n]
%       M:  Number of coefficients to calculate
%   Output:
%       X:  First M+1 coefficients of the DFT of z[n]

N = length(z);
X = zeros(M+1,1);

for k = 0:M
    for n = 0:N-1
        X(k+1) = X(k+1) + z(n+1)*exp(1i*2*pi*k*n/N);
    end
end

function [reconstructedImage] = reconstructImage(z, M)
%RECONSTRUCTIMAGE Reconstruct an image using the first M+1 coefficients of its DFT
%   Inputs:
%       z:  Complex signal representing the image
%       M:  Number of coefficients to use in reconstruction
%   Output:
%       reconstructedImage:  Reconstructed image using the first M+1 coefficients of the DFT of z

N = length(z);
reconstructedImage = zeros(N,1);

for n = 0:N-1
    for k = 0:M
        reconstructedImage(n+1) = reconstructedImage(n+1) + z(k+1)*exp(1i*2*pi*k*n/N);
    end
end

% Convert reconstructedImage from complex to real values
reconstructedImage = real(reconstructedImage);

end

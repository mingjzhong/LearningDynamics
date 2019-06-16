function Z = squareform_tomatrix( Y )
%SQUAREFORM Reformat a distance matrix between upper triangular and square form.
%   Z = SQUAREFORM(Y), if Y is a vector as created by the PDIST function,
%   converts Y into a symmetric, square format, so that Z(i,j) denotes the
%   distance between the i and j objects in the original data.
%

% Modification of Matlab's squareform

%   Copyright 1993-2011 The MathWorks, Inc.


[m, n] = size(Y);

if m~=1
    Y = Y';
    n = m;
end

m = ceil(sqrt(2*n)); % (1 + sqrt(1+8*n))/2, but works for large n

Z = zeros(m,class(Y));
if m>1
    Z(tril(true(m),-1)) = Y;
    Z = Z + Z';
end

return

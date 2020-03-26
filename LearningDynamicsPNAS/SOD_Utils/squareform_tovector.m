function Z = squareform_tovector(Y)

%   Small modification of Mathworks version
%   Copyright 1993-2011 The MathWorks, Inc.


n = size(Y,2);

Z = Y(tril(true(n),-1));
Z = Z(:)';                 % force to a row vector, even if empty

return

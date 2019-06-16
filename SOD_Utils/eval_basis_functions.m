function [y, yprime] = eval_basis_functions(x, alphas, vs)
% [y, yprime] = eval_basis_functions(x, alphas, vs)
% evaluate the a linear combination of basis functions, v_l's in vs, with
% their coefficients stored in the vector alphas, at the values stored in
% vector x.
% Intput:
%   x      - independent varaibles, with an array of values to be evaluated
%            at
%   alphas - the coefficients for the linear combination of basis functions
%            in vs, each alphas(i) corresponding to basis function vs{i}
%   vs     - a cell array storing function handlers for the basis functions
%            vs and alphas should have the same length, and same
%            correspondence
% Output:
%   y      - y = \sum_{i = 1}^D alphas(i) * vs{i}(x), where D is the
%            length of vs and alphas
%   yprime - yprime = \sum_{i = 1}^D alphas(i) * v'{i}(x), where D is the
%            length of vs and alphas

% Ming Zhong
% Postdoc Research


D           = length(alphas);                                                                                                   % find out the total number of basis functions
% check to see if vs and alphas have the same length
% if D ~= length(vs), error('eval_basis_functions:InvalidParameter vs and alphas should have the same length'); end

y               = zeros(size(x));                                                                                               % prepare y, having the same size as the independent variable x
yprime          = zeros(size(x));                                                                                               % prepare yprime, having the same size as the independent variable x
% y = sum_{i = 1}^D alphas(i) * vs{i}(x), use a for loop, cellfun is not efficient at all, avoid using it (also arrayfun)
for i = 1 : D
    if alphas(i) ~= 0                                                                                                           % only add up those with non-zero coefficients
        [v, vprime] = vs.f{i}(x);                                                                                                 % find out the value of v's at x and vprime's at x
        if nnz(v) ~= 0
            y         = y + alphas(i) * v;                                                                                      % add the v's to y
        end
        if nnz(vprime) ~= 0
            yprime    = yprime + alphas(i) * vprime;                                                                            % add the vprime's to yprime
        end
    end
end

return
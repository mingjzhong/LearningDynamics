function external = find_xi_external(x, xi, sys_info)
% function external = find_xi_external(x, xi, sys_info)


% (c) M. Zhong (JHU)

% 
L                   = size(x, 2);
%
external            = zeros(size(xi));
%
for l = 1 : L
  x_at_t            = reshape(x(:, l), [sys_info.d, sys_info.N]);
  xi_at_t           = transpose(xi(:, l));
  external(:, l)    = sys_info.Fxi(xi_at_t, x_at_t);
end
% change it back to a vector
external            = external(:);
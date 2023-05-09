function [x_l, v_l, xi_l] = get_the_data_at_t(x, v, xi, l, sys_info)
% function [x_l, v_l, xi_l] = get_the_data_at_t(x, v, xi, l, sys_info)

% (C) M. Zhong

% for x_i and v_i, reshaped to matrices of size [d, N] 
if ~isempty(x),  x_l  = reshape(x(:, l), [sys_info.d, sys_info.N]); else, x_l  = []; end 
% for improved data handling
if ~isempty(v),  v_l  = reshape(v(:, l), [sys_info.d, sys_info.N]); else, v_l  = []; end   
% for xi_i, just make it into a row vectors
if ~isempty(xi), xi_l = xi(:, l)';                                  else, xi_l = []; end        
end
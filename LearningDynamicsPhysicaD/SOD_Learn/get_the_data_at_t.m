function [x_l, v_l, xi_l] = get_the_data_at_t(x_m, v_m, xi_m, l, sys_info)
% function [x_l, v_l, xi_l] = get_the_data_at_t(x_m, v_m, xi_m, l, sys_info)

% (C) M. Zhong

if ~isempty(x_m),  x_l  = reshape(x_m(:, l), [sys_info.d, sys_info.N]); else, x_l  = []; end        % for x_i and v_i, reshaped to matrices of size [d, N] 
if ~isempty(v_m),  v_l  = reshape(v_m(:, l), [sys_info.d, sys_info.N]); else, v_l  = []; end        % for improved data handling
if ~isempty(xi_m), xi_l = xi_m(:, l)';                                  else, xi_l = []; end        % for xi_i, just make it into a row vectors
end
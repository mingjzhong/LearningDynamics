function [x_m, v_m, xi_m, dotxv_m, dotxi_m] = get_the_data_at_m(x, v, xi, dotxv, dotxi, m)
% function [x_m, v_m, xi_m, dotxv_m, dotxi_m] = get_the_data_at_m(x, v, xi, dotxv, dotxi, m)

% (C) M. Zhong

if ~isempty(x),     x_m     = squeeze(x(:, :, m));     else, x_m     = []; end
if ~isempty(v),     v_m     = squeeze(v(:, :, m));     else, v_m     = []; end
if ~isempty(xi),    xi_m    = squeeze(xi(:, :, m));    else, xi_m    = []; end
if ~isempty(dotxv), dotxv_m = squeeze(dotxv(:, :, m)); else, dotxv_m = []; end
if ~isempty(dotxi), dotxi_m = squeeze(dotxi(:, :, m)); else, dotxi_m = []; end
end
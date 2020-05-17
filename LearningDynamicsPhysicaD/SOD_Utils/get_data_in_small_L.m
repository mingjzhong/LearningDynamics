function [x_new, v_new, xi_new, dot_xv_new, dot_xi_new, time_vec_new] = get_data_in_small_L(x, v, ...
         xi, dot_xv, dot_xi, time_vec, M)
%

% (C) M. Zhong

L            = length(time_vec);
L_new        = L/M;
time_vec_new = time_vec(1 : L_new); 
if ~isempty(x),      x_new      = zeros(size(x, 1),      L_new, M); else, x_new      = []; end 
if ~isempty(v),      v_new      = zeros(size(v, 1),      L_new, M); else, v_new      = []; end
if ~isempty(xi),     xi_new     = zeros(size(xi, 1),     L_new, M); else, xi_new     = []; end
if ~isempty(dot_xv), dot_xv_new = zeros(size(dot_xv, 1), L_new, M); else, dot_xv_new = []; end
if ~isempty(dot_xi), dot_xi_new = zeros(size(dot_xi, 1), L_new, M); else, dot_xi_new = []; end
for m = 1 : M
  ind1       = (m - 1) * L_new + 1;
  ind2       = m       * L_new;
  if ~isempty(x),      x_new(:, :, m)      = x(:, ind1 : ind2); end
  if ~isempty(v),      v_new(:, :, m)      = v(:, ind1 : ind2); end
  if ~isempty(xi),     xi_new(:, :, m)     = xi(:, ind1 : ind2); end
  if ~isempty(dot_xv), dot_xv_new(:, :, m) = dot_xv(:, ind1 : ind2); end
  if ~isempty(dot_xi), dot_xi_new(:, :, m) = dot_xi(:, ind1 : ind2); end
end
end
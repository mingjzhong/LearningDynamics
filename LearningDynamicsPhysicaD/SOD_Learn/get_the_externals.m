function [F_vec, Fxi_vec] = get_the_externals(x, v, xi, sys_info)
% function [F_vec, Fxi_vec] = get_the_externals(x, v, xi, sys_info)

% (C) M. Zhong (JHU)

% initialize storage
L           = size(x, 2);
switch sys_info.ode_order
  case 1
    if isfield(sys_info, 'Fx') && ~isempty(sys_info.Fx)
      F_vec           = zeros(sys_info.N * sys_info.d, L);
      Fxv             = sys_info.Fx;
    else
      F_vec           = [];
      Fxv             = [];
    end
  case 2
     if isfield(sys_info, 'Fv') && ~isempty(sys_info.Fv)
      F_vec           = zeros(sys_info.N * sys_info.d, L);
      Fxv             = sys_info.Fv;
    else
      F_vec           = [];
      Fxv             = [];
     end
  otherwise
end
if isfield(sys_info, 'Fxi') && ~isempty(sys_info.Fxi)
  Fxi_vec             = zeros(sys_info.N, L);
  Fxi                 = sys_info.Fxi;
else
  Fxi_vec             = [];
  Fxi                 = [];
end
for l = 1 : L
  x_l                 = reshape(x(:, l), [sys_info.d, sys_info.N]);
  if ~isempty(v),  v_l  = reshape(v(:, l), [sys_info.d, sys_info.N]); else, v_l = []; end
  if ~isempty(xi), xi_l = xi(:, l)'; else, xi_l = []; end
  if ~isempty(Fxv)
    switch sys_info.ode_order 
      case 1
        F_vec(:, l)   = Fxv(x_l, xi_l);
      case 2
        F_vec(:, l)   = Fxv(x_l, v_l, xi_l);
      otherwise
    end
  end
  if ~isempty(Fxi)
    switch sys_info.ode_order 
      case 1
        Fxi_vec(:, l) = Fxi(x_l, xi_l);
      case 2
        Fxi_vec(:, l) = Fxi(x_l, v_l, xi_l);
      otherwise
    end  
  end
end
if ~isempty(F_vec),   F_vec   = F_vec(:);   end
if ~isempty(Fxi_vec), Fxi_vec = Fxi_vec(:); end
end
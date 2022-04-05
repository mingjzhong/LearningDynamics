function [x_CM, v_CM, xi_CM] = computeCenterOfMassQuantities(x, v, xi, sys_info)
% function [x_CM, v_CM, xi_CM] = computeCenterOfMassQuantities(x, v, xi, sys_info)

% (C) M. Zhong

if isfield(sys_info, 'agent_mass') && ~isempty(sys_info.agent_mass)
  mass_vec = sys_info.agent_mass;
else
  mass_vec = ones(1, sys_info.N);
end
if ~isrow(mass_vec), mass_vec = mass_vec'; end
total_mass = sum(mass_vec);
if ~isempty(x)
  x_CM     = sum(x .*  repmat(mass_vec, [sys_info.d, 1]), 2)/total_mass;
else
  x_CM     = [];
end
if ~isempty(v)
  v_CM     = sum(v .*  repmat(mass_vec, [sys_info.d, 1]), 2)/total_mass;
else
  v_CM     = [];
end
if ~isempty(xi)
  xi_CM    = sum(xi .* repmat(mass_vec, [sys_info.d, 1]), 2)/total_mass;
else
  xi_CM    = [];
end
end

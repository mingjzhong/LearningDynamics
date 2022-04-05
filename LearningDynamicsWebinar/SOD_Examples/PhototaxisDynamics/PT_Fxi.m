function Fxi = PT_Fxi(xi, I_0, xi_capacity, gamma)
% Fxi = PT_Fxi(xi, I_0, xi_capacity, gamma)

% (C) M. Zhong (JHU)

xi_effect = gamma(xi, xi_capacity);
if ~iscolumn(xi_effect), xi_effect = xi_effect'; end
Fxi       = I_0 * xi_effect;
end
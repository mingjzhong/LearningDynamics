function friction = PS_2nd_order_Fv(v, nu, K, type_info)
% friction = PS_2nd_order_Fv(v, nu, K, type_info)

% (C) M. Zhong (JHU)

% initialization
friction                  = zeros(size(v));
% go through each type of agents
for k = 1 : K
  agents_Ck1              = type_info == k;
  friction(:, agents_Ck1) = -nu(k) * v(:, agents_Ck1);
end
% reshape into a vector
friction                  = friction(:);
end
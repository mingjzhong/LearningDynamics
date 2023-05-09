function F = get_the_ls_for_iprk_and_irkn(L, L_vec, A, h, ode_fun, x_len, num_stages)
% function F = get_the_ls_for_iprk_and_irkn(L, L_vec, A, h, ode_fun, x_len, num_stages)

% (C) M. Zhong

f_of_L           = L_vec + h^2 * A * L;
F                = zeros(x_len * num_stages);
for idx = 1 : num_stages
  ind1           = (idx - 1) * x_len + 1;
  ind2           = idx * x_len;
  F(ind1 : ind2) = ode_fun(f_of_L(ind1 : ind2));
end
end
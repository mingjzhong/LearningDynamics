function state_norm = state_norm(state_vec, sys_info, N_ks, C_ks)
% function the_norm = state_norm(state_vec, system, agents_each_class, num_agents_each_class)

% (c) M. Zhong, M. Maggioni

x               = state_vec(1 : sys_info.N * sys_info.d);                                           % partition the state vector, find out the component for x
x               = reshape(x, [sys_info.d, sys_info.N]);                                             % we only need to work on x, reshape x  
the_sum         = sum(x.^2,1);                                                                      % square component wise and sum over the rows  
state_norm      = zeros(1, sys_info.K);                                                             % ||X||_2^2 = \sum_{k = 1}^K 1/N_k \sum_{i = 1}^N_k||x_i||_2^2
for k = 1 : sys_info.K
  state_norm(k) = sum(the_sum(C_ks(k, :)))/N_ks(k);
end
state_norm      = sqrt(sum(state_norm));
end
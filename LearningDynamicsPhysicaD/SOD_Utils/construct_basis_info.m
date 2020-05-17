function basis_info = construct_basis_info(sys_info, obs_info, degree, type, sub_type, period)
% function basis_info = construct_basis_info(sys_info, obs_info, degree, type, sub_type, period)

% (c) M. Zhong

if nargin < 6, period = Inf * ones(1, length(degree)); end
agent_info                         = getAgentInfo(sys_info);
basis_info                         = cell(sys_info.K);
ML_prod                            = obs_info.M * obs_info.L;
dim                                = length(degree);
rate                               = dim/(2 + dim);
for k1 = 1 : sys_info.K
  Nk1                              = agent_info.num_agents(k1);
  for k2 = 1 : sys_info.K
    Nk2                            = agent_info.num_agents(k2);
    max_n                          = ceil((ML_prod/log(ML_prod))^rate * sqrt(Nk1 * Nk2)^(1/sys_info.d));
    max_n                          = ceil(max_n^(1/dim));
    if k1 == k2 && Nk1 == 1
      basis_info{k1, k2}.degree    = zeros(1, dim);
      basis_info{k1, k2}.n         = ones(1, dim);
    else
      basis_info{k1, k2}.degree    = degree;
      basis_info{k1, k2}.n         = set_n_in_basis_info(max_n, degree, type, sub_type);
    end
    basis_info{k1, k2}.dim         = dim;
    basis_info{k1, k2}.type        = type;
    basis_info{k1, k2}.sub_type    = sub_type;
    basis_info{k1, k2}.period      = period;
    
  end
end
end
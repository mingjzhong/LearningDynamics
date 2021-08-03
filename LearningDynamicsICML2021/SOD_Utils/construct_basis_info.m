function basis_info = construct_basis_info(sys_info, obs_info, degree, type, sub_type, period)
% function basis_info = construct_basis_info(sys_info, obs_info, degree, type, sub_type, period)

% (c) M. Zhong

if nargin < 6, period = Inf * ones(1, length(degree)); end
agent_info                         = getAgentInfo(sys_info);
basis_info                         = cell(sys_info.K);
ML_prod                            = obs_info.M * obs_info.L;
dim                                = length(degree);
rate                               = dim/(2 + dim);
if isfield(sys_info, 'on_manifold') && ~isempty(sys_info.on_manifold)
  switch sys_info.manifold_type
    case 'S2'
      d                            = 2;
    case 'PD'
      d                            = 2;
    case 'H2'
      d                            = 2;
    otherwise
      error('');
  end
else
  d                                = sys_info.d;
end
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if k1 == k2 && agent_info.num_agents(k1) == 1
      basis_info{k1, k2}.degree    = 0;
      basis_info{k1, k2}.n         = 1;
      basis_info{k1, k2}.dim       = 1;
      basis_info{k1, k2}.type      = type(1);
      basis_info{k1, k2}.sub_type  = sub_type(1);
      basis_info{k1, k2}.period    = period(1);  
    else
      max_n                        = ceil((ML_prod/log(ML_prod))^rate);
      max_n                        = ceil(max_n^(1/dim));      
      basis_info{k1, k2}.degree    = degree;
      basis_info{k1, k2}.n         = set_n_in_basis_info(max_n, degree, type, sub_type);
      basis_info{k1, k2}.dim       = dim;
      basis_info{k1, k2}.type      = type;
      basis_info{k1, k2}.sub_type  = sub_type;
      basis_info{k1, k2}.period    = period;      
    end
  end
end
end
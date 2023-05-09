function feature_map = get_feature_map_of_states_Ck1Ck2_old(states, sys_info, k1, k2)
% function feature_map = get_feature_map_of_states_Ck1Ck2_old(states, sys_info, k1, k2)

% (C) M. Zhong

% these are of size (d, N_1) or (1, N_1)
x1                             = states{1}';
v1                             = states{1}';
xi1                            = states{1}';
N1                             = size(x1, 1);
% these are of size (d, N_2) or (1, N_2)
x2                             = states{2}';
v2                             = states{2}';
xi2                            = states{2}';
N2                             = size(x2, 1);
% return a data of size (N_1, N_2)
if sys_info.ode_order == 1
  x1                           = kron(x1, ones(N2, 1));
  x2                           = repmat(x2, [N1, 1]);
  E_dim                        = size(sys_info.A_E{k1, k2}, 2);
  if isfield(sys_info, 'A_xi') && ~isempty(sys_info.A_xi) && ~isempty(sys_info.A_xi{k1, k2})
    xi1                        = kron(xi1, ones(N2, 1));
    xi2                        = repmat(xi2, [N1, 1]);
    X                          = [x1, xi1, x2, xi2, sum(x1.^2, 2), sum(x2.^2, 2), sum(x1 .* x2, 2)];
    Xi_dim                     = size(sys_info.A_xi{k1, k2}, 2);
  else
    X                          = [x1, x2, sum(x1.^2, 2), sum(x2.^2, 2), sum(x1 .* x2, 2)];
    Xi_dim                     = 0;
  end
  dim_total                    = E_dim + Xi_dim;
  feature_map                  = cell(1, dim_total);
  Y_E                          = X * sys_info.A_E{k1, k2};
  for idx = 1 : E_dim
    feature_map{idx}           = reshape(Y_E(:, idx), N1, N2);
  end
  if Xi_dim > 0
    Y_Xi                       = X * sys_info.A_xi{k1, k2};
    for idx = 1 : Xi_dim
      feature_map{idx + E_dim} = reshape(Y_Xi(:, idx), N1, N2);
    end
  end
elseif sys_info.ode_order == 2
  x1                           = kron(x1, ones(N2, 1));
  v1                           = kron(v1, ones(N2, 1));
  x2                           = repmat(x2, [N1, 1]);
  v2                           = repmat(v2, [N1, 1]);
  if isfield(sys_info, 'A_E') && ~isempty(sys_info.A_E) && ~isempty(sys_info.A_E{k1, k2})
    E_dim                      = size(sys_info.A_E{k1, k2}, 2);
  else
    E_dim                      = 0;
  end
  if isfield(sys_info, 'A_A') && ~isempty(sys_info.A_A) && ~isempty(sys_info.A_A{k1, k2})
    A_dim                      = size(sys_info.A_A{k1, k2}, 2);
  else
    A_dim                      = 0;
  end
  if isfield(sys_info, 'A_xi') && ~isempty(sys_info.A_xi) && ~isempty(sys_info.A_xi{k1, k2})
    xi1                        = kron(xi1, ones(N2, 1));
    xi2                        = repmat(xi2, [N1, 1]);  
    X                          = [x1, v1, xi1, x2, v2, xi2, sum(x1.^2, 2), sum(x2.^2, 2), ...
                                  sum(x1 .* x2, 2), sum(v1.^2, 2), sum(v2.^2, 2), sum(v1 .* v2, 2), ...
                                  sum(x1 .* v1, 2), sum(x1 .* v2, 2), sum(x2 .* v1, 2), ...
                                  sum(x2 .* v2, 2)];
    Xi_dim                     = size(sys_info.A_xi{k1, k2}, 2);
  else
    X                          = [x1, v1, x2, v2, sum(x1.^2, 2), sum(x2.^2, 2), ...
                                  sum(x1 .* x2, 2), sum(v1.^2, 2), sum(v2.^2, 2), sum(v1 .* v2, 2), ...
                                  sum(x1 .* v1, 2), sum(x1 .* v2, 2), sum(x2 .* v1, 2), ...
                                  sum(x2 .* v2, 2)];    
    Xi_dim                     = 0;
  end
  dim_total                    = E_dim + A_dim + Xi_dim;
  feature_map                  = cell(1, dim_total);
  if E_dim > 0
    Y_E = X * sys_info.A_E{k1, k2}; 
    for idx =1 : E_dim
      feature_map{idx}           = reshape(Y_E(:, idx), N1, N2);
    end
  end
  if A_dim > 0
    Y_A = X * sys_info.A_A{k1, k2}; 
    for idx = 1 : A_dim
      feature_map{idx + E_dim} = reshape(Y_A(:, idx), N1, N2);
    end
  end
  if Xi_dim > 0
    Y_Xi = X * sys_info.A_xi{k1, k2}; 
    prev = E_dim + A_dim;
    for idx = 1 : Xi_dim
      feature_map{idx + prev}  = reshape(Y_Xi(:, idx), N1, N2);
    end
  end
end
end
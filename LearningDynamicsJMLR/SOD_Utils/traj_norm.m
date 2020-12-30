function traj_dist = traj_norm( traj_1, traj_2, type, sys_info )
% the_dist = traj_norm(traj_1, traj_2, time_vec, type, learning_info)

% (c) Ming Zhong, Mauro Maggioni

%% Find out the number of agents in each class
N_ks                = zeros( 1, sys_info.K);
C_ks                = zeros( sys_info.K, sys_info.N, 'logical' );                                   % logical index for each class
for k = 1 : sys_info.K
  agents_Ck         = sys_info.type_info == k;
  C_ks(k, :)        = agents_Ck;
  N_ks(k)           = nnz(agents_Ck);
end

%% Compute the trajectory norm
switch type
  case 'Time-Maxed'                                                                                 % sup_{[0, T]} ||X(t) - X_hat(t)||, find out the number of time instances when observations are made
    L               = size(traj_1, 2);
    if size(traj_2, 2) ~= L,  error('Trajectories should have the same length!'); end               % traj_2 must have the same length in time
    state_diff      = zeros(1, L);                                                                  % prepare the difference in states
    for l = 1 : L                                                                                   % go through each time instance
      state_diff(l) = state_norm(traj_1(:, l) - traj_2(:, l), sys_info, N_ks, C_ks);
    end        
    traj_dist       = max(state_diff);                                                              % find out the maximum over all time
  case 'Hausdorff'                                                                                  % Hausdorff distance, which trajectory might have different number of time instances, transpose them        
    traj_1          = transpose(traj_1);
    traj_2          = transpose(traj_2);

    the_dfunc       = @(ZI, ZJ) distfun(ZI, ZJ, sys_info, agents_each_class, num_agents_each_class);% prepare the distance function        
    D_mat           = pdist2(traj_1, traj_2, @(ZI, ZJ) the_dfunc(ZI', ZJ'));                        % use the MATLAB built-in pdist2        

    X_to_Y          = max(min(D_mat,[],2));                
    Y_to_X          = max(min(D_mat,[],1));                
    traj_dist       = max([X_to_Y, Y_to_X]);                                                        % Hausdorff = \max\{\sup_{x \in X}\inf_{y \in Y} d(x, y),\sup_{y \in Y}\inf_{x \in X} d(x, y)\}
  otherwise
end
end

%% The distance function
function D2 = distfun(ZI, ZJ, sys_info, agents_each_class, num_agents_each_class)
  D2                = zeros(size(ZJ,2), 1);
  for row_ind = 1 : size(ZJ, 2)
    D2(row_ind)     = state_norm(ZI - ZJ(:,row_ind), sys_info, agents_each_class, num_agents_each_class);
  end
end
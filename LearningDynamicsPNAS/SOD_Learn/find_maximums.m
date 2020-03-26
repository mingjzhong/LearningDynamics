function output = find_maximums(traj, sys_info)
% function output = find_maximums(traj, sys_info)
% finds the maximum |\bx_i|, and/or |\bv_i|, and/or |\xi_i| for each (k, k') pair.
% k = \{1, \cdots, K\} with K being the number of types in the system
% IN:
%   traj     - collection of observed trajectories, of size (system_size, L), where system_size = Nd
%              for first order, 2Nd for second roder (wihtout xi), 2Nd + N for second order with xi
%   sys_info - struct which contains all the necessary information about the dynamical system
% OUT:
%   output   - struch which contains the max |bx_i|, and/or max |\bv_i|, and/or max |\xi_i|

% (c) M. Zhong (JHU)

% initialize the quantities
L                           = size(traj, 2);                                                        % the number of time observations
rs_each_type                = zeros(1, sys_info.K);                                                 % max |\bx_i| for each type at time t_l
one_block                   = sys_info.N * sys_info.d;                                              % how we divide the data
agent_each_type             = false(sys_info.K, sys_info.N);                                        % (in boolean variables) agent index for each type
% prepare indicators
if sys_info.ode_order == 2
  has_align                 = ~isempty(sys_info.phiA);
  has_xi                    = sys_info.has_xi;
else
  has_align                 = 0;
  has_xi                    = 0;
end
if has_align
  dotrs_each_type           = zeros(1, sys_info.K);                                                 % max |\bv_i| for each type at time t_l
end
if has_xi
  xis_each_type             = zeros(1, sys_info.K);                                                 % max |\xi_i| for each type at time t_l
end
% go through in time
for l = 1 : L
% partition the trajectory to x, v and xi, and find out the quantities in magnitude  
  x_at_tl                   = reshape(traj(1 : one_block, l), [sys_info.d, sys_info.N]);
  if has_align
    v_at_tl                 = reshape(traj(one_block + 1 : 2 * one_block, l), [sys_info.d, sys_info.N]);
  end
  if has_xi
    xi_at_tl                = traj(2 * one_block + 1 : 2 * one_block + sys_info.N, l)';
  end
  rs_at_tl                  = sum(x_at_tl.^2, 1).^(1/2);
  if has_align
    dotrs_at_tl             = sum(v_at_tl.^2, 1).^(1/2);
  end
  if has_xi
    xis_at_tl               = sum(xi_at_tl.^2, 1).^(1/2);
  end
% go through each type
  for k = 1 : sys_info.K 
    if l == 1                                                                                       
      agent_Ck              = sys_info.type_info == k;
      agent_each_type(k, :) = agent_Ck;
    else
      agent_Ck              = agent_each_type(k, :);  
    end
    rs_each_type(k)         = max(rs_at_tl(agent_Ck));                                              % agent_Ck is already a logical array
    if has_align
      dotrs_each_type(k)    = max(dotrs_at_tl(agent_Ck));
    end
    if has_xi
      xis_each_type(k)      = max(xis_at_tl(agent_Ck));
    end
  end
% find out R_k + R_k', k is the type counter
  if l == 1
    max_rs                  = repmat(rs_each_type, [sys_info.K, 1]) + repmat(rs_each_type.', [1, sys_info.K]);
    if has_align
      max_dotrs             = repmat(dotrs_each_type, [sys_info.K, 1]) + repmat(dotrs_each_type.', [1, sys_info.K]);
    end
    if has_xi
      max_xis               = repmat(xis_each_type, [sys_info.K, 1]) + repmat(xis_each_type.', [1, sys_info.K]);
    end
  else
    a_max                   = repmat(rs_each_type, [sys_info.K, 1]) + repmat(rs_each_type.', [1, sys_info.K]);
    max_rs                  = max(max_rs, a_max);
    if has_align
      a_max                 = repmat(dotrs_each_type, [sys_info.K, 1]) + repmat(dotrs_each_type.', [1, sys_info.K]);
      max_dotrs             = max(max_dotrs, a_max);
    end
    if has_xi
      a_max                 = repmat(xis_each_type, [sys_info.K, 1]) + repmat(xis_each_type.', [1, sys_info.K]);
      max_xis               = max(max_xis, a_max);      
    end
  end
end
% package the data
output.max_rs               = max_rs;
if has_align
  output.max_dotrs          = max_dotrs;
end
if has_xi
  output.max_xis            = max_xis;
end
end
function rhs = eval_rhs(y, sys_info)
% function rhs = eval_rhs(y, sys_info)
%   evaluates the right handside of the dynamics y_dot = f(t, y) based on the system information
%   regarding the dynamics
% IN:
%   y        : the state variable of the whole system
%   sys_info : the system information struct which contains vital information for the dynamics
% OUT:
%   rhs      : the right handside, f(t, y) at time t, implicit dependency on t

% (c) M. Zhong, M. Maggioni, JHU

% prepare x, v, xi and pdist_mat (contains the pairwise distance, |x_i - x_i'|
state_vars                         = partition_sys_var(y, sys_info);
x                                  = state_vars.x;
v                                  = state_vars.v;
xi                                 = state_vars.xi;
pdist_mat                          = sqrt(abs(sqdist_mod(x)));                                      % calculate the pairwise distance (using normal Euclidean distance)

% evaluate f(t, y) based on the order of the ODE
if sys_info.ode_order == 1                                                                                                                                                 
  rhs                   = find_collective_change(x, v, xi, pdist_mat, sys_info, 'energy');          % for 1st order system: \dot{x}_i = \sum_{i' = 1}^N \phi^E_{K_i, K_i'}(|x_i - x_i'|)(x_i' - x_i)
elseif sys_info.ode_order == 2
  rhs                   = zeros(size(y));                                                           % 2nd order contains update to x, v (and possibly xi)
  block_size            = sys_info.d * sys_info.N;
  rhs(1 : block_size)   = reshape(v, [block_size, 1]);                                               % for the change in x, it is just v
  if ~isempty(sys_info.phiE)                                                                        % for the change in v, it is sum of external influence plus energy based and alignment based collective influence
    internal_energy     = find_collective_change(x, v, xi, pdist_mat, sys_info, 'energy');          % collective change from energy based influence
  else
    internal_energy     = sparse(block_size, 1);                                                    % sparse zero matrix of size (d * N, 1)
  end                                                   
  if ~isempty(sys_info.phiA)                                                                        % find the alignment based influence
    internal_alignment  = find_collective_change(x, v, xi, pdist_mat, sys_info, 'alignment');       % collective change from alignment based influence
  else
    internal_alignment  = sparse(sys_info.d * sys_info.N, 1);                                       % sparse zero matrix of size (d * N, 1)
  end                                             
  external_change       = sys_info.Fv(v, xi);                                                       % find out the external force
  mass_vec              = kron(sys_info.agent_mass, ones(sys_info.d, 1));                           % prepare the mass vector for each agent, make it size (d * N, 1)
  rhs((block_size + 1) : (2 * block_size)) = (external_change + internal_energy + internal_alignment)./mass_vec; % m_i \dot{v}_i = F^v + F^E + F^A
  if sys_info.has_xi                                                                                % if the system has xi, calculate the udpate to xi
    internal_change     = find_collective_change(x, v, xi, pdist_mat, sys_info, 'xi');              % collective change from energy based influence    
    external_change     = sys_info.Fxi(xi, x);                                                      % the non-collective influence on xi
    rhs((2 * block_size + 1) : (2 * block_size + sys_info.N)) = external_change + internal_change;  % \dot{xi}_i = F^\xi + F^xi
  end
end
end
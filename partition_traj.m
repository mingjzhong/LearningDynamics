function pdist_info = partition_traj( traj, sys_info )
% function pdist_info = partition_traj( traj, sys_info )
%   finds the three kinds of pairwise distances: |x_i - x_i'|, |v_i - v_i'|, and/or |xi_i - xi_i'| 
%   from a dynamic where y is the evoluation variable which contains x_i, v_i, and/or xi_i, i.e.,
%   y(t) = (x_1(t), \cdots, x_N(t), v_1(t), \cdots, v_N(t), xi_1(t), \cdots, xi_N(t))^T, and partition 
%   the information into (k1, k2) pair, where k1, k2 are the types of the agents
% IN:
%   traj       : trajectory of the dynamics
%   sys_info   : system information struct for the whole dynamics
% OUT:
%   pdist_info : struct which contains the (upto) three kinds of pairwise distances and also the maximum
%                pairwise distances

% (c) M. Zhong, M. Maggioni, JHU

if sys_info.ode_order == 2                                                                          % second order system needs extra storage
  has_align             = ~isempty(sys_info.phiA);                                                  % find out if we need pdist_v
  has_xi                = sys_info.has_xi;                                                          % find out if we need pdist_xi
else                          
  has_align             = false;                                                                    % first order system has no pdist_v nor pdist_xi    
  has_xi                = false;
end
L                       = size(traj, 2);                                                            % the number of time instances which at observations are made
all_max_rs              = zeros(sys_info.K, sys_info.K, L);                                         % maximum |x_i - x_i'| at t_l
all_min_rs              = zeros(sys_info.K, sys_info.K, L);                                         % minimum |x_i - x_i'| at t_l
num_agents_each_type    = zeros(1,          sys_info.K);                                            % number of agents in each type
type_ind                = cell (1,          sys_info.K);                                            % C_k
pdist_x                 = cell (sys_info.K, sys_info.K);                                            % |x_i - x_i'| for each (k1, k2) pair
if has_align
  pdist_v               = cell(sys_info.K,sys_info.K);                                              % |v_i - v_i'| for each (k1, k2) pair
  all_max_rdots         = zeros(sys_info.K, sys_info.K, L);                                         % maximum |v_i - v_i'| at t_l
  all_min_rdots         = zeros(sys_info.K, sys_info.K, L);                                         % minimum |v_i - v_i'| at t_l
else
  pdist_v               = [];
end
if has_xi
  pdist_xi              = cell(sys_info.K,sys_info.K);                                              % |xi_i - xi_i'| for each (k1, k2) pair
  all_max_xis           = zeros(sys_info.K, sys_info.K, L);                                         % maximum |xi_i - xi_i'| at t_l
  all_min_xis           = zeros(sys_info.K, sys_info.K, L);                                         % minimum |xi_i - xi_i'|'s at t_l
else
  pdist_xi              = [];
end

block_size              = sys_info.d * sys_info.N;                                                  % d * N, the total of x_i and v_i

for l = 1 : L                                                                                       % start the paritoining by going through time
  x_at_t            = reshape(traj(1 : block_size, l), [sys_info.d, sys_info.N]);                   % find out the x_i's at time t_l
  pdist_x_at_t      = sqrt(sqdist_mod(x_at_t, x_at_t));                                             % calculate |x_i - x_i'|, using the MM routine sqdist_mod to avoid excessive transposes
  if has_align
    v_at_t          = reshape(traj((block_size + 1) : (2 * block_size), l), [sys_info.d, sys_info.N]);% find out the v_i's at time t_l
    pdist_v_at_t    = sqrt(sqdist_mod(v_at_t, v_at_t));                                              % calculate |v_i - v_i'|
  end
  if has_xi
    xi_at_t         = reshape(traj((2 * block_size + 1) : (2 * block_size + sys_info.N)), [1, sys_info.N]); % find out xi_i's at time t_l
    pdist_xi_at_t   = sqrt(sqdist_mod(xi_at_t, xi_at_t));                                           % calculate |xi_i - xi_i'|
  end
  for k_1 = 1 : sys_info.K                                                                          % go through each (k1, k2) pair to partition the data
    if l == 1 && k_1 == 1                                                                           % if this is the first time we encounter this, find out the info, save them
      agents_Ck1                 = find(sys_info.type_info == k_1);
      type_ind{k_1}              = agents_Ck1;
      num_agents_Ck1             = length(agents_Ck1);
      num_agents_each_type(k_1)  = num_agents_Ck1;
    else                                                                                            % for later time, we retrieve them
      agents_Ck1                 = type_ind{k_1};
      num_agents_Ck1             = num_agents_each_type(k_1);
    end
    for k_2 = 1 : sys_info.K                                                                        
      if l == 1                                                                                     % do the samething for k2
        if k_2 == 1
          agents_Ck2                 = type_ind{k_2};
          num_agents_Ck2             = num_agents_each_type(k_2);
        else
          agents_Ck2                 = find(sys_info.type_info == k_2);
          type_ind{k_2}              = agents_Ck2;
          num_agents_Ck2             = length(agents_Ck2);
          num_agents_each_type(k_2)  = num_agents_Ck2;
        end
      else
        agents_Ck2                   = type_ind{k_2};
        num_agents_Ck2               = num_agents_each_type(k_2);
      end
      if l == 1                                                                                     % initialize storage
        if k_1 == k_2                                                                               % for (k1, k2) with k1 == k2, if this type has more than 1 agent
          if num_agents_Ck1 > 1
            pdist_x{k_1, k_2}        = zeros(num_agents_Ck1 * (num_agents_Ck1 - 1)/2, L);
            if has_align
              pdist_v{k_1, k_2}      = zeros(num_agents_Ck1 * (num_agents_Ck1 - 1)/2, L);
            end
            if has_xi
              pdist_xi{k_1, k_2}     = zeros(num_agents_Ck1 * (num_agents_Ck1 - 1)/2, L);
            end
          else                                                                                      % otherwise do nothing
            pdist_x{k_1, k_2}        = [];
            if has_align
              pdist_v{k_1, k_2}      = [];
            end
            if has_xi
              pdist_xi{k_1, k_2}     = [];
            end
          end
        else                                                                                        % for (k1, k2) with k1 ~= k2, proceed as normal
          pdist_x{k_1, k_2}          = zeros(num_agents_Ck1 * num_agents_Ck2, L);
          if has_align
            pdist_v{k_1, k_2}        = zeros(num_agents_Ck1 * num_agents_Ck2, L);
          end
          if has_xi
            pdist_xi{k_1, k_2}       = zeros(num_agents_Ck1 * num_agents_Ck2, L);
          end
        end
      end
      pdist_x_Ck1_Ck2                 = pdist_x_at_t(agents_Ck1, agents_Ck2);                       % now partition the different kinds of pairwise distances in (k1, k2) pair
      if has_align
        pdist_v_Ck1_Ck2               = pdist_v_at_t(agents_Ck1, agents_Ck2);
      end
      if has_xi
        pdist_xi_Ck1_Ck2              = pdist_xi_at_t(agents_Ck1, agents_Ck2);
      end
      if k_1 == k_2                                                                                 % save the partitioned data, becareful about (k1, k2) with k1 == k2
         if num_agents_Ck1 > 1
           pdist_x{k_1, k_2}(:, l)      = squareform_tovector(pdist_x_Ck1_Ck2);                     % use squareform_tovector instead of the MATLAB built-in version
           if has_align
             pdist_v{k_1, k_2}(:, l)    = squareform_tovector(pdist_v_Ck1_Ck2);
           end
           if has_xi
             pdist_xi{k_1, k_2}(:, l)   = squareform_tovector(pdist_xi_Ck1_Ck2);
           end
         end
      else
        pdist_x{k_1, k_2}(:, l)       = pdist_x_Ck1_Ck2(:);                                         % for (k1, k2) with k1 ~= k2, proceeed as normal
        if has_align
          pdist_v{k_1, k_2}(:, l)     = pdist_v_Ck1_Ck2(:);
        end
        if has_xi
          pdist_xi{k_1, k_2}(:, l)    = pdist_xi_Ck1_Ck2(:);
        end
      end
      if ~isempty(pdist_x{k_1, k_2})
        all_max_rs(k_1, k_2, l)      = max(pdist_x{k_1, k_2}(:, l));
        all_min_rs(k_1, k_2, l)      = min(pdist_x{k_1, k_2}(:, l));        
      end
      if has_align && ~isempty(pdist_v{k_1, k_2})
        all_max_rdots(k_1, k_2, l) = max(pdist_v{k_1, k_2}(:, l));
        all_min_rdots(k_1, k_2, l) = min(pdist_v{k_1, k_2}(:, l));      
      end
      if has_xi && ~isempty(pdist_xi{k_1, k_2})
        all_max_xis(k_1, k_2, l)   = max(pdist_xi{k_1, k_2}(:, l));
        all_min_xis(k_1, k_2, l)   = min(pdist_xi{k_1, k_2}(:, l));        
      end
    end
  end
end
max_r                                 = max(all_max_rs,    [], 3);                                  % maximum r_ii' over all time
max_r(max_r == 0)                     = 1;                                                          % for (k1, k2) with k1 == k2, the r_ii' is always 0, can't construct a basis on [0, 0]
min_r                                 = min(all_min_rs,    [], 3);
if has_align
  max_rdot                            = max(all_max_rdots, [], 3);                                  % maximum \dot{r}_ii' over all time
  max_rdot(max_rdot == 0)             = 1;
  min_rdot                            = min(all_min_rdots, [], 3);
else
  max_rdot                            = [];
  min_rdot                            = [];
end
if has_xi
  max_xi                              = max(all_max_xis,   [], 3);                                  % maximum xi_ii' over all time
  max_xi(max_xi == 0)                 = 1;
  min_xi                              = min(all_min_xis,   [], 3);
else
  max_xi                              = [];
  min_xi                              = [];
end
% save the data in one big structure
pdist_info.pdist_x                    = pdist_x;
pdist_info.pdist_v                    = pdist_v;
pdist_info.pdist_xi                   = pdist_xi;
pdist_info.max_r                      = max_r;
pdist_info.min_r                      = min_r;
pdist_info.max_rdot                   = max_rdot;
pdist_info.min_rdot                   = min_rdot;
pdist_info.max_xi                     = max_xi;
pdist_info.min_xi                     = min_xi;
end
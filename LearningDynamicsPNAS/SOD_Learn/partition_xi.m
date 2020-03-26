function [energy_pdist, xi_pdiff, xi_reg, Psi_row_ind] = partition_xi(x, xi, sys_info)
% function [energy_pdist, xi_pdist, xi_pdiff, xi_regulator, Psi_row_ind] = partition_xi(x, xi, sys_info, learn_info)

% (c) M. Zhong (JHU)

% find out the number of time instances when observations are made
L                                           = size(xi, 2);
% find out the number of agents in the system
N                                           = sys_info.N;
% find out the size of the state vector in the system
d                                           = sys_info.d;
% find out how to regulate the dynamics
xi_regulator                                = sys_info.Rxi;
% find out the function which maps agent index to its class index
type_info                                   = sys_info.type_info;
% allocate the storage for the terms
energy_pdist                                = cell(sys_info.K);
xi_pdiff                                    = cell(sys_info.K);
xi_reg                                      = cell(sys_info.K);
% number of agents in each class
num_agents_each_class                       = zeros(1, sys_info.K);
% class indicator (logical indexing
agents_class_indicator                      = cell(1, sys_info.K);
% the row index to put \phi_{\ell}(|x_j - x_i|)(x_j - x_i)
Psi_row_ind                                 = cell(1, sys_info.K);
% go through time
for l = 1 : L
% find out the values of xi at time t
  xi_at_t                                   = transpose(xi(:, l));
% find out the position of the agents at time t
  x_at_t                                    = reshape(x(:, l), [d, N]);
% find out pairwise distance on x at time t, and changed to matrix form
  energy_pdist_at_t                         = squareform_tomatrix(pdist(transpose(x_at_t)));  
% find out the regulation information at time t
  if ~isempty(xi_regulator)
    xi_regulation                           = xi_regulator(xi_at_t, x_at_t);
  else
    xi_regulation                           = [];
  end
% find out the pairwise difference on x, both 1st and 2nd orders need it
  xi_pdiff_at_t                             = find_pair_diff(xi_at_t);
% partition the pairwise distances and differences into Ck1-Ck2 interaction
  for k_1 = 1 : sys_info.K
    if l == 1 && k_1 == 1
% find out the agents in class C_{s_1}, when this is at initial time, and k_1 is 1
      agents_Ck1                            = find(type_info == k_1);    
% find out the number of agents in class C_{s_1}
      num_agents_Ck1                        = length(agents_Ck1);
% save them
      agents_class_indicator{k_1}           = agents_Ck1;
      num_agents_each_class(k_1)            = num_agents_Ck1;
    else
% when we are not at initial time, or k_1 > 1, we retrieve it
      agents_Ck1                            = agents_class_indicator{k_1};
      num_agents_Ck1                        = num_agents_each_class(k_1);
    end
% calculate the row indices for saving the pairwise distances
    pdist_rows                              = transpose(1 : num_agents_Ck1) + (l - 1) * num_agents_Ck1;
% calculate the row indices for saving the pairwise differences, since xi is a 1D variable, this is the same as pdist_rows
    pdiff_rows                              = pdist_rows;
% find out the row indices in the learning matrix
    pdiff_row_ind                           = transpose(agents_Ck1);
% save the row indices in pdiff, remember a time skip of N * d rows
    Psi_row_ind{k_1}(pdiff_rows)            = pdiff_row_ind + (l - 1) * N;
% for k_2's
    for k_2 = 1 : sys_info.K
% if we are at the initial time
      if l == 1
% do it by cases
        if k_2 == 1
% if k_2 is also 1, we already have it
          agents_Ck2                        = agents_class_indicator{k_2};
          num_agents_Ck2                    = num_agents_each_class(k_2);
        else
% when k_2 > 1, we have to find it
          agents_Ck2                        = find(class_info == k_2);
          num_agents_Ck2                    = length(agents_Ck2);
% save them
          num_agents_each_class(k_2)        = num_agents_Ck2;
          agents_class_indicator{k_2}       = agents_Ck2;
        end
      else
% if l >1, past the initial time, we already have them
        agents_Ck2                          = agents_class_indicator{k_2};
        num_agents_Ck2                      = num_agents_each_class(k_2);
      end
% initialize some storage
      if l == 1
% the pairwise distance on x
        energy_pdist{k_1, k_2}              = zeros(L * num_agents_Ck1, num_agents_Ck2);      
% allocate storage for pairwise difference, xi is only 1d
        xi_pdiff{k_1, k_2}                  = zeros(L * num_agents_Ck1, num_agents_Ck2);
% for regulator
        xi_reg{k_1, k_2}                    = zeros(L * num_agents_Ck1, num_agents_Ck2);
      end
% partition the pairwise distance on x, and save it in energy_pdist
      pdist_Ck1_Ck2                         = energy_pdist_at_t(agents_Ck1, agents_Ck2);
      energy_pdist{k_1, k_2}(pdist_rows, :) = pdist_Ck1_Ck2;      
% save the regulation in regulator, partition that for each class-to-class interaction
      if ~isempty(xi_regulation)
        xi_reg{k_1, k_2}(pdist_rows, :)     = xi_regulation(agents_Ck1, agents_Ck2);
      else
% if this the first time
        if l == 1
          xi_reg{k_1, k_2}                  = [];
        end
      end
% partition the pdiff_data at time t for pdiff on x, retrieve the block according to C_s1 to C_s2 interaction   
      pdiff_Ck1_Ck2                         = xi_pdiff_at_t(pdiff_row_ind, agents_Ck2);
% takes up all the columns in this Cs1-Cs2 interaction, takes up all the rows in one time block, each time block takes up d *
% |C_{k_1}| rows
      xi_pdiff{k_1, k_2}(pdiff_rows, :)     = pdiff_Ck1_Ck2;      
    end
  end
end
end
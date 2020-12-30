function [energy_pdist, energy_pdiff, energy_reg, align_pdist, align_pdiff, align_reg, Psi_row_ind] ...
                                          = partition_x_and_v(x, v, sys_info, learn_info)
% [energy_pdist, energy_pdiff, energy_reg, align_pdist, align_pdiff, align_reg, Psi_row_ind] ...
% = partition_x_and_v(x, v, learning_info)

% Ming Zhong
% Postdoc Research at JHU

% find out the number of time instances when observations are made
L                                                   = size(x, 2);
% find out the number of agents in the system
N                                                   = sys_info.N;
% find out the size of the state vector for each agent
d                                                   = sys_info.d;
% find out the number of classes
K                                                   = sys_info.K;
% find out the function which maps agent index to its class index
type_info                                           = sys_info.type_info;
% the order of the ODE system
ode_order                                           = sys_info.ode_order;
% check to see if there are energy based terms
has_energy                                          = ~isempty(learn_info.Ebasis_info);
% check to see if there are alignment based terms
if ode_order == 1
  has_align                                         = false;
else
  has_align                                         = ~isempty(learn_info.Abasis_info);
end
% prepare the regulator functions
energy_regulator                                    = sys_info.RE;
if ode_order == 2 && has_align
  align_regulator                                   = sys_info.RA;
end
% allocate memory for the terms
energy_pdist                                        = cell(K);
% check to see if we need to prepare energy based stuff
if has_energy
  energy_pdiff                                      = cell(K);
  energy_reg                                        = cell(K);
else
  energy_pdiff                                      = [];
  energy_reg                                        = [];
end
% check to see if we need to prepare alignment based stuff
if has_align
  align_pdist                                       = cell(K);
  align_pdiff                                       = cell(K);
  align_reg                                         = cell(K);
else
  align_pdist                                       = [];
  align_pdiff                                       = [];
  align_reg                                         = [];
end
% the row indices in the Phi, learning matrix
Psi_row_ind                                         = cell(1, K);
% number of agents in each class
num_agents_each_class                               = zeros(1, K);
% class indicator (logical indexing
agents_class_indicator                              = cell(1, K);
% row indices in Phi (without time
row_ind_Phi_all_class                               = cell(1, K);
% go through time
for l = 1 : L
% find out the position of the agents at time t, and reshaped into a matrix of size [d, N]
  x_at_t                                            = reshape(x(:, l), [d, N]);
% find out the velocity of agents at time t
  if ode_order == 1
    v_at_t                                          = [];
  else
    v_at_t                                          = reshape(v(:, l), [d, N]);  
  end
% find out pairwise distance on x at time t, and changed to matrix form
  x_pdist                                           = squareform_tomatrix(pdist(transpose(x_at_t)));
% find out the energy based terms  
  if has_energy
% find out the pairwise difference on x if there are energy terms    
    x_pdiff                                         = find_pair_diff(x_at_t);
% find out the regulation information at time t
    if ~isempty(energy_regulator)
      energy_regulation                             = energy_regulator(x_at_t);
    else
      energy_regulation                             = [];
    end
  end
% find out the alignment based terms  
  if has_align
% find out the pairwise difference on v if there are alignment terms    
    v_pdiff                                         = find_pair_diff(v_at_t);
% find out the regulation information at time t
    if ~isempty(align_regulator)
      align_regulation                              = align_regulator(x_at_t, v_at_t);
    else
      align_regulation                              = [];
    end
% find out the pairwise distance on v
    v_pdist                                         = squareform_tomatrix(pdist(transpose(v_at_t)));
  end
% go through each (Ck1, Ck2) interaction
  for k_1 = 1 : K
% find out the agent indices in this C_k1 class    
    if l == 1 && k_1 == 1
% only do it at the initial time and k_1 = 1, find out the agent indices      
      agents_Ck1                                    = find(type_info == k_1);
% save it      
      agents_class_indicator{k_1}                   = agents_Ck1;
% find out the number of agents in this C_k1 class      
      num_agents_Ck1                                = length(agents_Ck1);
% save it      
      num_agents_each_class(k_1)                    = num_agents_Ck1;
    else
% find out the agent indices in saved data     
      agents_Ck1                                    = agents_class_indicator{k_1};
% find out the number of agents in saved data
      num_agents_Ck1                                = num_agents_each_class(k_1);
    end
% calculate the row indices in energy_pdist, align_pdist, energy_reg, align_reg for saving the pair_dist/regulation data
% since energy_pdist and energy_reg have the same size, so they share the same indices (similar indexing goes to align_pdist and
% align_reg)
    row_ind_in_pdist                                = transpose(1 : num_agents_Ck1)     + (l - 1) * num_agents_Ck1;
% calculate the row indices in energy_pdiff, align_pdiff, and the Phi matrices for savng the pair_diff data
    row_ind_in_pdiff                                = transpose(1 : num_agents_Ck1 * d) + (l - 1) * num_agents_Ck1 * d;
% calculate row indices in Phi (without time) only at initial time
    if l == 1
% calculate the row indices in the Phi matrix for saving the basis data, the number of rows is L * N * d
      row_ind_Phi                                   = repmat(transpose(1 : d), [num_agents_Ck1, 1]);
% add in the offset due to positioning: [x_1; x_2; \vdots; x_N], time shift is added in later
      row_ind_Phi                                   = row_ind_Phi + kron((transpose(agents_Ck1) - 1) * d, ones(d, 1));
% save it
      row_ind_Phi_all_class{k_1}                    = row_ind_Phi;
    else
      row_ind_Phi                                   = row_ind_Phi_all_class{k_1};
    end
% initialize some quantity
    if l == 1
% the row indices in the Phi matrices      
      Psi_row_ind{k_1}                              = zeros(L * num_agents_Ck1 * d, 1);      
    end
% save the row indices, remember the time shift
    Psi_row_ind{k_1}(row_ind_in_pdiff)              = row_ind_Phi + (l - 1) * N * d;  
    for k_2 = 1 : K
      if l == 1
% for the initial time        
        if k_2 == 1
% if k_2 =1, then the results is already known from k_1, the agent indices
          agents_Ck2                                = agents_class_indicator{k_2};
% the number of agents          
          num_agents_Ck2                            = num_agents_each_class(k_2);
        else
% when k_2 > 1, we have to find them, the agent indices          
          agents_Ck2                                = find(type_info == k_2);
% save it          
          agents_class_indicator{k_2}               = agents_Ck2;
% the number of agents          
          num_agents_Ck2                            = length(agents_Ck2);
% save it
          num_agents_each_class(k_2)                = num_agents_Ck2;          
        end      
      else
% for any other times, just retrieve it, the agent indices        
        agents_Ck2                                 = agents_class_indicator{k_2};
% the number of agents
        num_agents_Ck2                             = num_agents_each_class(k_2);
      end
% initialize the storage in energy_pdist, pdist_x, energy_pdiff, energy_reg, align_pdist, pdist_v, align_pdiff, align_reg
      if l == 1
% energy_pdist and pdist_x are needed for both 1st order and 2nd order systems
        energy_pdist{k_1, k_2}                     = zeros(L * num_agents_Ck1,     num_agents_Ck2);      
% energy based terms        
        if has_energy
% for energy_pdiff and energy_reg              
          energy_pdiff{k_1, k_2}                   = zeros(L * num_agents_Ck1 * d, num_agents_Ck2);
% for regulator
          energy_reg{k_1, k_2}                     = zeros(L * num_agents_Ck1,     num_agents_Ck2);       
        end
% for alignment based terms       
        if has_align
% this is only needed for calculating the L2_rho norm and adaptive learn          
          align_pdist{k_1, k_2}                    = zeros(L * num_agents_Ck1,     num_agents_Ck2);          
% allocate storage for pairwise difference          
          align_pdiff{k_1, k_2}                    = zeros(L * num_agents_Ck1 * d, num_agents_Ck2);
% for regulator        
          align_reg{k_1, k_2}                      = zeros(L * num_agents_Ck1,     num_agents_Ck2);      
        end
      end
% partition the pdist data on x at time t, pdist_mat is of size [N, N], according to (C_k1, C_k2) interaction
      x_pdist_Ck1_Ck2                              = x_pdist(agents_Ck1, agents_Ck2);
% save the energy based pairwise distance
      energy_pdist{k_1, k_2}(row_ind_in_pdist, :)  = x_pdist_Ck1_Ck2;      
% save the regulation in regulator, partition that for each class-to-class interaction
      if has_energy 
        if ~isempty(energy_regulation)
          energy_reg{k_1, k_2}(row_ind_in_pdist, :) = energy_regulation(agents_Ck1, agents_Ck2);
        else
% if this the first time
          if l == 1
            energy_reg{k_1, k_2}                    = [];
          end
        end
% partition the pdiff_data at time t for pdiff on x, retrieve the block according to (C_k1, C_k2) interaction         
        x_pdiff_Ck1_Ck2                             = x_pdiff(row_ind_Phi, agents_Ck2);
% takes up all the columns in this Cs1-Cs2 interaction
% takes up all the rows in one time block, each time block takes up d *
% |C_{s_1}| rows      
        energy_pdiff{k_1, k_2}(row_ind_in_pdiff, :) = x_pdiff_Ck1_Ck2;        
      end
% if there is alignment based force
      if has_align
% partition the pdist data on v at time t         
        v_pdist_Ck1_Ck2                             = v_pdist(agents_Ck1, agents_Ck2);
% save it in align_pdist
        align_pdist{k_1, k_2}(row_ind_in_pdist, :)  = v_pdist_Ck1_Ck2;
% save the regulation in regulator partition that for each class-to-class interaction        
        if ~isempty(align_regulation)
          align_reg{k_1, k_2}(row_ind_in_pdiff, :)  = align_regulation(agents_Ck1, agents_Ck2);
        else
% if this the first time
          if l == 1
            align_reg{k_1, k_2}                     = [];
          end
        end
% partition the pdiff_data at time t for pdiff on x
% retrieve the block according to C_s1 to C_s2 interaction         
        v_pdiff_Ck1_Ck2                             = v_pdiff(row_ind_Phi, agents_Ck2);
% takes up all the columns in this Cs1-Cs2 interaction
% takes up all the rows in one time block, each time block takes up d * |C_{s_1}| rows      
        align_pdiff{k_1, k_2}(row_ind_in_pdiff, :)  = v_pdiff_Ck1_Ck2;        
      end
    end
  end
end
end

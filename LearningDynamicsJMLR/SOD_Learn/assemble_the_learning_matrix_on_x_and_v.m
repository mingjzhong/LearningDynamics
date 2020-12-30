function [energy_Phi, align_Phi] = assemble_the_learning_matrix_on_x_and_v(energy_pdist, ...
         energy_pdiff, energy_regulator, energy_basis, align_pdiff, align_regulator, align_basis, ...
         time_vec, agents_info, Phi_row_ind, sys_info)
% function [energy_Phi, align_Phi] = assemble_the_learning_matrix_on_x_and_v(energy_pdist, ...
% energy_pdiff, energy_regulator, energy_basis, align_pdiff, align_regulator, align_basis, ...
% time_vec, agents_info, Phi_row_ind, sys_info)

% (c) M. Zhong

ISSPARSE                = false;

has_energy              = ~isempty(energy_basis);
has_align               = ~isempty(align_basis);
L                       = length(time_vec);
if has_energy
  energy_each_class   = cellfun(@(x) length(x.f),energy_basis);
  total_energy_basis  = sum(energy_each_class(:));
end
if has_align
  align_each_class    = cellfun(@(x) length(x.f),align_basis);
  total_align_basis   = sum(align_each_class(:));
end

% allocate the storage for the learning matrix Phi
if has_energy,  energy_Phi      = spalloc(L * sys_info.N * sys_info.d,total_energy_basis, 10*L * sys_info.N * sys_info.d );
else,           energy_Phi      = [];   end
if has_align,   align_Phi       = spalloc(L * sys_info.N * sys_info.d,total_align_basis, 10*L * sys_info.N * sys_info.d );
else,           align_Phi       = [];   end

if ~ISSPARSE, energy_Phi = full(energy_Phi); align_Phi = full(align_Phi);   end

% remember the number of basis functions from previous class-to-class interaction
if has_energy,  num_prev_energy = 0;    end
if has_align,   num_prev_align  = 0;    end

if has_energy                                                                                       % Energy-type interactions    
    for k_1 = 1 : sys_info.K                                                                        % go through each (Ck1, Ck2) interaction
        for k_2 = 1 : sys_info.K
            ind_1               = num_prev_energy + 1;                                              % the starting column index to put class_influence in the Phi matrix
            ind_2               = num_prev_energy + energy_each_class(k_1, k_2);
            num_prev_energy     = num_prev_energy + energy_each_class(k_1, k_2);                    % update the number of basis functions from previous (C_k1, C_k2) interaction
            if k_1 == k_2 && agents_info.num_agents(k_2) == 1
              energy_Phi(Phi_row_ind{k_1}, ind_1 : ind_2)       = 0;                                % no interaction on a class of single agent
            else
              class_influence = ...                                                                 % find out the influence from basis functions: \psi_l(|x_j - x_i|)(v_j - v_i) or \psi_l(|x_j - x_i|)(v_j - v_i), for i \in C_k1, and j \in C_k2 for energy based influence
                  find_class_influence(   energy_basis{k_1, k_2}, energy_pdist{k_1, k_2}, ...
                  energy_regulator{k_1, k_2}, energy_pdiff{k_1, k_2}, ...
                  sys_info.d, agents_info.num_agents(k_2), sys_info.kappa(k_2),ISSPARSE);
              energy_Phi(Phi_row_ind{k_1}, ind_1:ind_1+size(class_influence,2)-1) = class_influence;
            end
        end
    end
end

if has_align                                                                                        % do the same thing over again for alignment terms
    for k_1 = 1 : sys_info.K                                                                        % go through each (Ck1, Ck2) interaction
        for k_2 = 1 : sys_info.K
            % the starting column index to put class_influence in the Phi matrix
            ind_1                                      = num_prev_align + 1;
            ind_2                                      = num_prev_align + align_each_class(k_1, k_2);
            % update the number of basis functions from previous (C_k1, C_k2) interaction
            num_prev_align                             = num_prev_align + align_each_class(k_1, k_2);
            % for each (C_k1, C_k2) pair, for (C_k1, C_k1) (k_1 == k_2) be careful
            if k_1 == k_2 && agents_info.num_agents(k_2) == 1
                % no interaction on a class of single agent
                align_Phi(Phi_row_ind{k_1}, ind_1 : ind_2)         = 0;
            else
                % find out the influence from basis functions: \psi_l(|x_j - x_i|)(v_j - v_i) or \psi_l(|x_j - x_i|)(v_j - v_i)
                % for i \in C_k1, and j \in C_k2 for energy based influence
                class_influence  = find_class_influence(align_basis{k_1, k_2}, energy_pdist{k_1, k_2}, align_regulator{k_1, k_2}, align_pdiff{k_1, k_2}, ...
                    sys_info.d, agents_info.num_agents(k_2), sys_info.kappa(k_2),ISSPARSE);
                % save it in align_Phi
                align_Phi(Phi_row_ind{k_1}, ind_1:ind_1+size(class_influence,2)-1)  = class_influence;
            end
        end
    end
end

return
function [phiEknots, energy_basis, pdist_x, align_knots, align_basis, pdist_v, Phi, rhs_vec, ...
    extra] = parallel_assemble_x_and_v(x_d, v_d, xi_d, dot_xv_d, time_vec, sys_info, learn_info)
% [phiEknots, energy_basis, pdist_x, align_knots, align_basis, pdist_v, Phi, rhs_vec, ...
% extra_x_and_v] = parallel_assemble_x_and_v(x_d, v_d, xi_d, dot_xv_d, time_vec_d, learning_info)

% (c) Ming Zhong, Mauro Maggioni (JHU)

if ~isfield(learn_info,'VERBOSE'), learn_info.VERBOSE = 2; end
VERBOSE = learn_info.VERBOSE;

if VERBOSE>1, fprintf('Starting from the client side.\nInitializing data for workers.');    end

Rs_tag              = 0;                                                                            % define the tags for data communication (shared by all workers)
energy_basis_tag    = 1;
align_basis_tag     = 2;
num_Phi_cols_tag    = 3;

num_classes         = sys_info.K;                                                                   % find out the number of classes
has_v               = ~isempty(v_d);                                                                % find out if the system has v
has_xi              = ~isempty(xi_d);                                                               % find out if the system has xi
has_derivative      = ~isempty(dot_xv_d);                                                           % find out if the system is given derivative information
has_energy          = ~isempty(learn_info.Ebasis_info);                                             % check to see if the system has energy terms
has_align           = isfield(learn_info,'align_basis_info') && ...
                        ~isempty(learn_info.align_basis_info) && has_v;

spmd                                                                                                % do individual work on the worker side
    if VERBOSE>1,       fprintf('\n Lab = %d: ...', labindex);          end
    if labindex == 1, num_cores_l = numlabs; else, num_cores_l = [];    end                         % Lab(1) is in charge of communicating, so it has to know the number of workers in the system
    
    x               = getLocalPart(x_d);                                                            % get a local copies of x_d and see if I need to work, since x is only used on worker side, not '_l'
    
    if ~isempty(x)                                                                                  % based on the local copy of x (on this worker), it decide to work or stay idle
        has_3D      = length(size(x)) ==  3;                                                        % find out number of Monte Carlo realizations this worker is assigned to
        if has_3D
            M       = size(x, 3);
        else
            M       = 1;
        end
        
        if VERBOSE>1
            if ~has_3D
                fprintf('\nLab = %d: My copy of x has size [%d, %d]',     labindex, size(x, 1), size(x, 2));
            else
                fprintf('\nLab = %d: My copy of x has size [%d, %d, %d].', labindex, size(x, 1), size(x, 2), M);
            end
        end
        
        if VERBOSE>1,  fprintf('\nLab = %d: initializing variables.', labindex);    end
        
        if has_v,           v       = getLocalPart(v_d);            else,   v       = [];   end     % get local copies of v, xi, time_vec, and dot_xv
        if has_xi,          xi      = getLocalPart(xi_d);           else,   xi      = [];   end
        if has_derivative,  dot_xv  = getLocalPart(dot_xv_d);       else,   dot_xv  = [];   end
        
        pdist_x_l               = cell(1, M);                                                       % allocate storage for MC ealizations: energy based terms, pdist_x_l will be assembled later on
        if has_align, pdist_v_l = cell(1, M);       else,   pdist_v_l = []; end                     % alignment-based terms, pdist_v_l will be assembled later
        
        all_Rs          = zeros(num_classes, num_classes, M);                                       % maximum interaction radii
        
        if VERBOSE>1,   fprintf('\nLab = %d: MC assembly of maximum radii first.', labindex); end   % go through the MC loop to find the maximum interaction radii, which are needed (first found the maximum over all
        
        for m = 1 : M                                                                               % samples on all cores, needed communication) for constructing basis for all cores (same basis for all)
            one_x                               = squeeze(x(:, :, m));                              % find the portion of x
            if has_v,   one_v = squeeze(v(:, :, m)); else,    one_v = [];     end                   % find the portion of v when it's present
            
            [one_pdist_x, one_pdist_v, one_Rs, one_num_agents_each_class] = ...
                find_pdist_x_and_v(one_x, one_v, sys_info, learn_info);                             % find out the maximum radii on the MC sample
            pdist_x_l{m}                        = one_pdist_x;                                      % save the data
            
            if has_v,   pdist_v_l{m}            = one_pdist_v; end                                  % save the data
            if m == 1,  num_agents_each_class   = one_num_agents_each_class; end                    % save the num_agents_each_class only at the first time
            all_Rs(:, :, m)                     = one_Rs;                                           % save the radii
        end
        
        if VERBOSE>1                                                                                % done the local MC steps
            fprintf('\nLab = %d: MC assembling is done.', labindex);
            fprintf('\nLab = %d: Find out the maximum radii on my local copies.', labindex);
        end
        
        Rs_l                                    = zeros(num_classes);                               % find out the maximum interation radii on the worker, (local copy)
        for k_1 = 1 : num_classes                                                                   % for each (C_k1, C_k2) pair, go through all MC realizations
            for k_2 = 1 : num_classes
                max_R_over_MC                   = max(squeeze(all_Rs(k_1, k_2, :)));
                if max_R_over_MC == 0, max_R_over_MC= 1; end                                        % in the case of a class of single agent, the interaction radius is 0, since there is no data, in order to still able to build a basis, set it to 1 instead
                Rs_l(k_1, k_2)                  = max_R_over_MC;                                    % save the maximum radius for each (C_k1, C_k2) pair
            end
        end
        if VERBOSE>1, fprintf('\nLab = %d: Ready for communication.', labindex);     end
        
        if labindex ~= 1                                                                            % now we are ready to send Rs_l over to other Labs
            if VERBOSE>1
                fprintf('\nLab%d: sending copy of Rs_l (tag = %d) to Lab (01).', labindex, Rs_tag); % Lab(01) is to assemble the maximum, other labs send its own maximum interaction radii to Lab (01)
            end
            labSend(Rs_l, 1, Rs_tag);                                                               % use a tag identifier to identify this piece of data as Rs
            Rs_l    = [];                                                                           % after the data is send, release the memory
        else
            if VERBOSE>1
                fprintf('\nLab%d: receiving data (Rs_l, tag = %d).', labindex, Rs_tag);             % receive the data from other workers (in a loop) and find out the maximum interaction radii among all workers
            end
            for lab_ind = 2 : num_cores_l                                                           % use a loop
                other_Rs                        = labReceive(lab_ind, Rs_tag);
                Rs_l                            = max(Rs_l, other_Rs);                              % find out the maximum interaction radius across by comparing this copy of Rs to other local copy no need to send this Rs_l over, the client will have a copy later
            end
        end
        
        if labindex == 1                                                                            % now we are ready to build the basis, only do it on Lab(01), no need to repeat it
            [energy_basis_l, phiEknots_l, align_basis_l, align_knots_l] = ...
                uniform_basis_on_x_and_v(Rs_l, sys_info, learn_info);                               % build the basis, these quantities will be assembled later (however the copy on Lab(01) will be assembled)
            if has_energy                                                                           % calculate the number of energy based basis functions for energy_Phi later
                num_energy_Phi_cols             = 0;
                for k_1 = 1 : num_classes
                    for k_2 = 1 : num_classes
                        num_energy_Phi_cols     = num_energy_Phi_cols+length(energy_basis_l{k_1, k_2});
                    end
                end
            else
                num_energy_Phi_cols             = 0;
            end
            
            if has_align                                                                            % calculate the number of alignment based basis functions for align_Phi later
                num_align_Phi_cols              = 0;
                for k_1 = 1 : num_classes
                    for k_2 = 1 : num_classes
                        num_align_Phi_cols      = num_align_Phi_cols + length(align_basis_l{k_1, k_2});
                    end
                end
            else
                num_align_Phi_cols              = 0;
            end
            
            num_Phi_cols                        = num_energy_Phi_cols + num_align_Phi_cols;         % calculate the total number of columns for the (put-together) learning matrix Phi
            
            % print ouf the tags
            if VERBOSE>1
                fprintf('\nLab%d: The data tags for the difference kinds of data are:', labindex);
                fprintf('  energy_basis_l: tag = %d.', energy_basis_tag);
                fprintf('  align_basis_l:  tag = %d.', align_basis_tag);
                fprintf('  num_Phi_cols:   tag = %d.', num_Phi_cols_tag);
            end
            % send these 6 pieces of data to other workers
            for lab_ind = 2 : num_cores_l
                if VERBOSE>1
                    fprintf('\nLab%d: sending 3 pieces of data, with 3 different tags,to Lab%d.', labindex, lab_ind);
                end
                labSend(energy_basis_l, lab_ind, energy_basis_tag);
                labSend(align_basis_l,  lab_ind, align_basis_tag);
                labSend(num_Phi_cols,   lab_ind, num_Phi_cols_tag);
            end
        else
            % for other workers, just receive the basis information from Lab(01)
            if VERBOSE>1, fprintf('\nLab%d: receiving identifying data from Lab%d.',labindex,1); end
            energy_basis_l                      = labReceive(1, energy_basis_tag);
            align_basis_l                       = labReceive(1, align_basis_tag);
            num_Phi_cols                        = labReceive(1, num_Phi_cols_tag);
            % if I am not Lab (01), then I have no need to store the knot vectors
            phiEknots_l                         = [];
            align_knots_l                       = [];
        end
        
        if VERBOSE>1, fprintf('\nLab%d: Ready for Phi and rhs_vec assembly.', labindex);    end     % now we are ready to assemble the learning matrices
        Phi_l                                   = sparse(num_Phi_cols, num_Phi_cols);               % allocate memory for Phi_l and rhs_vec_l
        rhs_vec_l                               = sparse(num_Phi_cols, 1);
        
        if VERBOSE>1, fprintf('\nLab = %d: Run in MC loops again.', labindex);              end     % start the MC loop
        
        rhs_in_l2_norm_sq_l                     = 0;                                                % save the square of l_2 norm of d_vec - F_vec over all m's
        for MC_ind = 1 : M
            one_x                                 = squeeze(x(:, :, MC_ind));                       % find the portion of x
            
            if has_v, one_v = squeeze(v(:, :, MC_ind)); else, one_v = []; end                       % find the portion of v when it is present
            
            if has_xi, one_xi = squeeze(xi(:, :, MC_ind)); else, one_xi = []; end                   % find out the portion of xi when it is present
            
            if has_derivative, one_dot_xv = squeeze(dot_xv(:, :, MC_ind)); else, one_dot_xv = [];end% find out the portion of derivative information when it is present
            
            [one_energy_Phi, one_align_Phi, one_the_F, one_d_vec] ...                               % find out: learning matrix on energy terms, learning matrix on alignemnt terms, non-collective influences, derivative terms
                = one_step_assemble_on_x_and_v(one_x, one_v, one_xi, one_dot_xv, ...
                time_vec, num_agents_each_class, energy_basis_l, align_basis_l, sys_info, learn_info);                                                          
            one_rhs_vec                           = one_d_vec - one_the_F;                          % assemble the right handside
            one_Phi                               = [one_energy_Phi, one_align_Phi];
            rhs_in_l2_norm_sq_l                   = rhs_in_l2_norm_sq_l + norm(one_rhs_vec)^2;      % now calculate the l_2 norm of one_rhs_vec (for this MC realization, and remember to square it)
            Phi_l                                 = Phi_l + transpose(one_Phi) * one_Phi;           % assemble the Phi matrix and rhs_vec (right handside vector)
            rhs_vec_l                             = rhs_vec_l + transpose(one_Phi) * one_rhs_vec;
        end
        if VERBOSE>1, fprintf('\nLab = %d: MC assembly is done.', labindex);                end     % let the user konw it is done
    else                                                                                            % if the worker has nothing do to, initialize the following to empty
        num_cores_l             = [];
        pdist_x_l               = [];
        pdist_v_l               = [];
        Rs_l                    = [];
        energy_basis_l          = [];
        phiEknots_l             = [];
        align_basis_l           = [];
        align_knots_l           = [];
        Phi_l                   = [];
        rhs_vec_l               = [];
        rhs_in_l2_norm_sq_l     = [];
    end
end
if VERBOSE>1,   fprintf('\nBack to client side.\nAssembling data.');                        end     % now back to the client side and assemble pdist_x, pdist_v (if there is any), Phi, rhs_vec, and Rs
if has_xi, extra.Rs = Rs_l{1}; end                                                                  % only need the copy from Lab(01), in fact there is only one avaiable copy

rhs_in_l2_norm_sq               = sum([rhs_in_l2_norm_sq_l{:}]);                                    % we also need the sum of all square of the l_2 norm of d_vec - F_vec over all m's
extra.rhs_in_l2_norm_sq         = rhs_in_l2_norm_sq;
num_cores                       = num_cores_l{1};                                                   % now assemble the data: find out the number of works
for lab_ind = 1 : num_cores                                                                         % assemble the Phi matrices, F_vec and d_vec
    if lab_ind == 1
        Phi                     = Phi_l{lab_ind};
        rhs_vec                 = rhs_vec_l{lab_ind};
    else
        Phi_lab                 = Phi_l{lab_ind};
        if ~isempty(Phi_lab)
            Phi                 = Phi + Phi_lab;
            rhs_vec             = rhs_vec + rhs_vec_l{lab_ind};
        end
    end
end

energy_basis    = energy_basis_l{1};                                                                % find out energy_basis, phiEknots, align_basis, and align_knots, just need the copy from Lab(01)
phiEknots       = phiEknots_l{1};
align_basis     = align_basis_l{1};
align_knots     = align_knots_l{1};

pdist_x         = [pdist_x_l{:}];                                                                   % assemble pdist_x and pdist_v, just simply change the composite variable back into one
if has_align
    pdist_v     = [pdist_v_l{:}];
else
    pdist_v     = [];
end

if VERBOSE>1,   fprintf('\nFinished!!');                                                    end

return
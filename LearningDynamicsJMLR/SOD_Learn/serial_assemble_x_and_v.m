function [Estimator, extra, Timings] = serial_assemble_x_and_v(x, v, xi, dot_xv, time_vec, sys_info, learn_info)

%
% function [Estimator, extra, Timings] = serial_assemble_x_and_v(x, v, xi, dot_xv, time_vec, sys_info, learn_info)

%
% OUT:
%   Estimator:  structure with fields:
%           Ebasis, Abasis, Phi, rhs_vec

% (c) M. Zhong, M. Maggioni, JHU

% MM: One possible change here would be to use the pairwise distances computed here to get the \rhoLT estimator. Currently that is computed elsewhere, duplicating the calculation of pairwise distances.

VERBOSE             = 0;
M                   = size(x, 3);                                                                   % find out the number Monte Carlo realizations
has_v               = ~isempty(v);                                                                  % find out if the system has v
has_xi              = ~isempty(xi);                                                                 % find out if the system has xi
has_derivative      = ~isempty(dot_xv);                                                             % find out if the derivative information is given
has_align           = ~isempty(v) && ~isempty(learn_info.Abasis_info);                              % find out if we have alignment-based terms
has_energy          = ~isempty(learn_info.Ebasis_info);                                             % find out if we have energy-based terms                                            % maximum interaction radii
agents_info         = getAgentInfo( sys_info );
N_per_class         = histcounts( sys_info.type_info, 0.5:1:sys_info.K+1 );

Timings.findRs      = tic;
Mtrajs          = [x; v; xi];
max_rs          = zeros(sys_info.K, sys_info.K, M);
for m = 1 : M
    traj        = squeeze(Mtrajs(:, :, m));
    output      = find_maximums(traj, sys_info);
    max_rs(:, :, m)   = output.max_rs;
end
Rs              = max(max_rs, [], 3);
% if isfield(learn_info,'Rsupp') && ~isempty(learn_info.Rsupp.R)
%   for k1 = 1 : sys_info.K
%     for k2 = 1 : sys_info.K
%       Rs(k1, k2) = max([Rs(k1, k2), learn_info.Rsupp.R{k1, k2}(2)]);
%     end
%   end
% end
Timings.findRs      = toc(Timings.findRs);

if VERBOSE>1, fprintf('\n\tAssembling Rs takes %10.4e sec.', Timings.findpdistxv);   end

if VERBOSE>1, fprintf('\nConstruct the basis...');      end                                         % now we are ready to build the basis
Timings.uniformbasisxv                  = tic;
[Estimator.Ebasis, Estimator.Abasis]    = uniform_basis_on_x_and_v( Rs, sys_info, learn_info );
Timings.uniformbasisxv                  = toc(Timings.uniformbasisxv);

if has_energy,  num_energy_Estimator.Phi_cols     = sum(sum(cellfun(@(x) length(x.f), Estimator.Ebasis)));              % calculate the number of energy based basis functions for energy_Estimator.Phi later
else,           num_energy_Estimator.Phi_cols     = 0;            end
if has_align,   num_align_Estimator.Phi_cols      = sum(sum(cellfun(@(x) length(x.f), Estimator.Abasis)));              % calculate the number of alignment based basis functions for align_Estimator.Phi later
else,           num_align_Estimator.Phi_cols      = 0;            end
if VERBOSE>1,  fprintf('done (%10.4e sec).', toc(tstart));end

Timings.assembleEstimator.Phi   = tic;                                                              % now ready to build Estimator.Phi and Estimator.rhs_vec
num_Estimator.Phi_cols          = num_energy_Estimator.Phi_cols + num_align_Estimator.Phi_cols;     % find out the total number fo columns for the Estimator.Phi matrix

% if ~has_v,          v       = cell(1,size(x,2),size(x,3));   end
% if ~has_xi,         xi      = cell(1,size(x,2),size(x,3));   end
% if ~has_derivative, dot_xv  = cell(1,size(x,2),size(x,3));   end

PARALLEL = false;

if VERBOSE>1, fprintf('\nAssembling the matrices for the optimization problem...');      end        % now we are ready to build the basis
if ~PARALLEL
    Estimator.Phi                         = zeros(num_Estimator.Phi_cols, num_Estimator.Phi_cols);  % allocate the memory for Estimator.Phi matrix and rhs (the right handside vector)
    Estimator.rhs_vec                     = zeros(num_Estimator.Phi_cols, 1);
    rhs_in_l2_norm_sq           = 0;                                                                % save the square of l_2 norm of d_vec - F_vec over all m's
    
    for m = 1 : M                                                                                   % start the MC loop
        one_x                           = x(:, :, m);                                               % find the portion of x
        if has_v,           one_v       = v(:, :, m);       else,   one_v       = [];   end
        if has_xi,          one_xi      = xi(:, :, m);      else,   one_xi      = [];   end
        if has_derivative,  one_dot_xv  = dot_xv(:, :, m);  else,   one_dot_xv  = [];   end
        
        [one_energy_Estimator.Psi, one_align_Estimator.Psi, one_F_vec, one_d_vec,timings]   = ...
            one_step_assemble_on_x_and_v(one_x, one_v, one_xi, ...
            one_dot_xv, time_vec, agents_info, Estimator.Ebasis, Estimator.Abasis, sys_info, learn_info);
        one_rhs_vec             = one_d_vec - one_F_vec;                                            % assemble the right handside vector
        one_Psi                 = [one_energy_Estimator.Psi, one_align_Estimator.Psi];
        rhs_in_l2_norm_sq       = rhs_in_l2_norm_sq + norm(one_rhs_vec)^2;                          % update the l_2 norm squared of one_rhs_vec
        one_PsiT                = transpose(one_Psi);
        Estimator.Phi           = Estimator.Phi + one_PsiT * one_Psi;                               % assemble the true Estimator.Phi matrix
        Estimator.rhs_vec       = Estimator.rhs_vec + one_PsiT * one_rhs_vec;
    end
else                                                                                                % MM: This takes a lot of memory...
    rhs_in_l2_norm_sq_a = zeros(M,1);
    for m = M:-1:1
        Estimator.Phi_a{m} = zeros(num_Estimator.Phi_cols,num_Estimator.Phi_cols);
        Estimator.rhs_vec_a{m} = zeros(num_Estimator.Phi_cols,1);
    end
    
    for m = 1 : M                                                                                   % start the MC loop
        one_x                           = x(:, :, m);                                               % find the portion of x
        if has_v,           one_v       = v(:, :, m);       else,   one_v       = [];   end
        if has_xi,          one_xi      = xi(:, :, m);      else,   one_xi      = [];   end
        if has_derivative,  one_dot_xv  = dot_xv(:, :, m);  else,   one_dot_xv  = [];   end
        
        [one_energy_Estimator.Psi, one_align_Estimator.Psi, one_the_F, one_d_vec,timings]   = ...
            one_step_assemble_on_x_and_v(one_x, one_v, one_xi, ...
            one_dot_xv, time_vec, N_per_class, Estimator.Ebasis, Estimator.Abasis, sys_info, learn_info);
        one_rhs_vec             = one_d_vec - one_the_F;                                            % assemble the right handside vector
        one_Psi                 = [one_energy_Estimator.Psi, one_align_Estimator.Psi];
        rhs_in_l2_norm_sq_a(m)  = norm(one_rhs_vec)^2;                                              % update the l_2 norm squared of one_rhs_vec
        one_PsiT                = transpose(one_Psi);
        Estimator.Phi_a{m}      = one_PsiT * one_Psi;                                               % assemble the true Estimator.Phi matrix
        Estimator.rhs_vec_a{m}  = one_PsiT * one_rhs_vec;
    end
    
    for m = 1:M
        Estimator.Phi     = Estimator.Phi+Estimator.Phi_a{m};
        Estimator.rhs_vec = Estimator.rhs_vec + Estimator.rhs_vec_a{m};
    end
    rhs_in_l2_norm_sq = sum(rhs_in_l2_norm_sq_a);
    
end
Timings.one_step_assemble_on_x_and_v  = timings;                                                    % MM: TDB: should be done accretively
Timings.assembleEstimator.Phi         = toc(Timings.assembleEstimator.Phi);
if VERBOSE>1, fprintf('It took %10.4e seconds to assemble Estimator.Phi and Estimator.rhs_vec.\n', Timings.assembleEstimator.Phi); end

if has_xi                                                                                           % now the extra information, for uniform learn, pretty much nothing
    extra.Rs                  = Rs;                                                                 % except when there is xi, we do not want to calculate Rs again
end
extra.rhs_in_l2_norm_sq     = rhs_in_l2_norm_sq;                                                    % we also need the square of the l_2 norm of d_vec - F_vec over all m's
extra.rhoLTemp              = [];                                                                   % will be constructed later

return

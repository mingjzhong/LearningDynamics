function [Estimator, extra, Timings] = serial_assemble_xi(Rs, x, xi, dot_xi, time_vec, sys_info, learn_info)
% function [Estimator, extra, Timings] = serial_assemble_xi(Rs, x, xi, dot_xi, time_vec, sys_info, learn_info)

% (c) M. Zhong (JHU)

VERBOSE                                                 = 0;

% start the assembly
if VERBOSE
    fprintf('Serial Assemble: Unpacking and initializing data.\n');
end
% find out if we have information on derivative
has_derivative                                          = ~isempty(dot_xi);
% find out number of Monte Carlo realizations this worker is assigned to
M                                                       = size(x, 3);
agents_info                                             = getAgentInfo(sys_info);
% N_per_class                                        = histcounts(sys_info.type_info, 0.5 : 1 : sys_info.K + 0.5);
% build it and then send it out
if VERBOSE > 1, fprintf('Building basis.\n'); end
% build the basis
Timings.uniformbasisxi                                  = tic;
Estimator.Xibasis                                       = uniform_basis_on_xi(Rs, sys_info, learn_info);
Timings.uniformbasisxi                                  = toc(Timings.uniformbasisxi);
% calculate the number of basis functions
num_xi_Estimator.Phi_cols                               = sum(sum(cellfun(@(x) length(x.f), Estimator.Xibasis)));     
Timings.assembleEstimator.Phi                           = tic;  
% allocate memory for Phi, and rhs_vec, use sparse storage
Estimator.Phi                                           = sparse(num_xi_Estimator.Phi_cols, num_xi_Estimator.Phi_cols);
Estimator.rhs_vec                                       = sparse(num_xi_Estimator.Phi_cols, 1);
% we need the square of the l_2 norm of d_vec - F_vec for all m's
rhs_in_l2_norm_sq                                       = 0;
% the local Monte Carlo loop
for m = 1 : M
% find the portion of x
  one_x                                                 = squeeze(x(:, :, m));
% find the portion of xi
  one_xi                                                = squeeze(xi(:, :, m));
% find portion of dot_xi when it is present
  if has_derivative
    one_dot_xi                                          = squeeze(dot_xi(:, :, m));
  else
    one_dot_xi                                          = [];
  end
% find out: pairwise distances on xi (not needed for uniform learn), its non-repeated copy, Phi matrix (with xi as the pairwise
% differences), F (external influence) vector, d (approxiamted derivative of xi) vector
  [one_xi_Estimator.Psi, one_F_vec, one_d_vec, timings] = one_step_assemble_on_xi(one_x, one_xi, one_dot_xi, time_vec, agents_info, ...
  Estimator.Xibasis, sys_info, learn_info);
% calculate the right handside
  one_rhs_vec                                           = one_d_vec - one_F_vec;
% find out the square of its l_2 norm
  rhs_in_l2_norm_sq                                     = rhs_in_l2_norm_sq + norm(one_rhs_vec)^2;
% calculate (Phi^{(m)})^T * Phi^{(m)} and add it to Phi
  one_PsiT                                              = transpose(one_xi_Estimator.Psi);
  Estimator.Phi                                         = Estimator.Phi + one_PsiT * one_xi_Estimator.Psi;
% calculate (Phi^{(m)})^T * (d_vec^{(m)} - F_vec^{(m)}), and add it to rhs_vec
  Estimator.rhs_vec                                     = Estimator.rhs_vec + one_PsiT * one_rhs_vec;
end
% for uniform learn, extra_xi has nothing
extra.rhs_in_l2_norm_sq                                 = rhs_in_l2_norm_sq;
Timings.one_step_assemble_xi                            = timings;
Timings.assembleEstimator.Phi                           = toc(Timings.assembleEstimator.Phi);
extra.rhoLTXi                                           = [];
% done
if VERBOSE
fprintf('It takes %10.4e seconds to finish MC assembly.\n', Timings.assembleEstimator.Phi);
end

return

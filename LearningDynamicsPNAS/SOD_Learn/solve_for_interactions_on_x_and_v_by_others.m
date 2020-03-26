function [alpha_vec, fric_coef, opt_val] = solve_for_interactions_on_x_and_v_by_others(Phi, rhs_vec, T, M, learn_info)

%
% [alphaE, align_alphas, fric_coef, opt_val] = solve_for_interactions_on_x_and_v_by_others(Phi, rhs_vec,T, M, learning_info)

% (c) Ming Zhong, Mauro Maggioni (JHU)

% find out extra information for the solver
if isfield(learn_info, 'solver_info'),  learn_info.solver_info  = learn_info.solver_info;
else,                                   learn_info.solver_info  = [];                           end
% solve it by type of solver
switch learn_info.solver_type
  case 'linsolve'        
    opts.SYM          = true;                                                                       % Phi is symmetric
    alpha_vec         = linsolve(Phi, rhs_vec, opts);
  case 'mldivide'        
    alpha_vec         = Phi \ rhs_vec;                                                              % mldivide does the check (on Phi being symmetric) first
  case 'inverse'        
    alpha_vec         = inv(Phi) * rhs_vec;                                                         % use the inverse of Phi
  case 'pinv'        
    alpha_vec         = pinv(Phi) * rhs_vec;                                                        % use the regularized pseudo-inverse of Phi
  case 'svd'  % MM This seems to be losing half the digits, to be removed???
    % when Phi is so closed to be singular, mldivide and linsolve would fail to find anything useful, use svd, and since now Phi is
    % of size n^2 (n, the dimension of the hypothesis space), very small, very managable, we find out the cut automatically
    [U, S, V]         = svd(Phi);
    % find out singular values of Phi, put it in vector form
    lambdas           = diag(S);
    % take out any singular values which are less than the_zero (a threshold)
    if ~isempty(learn_info.solver_info)
      if isfield(learn_info.solver_info, 'svd_threshold')
        the_zero      = learn_info.solver_info.svd_threshold;
      else
        the_zero      = 1.0e-12;
      end
    else
      the_zero        = 1.0e-12;
    end
    ind               = find(lambdas <= the_zero, 1);
    % solve the system based on this first cutoff
    if ~isempty(ind)
      % then we will take anything bigger than the_zero
      if ind > 1
        % when there is at least one which is bigger than the_zero
        lambdas        = lambdas(1 : (ind - 1));
        % now we have a vector of non-zero singular values (all positive)
        lam_len        = length(lambdas);
        ratios         = log(lambdas(1 : (lam_len - 1))) - log(lambdas(2 : lam_len));
        % find out the maximum jump
        [~, ind]       = max(ratios);
        % prepare the cut
        lambdas_cut    = lambdas(1 : ind);
        U_cut          = U(:, 1 : ind);
        V_cut          = V(:, 1 : ind);
        D_cut          = diag(1./lambdas_cut);
        % solve for alpha
        alpha_vec      = V_cut * D_cut * U_cut' * rhs_vec;
      else
        % when there is nothing bigger than the threshold, we take the trivial solution
        alpha_vec      = zeros(size(rhs_vec));
      end
    else
      % when we have everything being above the_zero
      lam_len          = length(lambdas);
      % we find the sharp drop off automatically
      ratios           = log(lambdas(1 : (lam_len - 1))) - log(lambdas(2 : lam_len));
      % find out the maximum jump
      [~, ind]         = max(ratios);
      % prepare the cut
      lambdas_cut      = lambdas(1 : ind);
      U_cut            = U(:, 1 : ind);
      V_cut            = V(:, 1 : ind);
      D_cut            = diag(1./lambdas_cut);
      % solve for alpha
      alpha_vec        = V_cut * D_cut * U_cut' * rhs_vec;
    end
  otherwise
    error('SOD_Learn:solve_for_interactions_on_x_and_v_by_others:invalidInput', ...
    'This routine only supports linsolve, mldivide, and truncated svd!!');
end
% calculate (<Phi * alpha_vec, alpha_vec> - 2 <alpha_vec, rhs_vec>)/(T * M)
if T == 0
% when there is only one observation, no T is needed
  opt_val        = (transpose(Phi * alpha_vec) * alpha_vec - 2 * transpose(alpha_vec) * rhs_vec)/M;
else
% for more than 1 observation, proceed as usual
  opt_val        = (transpose(Phi * alpha_vec) * alpha_vec - 2 * transpose(alpha_vec) * rhs_vec)/(T * M);
end

% when there is no friction learned
fric_coef        = [];
end
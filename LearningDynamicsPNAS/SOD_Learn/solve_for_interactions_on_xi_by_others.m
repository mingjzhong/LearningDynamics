function [alpha_vec, opt_val] = solve_for_interactions_on_xi_by_others(Phi, rhs_vec, basis, T, M, learn_info)
% [alpha_vec, opt_val] = solve_for_interactions_on_xi_by_others(Phi, rhs_vec, basis, T, M, learning_info)

% Ming Zhong
% Postdoc Research at JHU

% find out which solver to use
solver_type        = learn_info.solver_type;
% solve it by type of solver
switch solver_type
  case 'linsolve'
% Phi is symmetric
    opts.SYM       = true;
    alpha_vec      = linsolve(Phi, rhs_vec, opts);
  case 'mldivide'
% mldivide does this check (symmetry check) automatically    
    alpha_vec      = Phi\(rhs_vec);
  case 'inverse'
    alpha_vec      = inv(Phi) * rhs_vec;                                                            % use the inverse of Phi
  case 'pinv'
    alpha_vec      = pinv(Phi) * rhs_vec;                                                           % use the regularized pseudo-inverse of Phi
  otherwise
    error('SOD_Learn:solve_for_interactions_on_xi_by_others:exception', 'Other types of solvers are not implemented yet!');
end
% calculate (<Phi * alpha_vec, alpha_vec> - 2 <alpha_vec, rhs_vec>)/(T * M)
if T == 0
% when there is only one observation, no T is needed  
  opt_val          = (transpose(Phi * alpha_vec) * alpha_vec - 2 * transpose(alpha_vec) * rhs_vec)/M;
else
% for more than 1 observation, proceed as usual  
  opt_val          = (transpose(Phi * alpha_vec) * alpha_vec - 2 * transpose(alpha_vec) * rhs_vec)/(T * M);
end

end
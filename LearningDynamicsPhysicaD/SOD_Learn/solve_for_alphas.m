function [alpha_vec, opt_val] = solve_for_alphas(A, b, learn_info, regMat)
% [alpha_vec, opt_val] = solve_for_alphas(A, b, learn_info, regMat)

% (c) Ming Zhong

% add regularization
if nargin < 4, regMat = []; end
if ~isempty(regMat)
  A           = A + learn_info.lambda * regMat;
end
% pick a solver, by default, pseudo-inverse is used
if ~isfield(learn_info, 'solver_type'), learn_info.solver_type = 'pinv'; end
% solve it by type of solver
switch learn_info.solver_type
  case 'linsolve'        
    opts.SYM  = true;                                                                               % A is symmetric
    alpha_vec = linsolve(A, b, opts);
  case 'mldivide'        
% mldivide does this check (symmetry check) automatically      
    alpha_vec = A \ b;                                                                              % mldivide does the check (on A being symmetric) first
%   case 'inverse' % direct method of inverting Ax = b is retired    
%     alpha_vec = inv(A) * b;                                                                       % use the  actual inverse of A
  case 'pinv'   
    alpha_vec = pinv(A) * b;                                                                        % use the regularized pseudo-inverse of A
  otherwise
    error('SOD_Learn:solve_for_interactions_on_x_and_v_by_others:invalidInput', ...
      'This routine only supports linsolve, mldivide, and pseudo-inverse!!');
end
% calculate <A * alpha_vec, alpha_vec> - 2 <alpha_vec, b>
opt_val       = (A * alpha_vec)' * alpha_vec - 2 * alpha_vec' * b;
if isfield(learn_info, 'use_gpu') && ~isempty(learn_info.use_gpu) && learn_info.use_gpu
  alpha_vec   = gather(alpha_vec);
  opt_val     = gather(opt_val);
end
end
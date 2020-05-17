function Estimator = learn_interactions(x, v, xi, dot_xv, dot_xi, time_vec, sys_info, learn_info)
% function [Estimator, extra] = learn_interactions_on_x_and_v(x, v, xi, dot_xv, time_vec, sys_info, learn_info)

% OUT:
% Estimator structure with the following fields, as appropriate for the system type:
%   Phi, rhs_vec, alpha, alpha_xi, phiEhat, Ebasis, phiAhat, Abasis, phiXihat, Xibasis, Timings, Info (?)

% (c) Ming Zhong (JHU)

Timings.LearnInteractions                = tic;
if ~isfield(learn_info, 'VERBOSE'), learn_info.VERBOSE = 2; end
if isfield(learn_info, 'is_parallel'), is_parallel  = learn_info.is_parallel; else, is_parallel = false; end
if size(x, 3) < feature('numcores'), is_parallel = false; end
if learn_info.VERBOSE > 1, fprintf('\nAssembling Phi, rhs_vec and other related quantities.'); end
if ~is_parallel                                                                                     % run in parallel or serial based on user input
  if learn_info.is_adaptive
    [Estimator, Timings.assemble]        = assemble_Anb_serial_adaptive(x, v, xi, dot_xv, dot_xi, ...
      time_vec, sys_info, learn_info);                                                              % run in serial mode
  else
    [Estimator, Timings.assemble]        = assemble_Anb_serial_uniform(x,  v, xi, dot_xv, dot_xi, ...
      time_vec, sys_info, learn_info);                                                              % run in serial mode
  end
else                                                                                                % make distributed copies of x, v, xi, and related terms
  if learn_info.is_adaptive
    [Estimator, Timings.assemble]        = assemble_Anb_parallel_adaptive(x, v, xi, dot_xv, dot_xi, ...
                                           time_vec, sys_info, learn_info);                         % run in parallel mode
  else
    [Estimator, Timings.assemble]        = assemble_Anb_parallel_uniform(x,  v, xi, dot_xv, dot_xi, ...
                                           time_vec, sys_info, learn_info);                         % run in parallel mode
  end
end
Estimator.Timings.assemble               = Timings.assemble;
if learn_info.VERBOSE > 1, fprintf('\nIt takes %10.4e seconds to finish the assembly.', Estimator.Timings.assemble.assemble_total); end
if learn_info.VERBOSE > 1, fprintf('\nPrinting information about learning matrix on x/v:'); print_learning_matrix_info(Estimator.ALM); end % Print out information on the learning matrix
if learn_info.VERBOSE > 1 && ~isempty(Estimator.ALMXi), fprintf('\nPrinting information about learning matrix on xi:'); print_learning_matrix_info(Estimator.ALMXi); end % Print out information on the learning matrix
Estimator.Timings.solve                  = tic;                                                     % construct the learning problem on x and v
[Estimator.alpha, Estimator.alpha_xi, opt_val, opt_val_xi] ...
                                         = solve_the_learning_problem(Estimator, learn_info);       % find out the minimizer and optimal value
if isfield(learn_info, 'use_gpu') && ~isempty(learn_info.use_gpu) && learn_info.use_gpu
  Estimator.ALM                          = gather(Estimator.ALM);
  Estimator.bLM                          = gather(Estimator.bLM);
end
Estimator.Info.ALMSingVals               = svd(Estimator.ALM);
Estimator.Info.ALMCond                   = get_conditional_number_from_svd(Estimator.Info.ALMSingVals);
if ~isempty(Estimator.ALMXi)
  Estimator.Info.ALMXiSingVals           = svd(Estimator.ALMXi);
  Estimator.Info.ALMXiCond               = get_conditional_number_from_svd(Estimator.Info.ALMXiSingVals);
end
if learn_info.VERBOSE > 1, fprintf('\nOptimal Value on x/v is: % 12.6e.', opt_val); end             % print out the optimal value, it should be very close to zero
if learn_info.VERBOSE > 1 && ~isempty(Estimator.ALMXi), fprintf('\nOptimal Value on xi is: % 12.6e.', opt_val_xi); end
% the empirical error: opt_val + \sum_{m = 1}^M<(d_vec - F_vec)^(m), (d_vec - F_vec)^(m)>
Estimator.emp_err                        = opt_val + Estimator.rhs_in_l2_norm_sq;
if ~isempty(Estimator.ALMXi), Estimator.emp_err_xi = opt_val_xi + Estimator.rhs_in_l2_norm_sq_xi; else, Estimator.emp_err_xi = []; end
Estimator.Timings.solve                  = toc(Estimator.Timings.solve);
if learn_info.VERBOSE > 1, fprintf('\nIt took %10.4e seconds to find the minimizer.', Estimator.Timings.solve); end
Estimator.Timings.LearnInteractions      = toc(Timings.LearnInteractions);
Estimator.Timings.LinearCombinationBasis = tic;
[Estimator.phiEhat, lastIdx]             = LinearCombinationBasis(Estimator.Ebasis,  Estimator.alpha);
Estimator.phiAhat                        = LinearCombinationBasis(Estimator.Abasis,  Estimator.alpha(lastIdx + 1: end));
Estimator.phiXihat                       = LinearCombinationBasis(Estimator.Xibasis, Estimator.alpha_xi);
Estimator                                = simplifyPhihats(Estimator);
Estimator.Timings.LinearCombinationBasis = toc(Estimator.Timings.LinearCombinationBasis);
end
function Estimator = uniform_learn_interactions(x, v, xi, dot_xv, dot_xi, time_vec, sys_info, learn_info)
% function Estimator= uniform_learn_interactions(x, v, xi, dot_xv, dot_xi, time_vec, sys_info, learn_info)

% OUT: Estimator is a struc which contains
%   Phi, rhs_vec, Phi_xi, rhs_vec_xi, alpha, alpha_xi, PhiEknots, PhiAknots, PhiXiknots, Ebasis, Abasis, Xibasis, Info, Timings

% (c) Ming Zhong, Mauro Maggioni (JHU)

if ~isfield(learn_info, 'VERBOSE'), learn_info.VERBOSE = 2; end
VERBOSE                         = learn_info.VERBOSE;
M                               = size(x, 3);                                                                % find out the total number of MC realizations
if isfield(learn_info, 'is_parallel'), is_parallel  = learn_info.is_parallel; else, is_parallel = false; end
if M < feature('numcores'), is_parallel = false; end

if VERBOSE > 1, fprintf('\nAssembling Phi, rhs_vec and other related quantities.'); end
if ~is_parallel                                                                                     % run in parallel or serial based on user input
  [Estimator, Timings.assemble] = serial_assemble(x, v, xi, dot_xv, dot_xi, time_vec, sys_info, learn_info); % run in serial mode
  Estimator.Timings.assemble    = Timings.assemble;
else                                                                                                % run in parallel, distribute the data: make distributed copies of x, v, xi and time_vec.
  error('SOD_Learn:uniform_learn_interactoins:exception', 'parallel_assemble is not properly implmented yet!!');
%   x_d         = distributed(x);
%   v_d         = distributed(v);
%   xi_d        = distributed(xi);
%   dot_xv_d    = distributed(dot_xv);
%   dot_xi_d    = distributed(dot_xi);
%   [Estimator, Timings.assemble] = parallel_assemble(x_d, v_d, xi_d, dot_xv_d, dot_xi_d, time_vec, sys_info, learn_info); % run in parallel mode
%   Estimator.Timings.assemble    = Timings.assemble;
end
if VERBOSE > 1, fprintf('\nIt takes %10.4e seconds to finish the assembly.', Estimator.Timings.assemble); end
if VERBOSE > 1, fprintf('\nPrinting information about learning matrix on x/v:'); print_learning_matrix_info(Estimator.Phi); end % Print out information on the learning matrix
if VERBOSE > 1 && ~isempty(Estimator.Phi_xi), fprintf('\nPrinting information about learning matrix on xi:'); print_learning_matrix_info(Estimator.Phi_xi); end % Print out information on the learning matrix
Estimator.Timings.solve         = tic;                                                              % construct the learning problem on x and v
T                               = time_vec(end);                                                    % find out the learning final time
[Estimator.alpha, Estimator.alpha_xi, opt_val, opt_val_xi] = solve_the_learning_problem(Estimator, T, M, learn_info);% find out the minimizer and optimal value
Estimator.Info.phiSingVals      = svd(Estimator.Phi);
Estimator.Info.phiCond          = Estimator.Info.phiSingVals(1)/Estimator.Info.phiSingVals(end);
if ~isempty(Estimator.Phi_xi)
  Estimator.Info.phiSingVals_xi = svd(Estimator.Phi_xi);
  Estimator.Info.phiCond_xi     = Estimator.Info.phiSingVals_xi(1)/Estimator.Info.phiSingVals_xi(end);
end
if VERBOSE > 1, fprintf('\nOptimal Value on x/v is: % 12.6e.', opt_val); end                        % print out the optimal value, it should be very close to zero
if VERBOSE > 1 && ~isempty(Estimator.Phi_xi), fprintf('\nOptimal Value on xi is: % 12.6e.', opt_val_xi); end
if T == 0                                                                                           % the empirical error: opt_val + \frac{1}{TM}\int_{t = 0}^Tsum_{m = 1}^M<(d_vec - F_vec)^(m), (d_vec - F_vec)^(m)> dt
  Estimator.emp_err             = opt_val + Estimator.rhs_in_l2_norm_sq/M;
  if ~isempty(Estimator.Phi_xi), Estimator.emp_err_xi = opt_val_xi + Estimator.rhs_in_l2_norm_sq/M; end
else
  Estimator.emp_err             = opt_val + Estimator.rhs_in_l2_norm_sq/(T * M);
  if ~isempty(Estimator.Phi_xi), Estimator.emp_err_xi = opt_val_xi + Estimator.rhs_in_l2_norm_sq/(T * M); end
end
Estimator.Timings.solve         = toc(Estimator.Timings.solve);
if VERBOSE > 1, fprintf('\nIt took %10.4e seconds to find the minimizer.', Estimator.Timings.solve); end
end
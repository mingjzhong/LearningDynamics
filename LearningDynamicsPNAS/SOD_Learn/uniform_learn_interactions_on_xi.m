function [Estimator, extra] = uniform_learn_interactions_on_xi(Rs, x, xi, dot_xi, time_vec, sys_info, learn_info)
% function [Estimator, extra] = uniform_learn_interactions_on_xi(Rs, x, xi, dot_xi, time_vec, sys_info, learn_info)

% (c) M. Zhong

if ~isfield(learn_info,'VERBOSE'), learn_info.VERBOSE = 0; end

VERBOSE                                               = learn_info.VERBOSE;
Timings.assemblexi                                    = tic;
% find out the total number of MC realizations
M                                                     = size(x, 3);
% check to see how we should assemble the data
if isfield(learn_info, 'is_parallel'), is_parallel    = learn_info.is_parallel;
else, is_parallel                                     = false; end

if M < feature('numcores'),               is_parallel = false; end

if VERBOSE > 1, fprintf('\nAssembling Phi, rhs_vec and other related quantities.'); end
if ~is_parallel % run in parallel or serial based on user input
    % run in serial when user does not want the code to run in parallel mode or just does not specify the field is_parallel in learning_info
    [Estimator, extra, Estimator.Timings]               = serial_assemble_xi(Rs, x, xi, dot_xi, time_vec, sys_info, learn_info);
    Estimator.Timings.serial_assemble_xi                = Estimator.Timings;
else
    % run in parallel, distribute the data: make distributed copies of x, xi and time_vec.
    x_d                                                 = distributed(x);
    xi_d                                                = distributed(xi);
    if ~isempty(dot_xi), dot_xi_d                       = distributed(dot_xi);
    else, dot_xi_d                                      = []; end
    % learning_info is shared, no need to distributed, then do it in the parallel fashion
    [Estimator, extra, Estimator.Timings]               = parallel_assemble_xi(Rs, x_d, xi_d, dot_xi_d, time_vec, sys_info, learn_info);
    Estimator.Timings.parallel_assemble_xi              = Estimator.Timings;
end
Estimator.Timings.assemblexi = toc(Timings.assemblexi);
% done
if VERBOSE > 1, fprintf('\nIt takes %10.4e seconds to finish the assembly.', Estimator.Timings.assemblexi); end
% find the learning problem on x and v
Estimator.Timings.solvethelearningproblem             = tic;
% first print out information on the learning matrix (for the theorems)
if VERBOSE > 0, print_learning_matrix_info(Estimator.Phi); end
% find out the learning final time
T                                                     = time_vec(end);
% find out the minimizer and optimal value
[Estimator.alpha, opt_val]                            = solve_the_learning_problem_on_xi(Estimator.Phi, Estimator.rhs_vec, Estimator.Xibasis, T, M, learn_info);
Estimator.Info.phiXiSingVals                          = svd(Estimator.Phi);
Estimator.Info.phiXiCond                              = Estimator.Info.phiXiSingVals(1)/Estimator.Info.phiXiSingVals(end);
% print out the optimal value, it should be very close to zero
if VERBOSE > 0, fprintf('\nOptimal Value is: % 12.6e.', opt_val); end
% the emprical error is: opt_val + \frac{1}{TM}\int_{t = 0}^Tsum_{m = 1}^M<(d_vec - F_vec)^(m), (d_vec - F_vec)^(m)> dt
if T == 0
    Estimator.emp_err                                   = opt_val + extra.rhs_in_l2_norm_sq/M;
else
    Estimator.emp_err                                   = opt_val + extra.rhs_in_l2_norm_sq/(T * M);
end
Estimator.Timings.solvethelearningproblem             = toc(Estimator.Timings.solvethelearningproblem);
% stop the timer
if VERBOSE > 0, fprintf('\nIt takes %10.4e seconds to find the minimizer.', Estimator.Timings.solvethelearningproblem); end

return
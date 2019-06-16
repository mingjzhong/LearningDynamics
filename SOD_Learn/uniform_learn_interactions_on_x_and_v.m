function [Estimator, extra] = uniform_learn_interactions_on_x_and_v(x, v, xi, dot_xv, time_vec, sys_info, learn_info)

%
% function [Estimator, extra] = uniform_learn_interactions_on_x_and_v(x, v, xi, dot_xv, time_vec, sys_info, learn_info)

% OUT:
%   Estimator.Phi, Estimator.rhs_vec, Estimator.alphaE, Estimator.PhiEknots, Estimator.Info, Estimator.Timings

% (c) Ming Zhong, Mauro Maggioni (JHU)

if ~isfield(learn_info,'VERBOSE'), learn_info.VERBOSE = 2;                                  end

VERBOSE         = learn_info.VERBOSE;

Timings.serialassemblexandv          = tic;
M               = size(x, 3);                                                                       % find out the total number of MC realizations
if isfield(learn_info, 'is_parallel'), is_parallel  = learn_info.is_parallel;                       % check to see how we should assemble the data
else                                 , is_parallel  = false;                                end

if M<feature('numcores'),              is_parallel = false;                                 end

if VERBOSE>1, fprintf('\nAssembling Phi, rhs_vec and other related quantities.');           end
if ~is_parallel                                                                                     % run in parallel or serial based on user input
    [Estimator, extra,Estimator.Timings] ...                                                        % run in serial when user does not want the code to run in parallel mode or just does not specify the field is_parallel in learning_info
        = serial_assemble_x_and_v(x, v, xi, dot_xv, time_vec, sys_info, learn_info);
    Estimator.Timings.serial_assemble_x_and_v = Estimator.Timings;
else                                                                                                % run in parallel, distribute the data: make distributed copies of x, v, xi and time_vec.
    x_d         = distributed(x);
    v_d         = distributed(v);
    xi_d        = distributed(xi);
    dot_xv_d    = distributed(dot_xv);
    [Estimator.Ebasis, Estimator.Abasis, Estimator.Phi, Estimator.rhs_vec, extra, Estimator.Timings] = ...
        parallel_assemble_x_and_v( x_d, v_d, xi_d, dot_xv_d, time_vec, sys_info, learn_info);
    Estimator.Timings.assemble_x_and_v        = Estimator.Timings;
end
Estimator.Timings.serialassemblexandv = toc(Timings.serialassemblexandv);
if VERBOSE>1,   fprintf('\nIt takes %10.4e seconds to finish the assembly.', Estimator.Timings.serialassemblexandv); end

if VERBOSE>1, fprintf('\nPrinting information about learning matrix:');                     end     % Print out information on the learning matrix
if VERBOSE>0, print_learning_matrix_info(Estimator.Phi);                                    end

Estimator.Timings.solvethelearningproblem     = tic;                                                % construct the learning problem on x and v

T                               = time_vec(end);                                                                % find out the learning final time
[Estimator.alpha, ~, opt_val]   = solve_the_learning_problem_on_x_and_v( ...
                                        Estimator.Phi,Estimator.rhs_vec,T,M,sys_info,learn_info );  % find out the minimizer and optimal value
Estimator.Info.phiSingVals      = svd(Estimator.Phi);
Estimator.Info.phiCond          = Estimator.Info.phiSingVals(1)/Estimator.Info.phiSingVals(end);

if VERBOSE>0, fprintf('\nOptimal Value is: % 12.6e.', opt_val);                             end     % print out the optimal value, it should be very close to zero
if T == 0                                                                                           % the empirical error: opt_val + \frac{1}{TM}\int_{t = 0}^Tsum_{m = 1}^M<(d_vec - F_vec)^(m), (d_vec - F_vec)^(m)> dt
    Estimator.emp_err           = opt_val + extra.rhs_in_l2_norm_sq/M;
else
    Estimator.emp_err           = opt_val + extra.rhs_in_l2_norm_sq/(T * M);
end
Estimator.Timings.solvethelearningproblem = toc(Estimator.Timings.solvethelearningproblem);
if VERBOSE>0, fprintf('\nIt took %10.4e seconds to find the minimizer.', ...
        Estimator.Timings.solvethelearningproblem);   end

return

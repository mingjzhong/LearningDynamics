function print_exitflag_for_fmincon(exitflag, options)
% function print_exitflag_for_fmincon(exitflag, options)

% (C) M. Zhong

switch exitflag
  case -3
    fprintf('\n\t\tObjective function at current iteration went below %10.4e.', options.ObjectiveLimit);
    fprintf('\n\t\tAnd maximum constraint violation was less than %10.4e.', options.ConstraintTolerance);
  case -2
    fprintf('\n\t\tNo feasible point was found.');
  case -1
    fprintf('\n\t\tStopped by an output function or plot function.');
  case 0
    fprintf('\n\t\tNumber of iterations exceeded %d.', options.MaxIterations);
    fprintf('\n\t\tOr number of function evaluations exceeded %d.', options.MaxFunctionEvaluations);
  case 1
    fprintf('\n\t\tFirst-order optimiality measure was less than %10.4e.', options.OptimalityTolerance);
    fprintf('\n\t\tAnd maximum constraint violation was less than %10.4e.', options.ConstraintTolerance);
  case 2
    fprintf('\n\t\tChange in x was less than %10.4e.', options.StepTolerance);
    fprintf('\n\t\tAnd maximum constraint violation was less than %10.4e.', options.ConstraintTolerance);
  case 3
    fprintf('\n\t\tChange in the objective function value was less than %10.4e.', options.FunctionTolerance);
    fprintf('\n\t\tAnd maximum constraint violation was less than %10.4e.', options.ConstraintTolerance);
  case 4
    fprintf('\n\t\tMagnitude of the search direction was less than %10.4e.', 2 * options.StepTolerance);
    fprintf('\n\t\tAnd maximum constraint violation was less than %10.4e.', options.ConstraintTolerance);
  case 5
    fprintf('\n\t\tMagnitue of the search direction was less than %10.4e.', 2 * options.OptimalityTolerance);
    fprintf('\n\t\tAnd maximum constraint violation was less than %10.4e.', options.ConstraintTolerance);
  otherwise
    error('');
end
end
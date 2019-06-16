function [Estimator, extra] = learn_interactions_on_xi(Rs, x, xi, dot_xi, time_vec, sys_info, learn_info)
% function [phiXihat, Xibasis, emp_err_xi, extra_xi, PhiXi, rhsXi, Timings] = learn_interactions_on_xi(Rs, x, xi, dot_xi, time_vec, sys_info, learn_info)

% (c) M. Zhong (JHU)

Timings.LearnInteractions                = tic;
% learn the interactions based on the is_adaptive indicator
if learn_info.is_adaptive
    % do adaptive learning based on samples
    [Estimator, extra]                     = adaptive_learn_interactions_on_xi(Rs, x, xi, dot_xi, time_vec, sys_info, learn_info);
else
    % do uniform learning with fixed basis
    [Estimator, extra]                     = uniform_learn_interactions_on_xi(Rs, x, xi, dot_xi, time_vec, sys_info, learn_info);
end
% now we have to assemble the learned interactions

Estimator.Timings.LearnInteractions      = toc( Timings.LearnInteractions );
Estimator.Timings.LinearCombinationBasis = tic;
Estimator.phiXihat                       = LinearCombinationBasis( Estimator.Xibasis, Estimator.alpha );

Estimator.Timings.LinearCombinationBasis = toc(Estimator.Timings.LinearCombinationBasis);

return
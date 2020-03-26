function [Estimator, extra] = learn_interactions_on_x_and_v(x, v, xi, dot_xv, time_vec, sys_info, learn_info)
% function [Estimator, extra] = learn_interactions_on_x_and_v(x, v, xi, dot_xv, time_vec, sys_info, learn_info)

% OUT:
% Estimator structure with the following fields, as appropriate for the system type:
%   Phi, rhs_vec, alphaE, PhiEknots, Info, phiEhat, phiAhat, Estimator.Timings

% (c) Ming Zhong, Mauro Maggioni, JHU

Timings.LearnInteractions                   = tic;
if learn_info.is_adaptive                                                                           % learn with an adaptive basis
    [Estimator, extra]                      = adaptive_learn_interactions_on_x_and_v(x, v, xi, dot_xv, time_vec, sys_info, learn_info);
else                                                                                                % learn with a uniform basis
    [Estimator, extra]                      = uniform_learn_interactions_on_x_and_v(x,  v, xi, dot_xv, time_vec, sys_info, learn_info);
end
Estimator.Timings.LearnInteractions         = toc( Timings.LearnInteractions );

Estimator.Timings.LinearCombinationBasis    = tic;
[Estimator.phiEhat,lastIdx]                 = LinearCombinationBasis( Estimator.Ebasis, Estimator.alpha );
Estimator.phiAhat                           = LinearCombinationBasis( Estimator.Abasis, Estimator.alpha(lastIdx + 1:end) );% MM: TBD: To be tested after refactoring code, what's a good example to test this on?
Estimator.Timings.LinearCombinationBasis    = toc(Estimator.Timings.LinearCombinationBasis);

return

function [alpha, alpha_xi, opt_val, opt_val_xi] = solve_the_learning_problem(Estimator, learn_info)
% function [alpha, alpha_xi, opt_val, opt_val_xi] = solve_the_learning_problem(Estimator, learn_info)

% (c) M. Zhong (JHU)

% initialize storage
alpha_xi                 = []; 
opt_val_xi               = [];
[alpha, opt_val]         = solve_for_alphas(Estimator.ALM,   Estimator.bLM,   learn_info);
if ~isempty(Estimator.ALMXi)
  [alpha_xi, opt_val_xi] = solve_for_alphas(Estimator.ALMXi, Estimator.bLMXi, learn_info);
end
end
function [Ealpha, Aalpha, Xialpha, opt_val, opt_val_xi, Info, Info_xi] ...
           = solve_the_learning_problem(Estimator, learn_info)
% function [Ealpha, Aalpha, Xialpha, opt_val, opt_val_xi, Info, Info_xi] ...
%            = solve_the_learning_problem(Estimator, learn_info)

% (c) M. Zhong 

K                 = length(Estimator.ALM);
opt_val           = zeros(K, 1);
alphas            = cell(K, 1);
Info              = cell(K, 1);
if ~isempty(Estimator.ALMXi)
  Xialpha         = cell(K, 1);
  opt_val_xi      = zeros(K, 1);
  Info_xi         = cell(K, 1);
else
  Xialpha         = []; 
  opt_val_xi      = []; 
  Info_xi         = [];  
end
for k = 1 : K
  [alphas{k}, opt_val(k), Info{k}] ...
                  = solve_for_alphas(Estimator.ALM{k}, Estimator.bLM{k});
  alphas{k}       = insert_zeros(k, alphas{k}, learn_info, 'EA');
  if ~isempty(Estimator.ALMXi)  
    [Xialpha{k}, opt_val_xi(k), Info_xi{k}] ...
                  = solve_for_alphas(Estimator.ALMXi{k}, Estimator.bLMXi{k});
    Xialpha{k}    = insert_zeros(k, Xialpha{k}, learn_info, 'xi'); 
  end
end
alpha             = vertcat(alphas{:});
[Ealpha, Aalpha]  = split_alpha(alpha, learn_info);
if ~isempty(Estimator.ALMXi)
  Xialpha         = vertcat(Xialpha{:});
end
end
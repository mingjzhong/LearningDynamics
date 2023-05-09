function Estimator = regularizePhihats(Estimator, learn_info)
% function Estimator = regularizePhihats(Estimator, learn_info)

% (C) M. Zhong

Estimator.phiEhatReg     = [];
Estimator.phiAhatReg     = [];
Estimator.phiXihatReg    = [];
if isfield(learn_info, 'use_reg') && ~isempty(learn_info.use_reg) && learn_info.use_reg
  to_reg                 = check_the_system_for_regularization(learn_info);
  if to_reg
    [R, h]               = get_regularization_matrix(Estimator.Ebasis{1}, learn_info.method);
    alphas               = solve_for_alphas_with_regularization(Estimator.ALM{1}, ...
                           Estimator.bLM{1}, R, h, learn_info.lambda, learn_info.method);
    Estimator.phiEhatReg = LinearCombinationBasis(Estimator.Ebasis,  alphas);
    Estimator.alphas_reg = alphas;
  end
end
end                             
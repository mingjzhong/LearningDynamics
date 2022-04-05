function Estimator = assemble_phihats(Estimator, sys_info)
% function Estimator = assemble_phihats(Estimator)

% (C) M. Zhong

Estimator.phiEhat  = LinearCombinationBasis(Estimator.Ebasis,  Estimator.Ealpha,  sys_info);
Estimator.phiAhat  = LinearCombinationBasis(Estimator.Abasis,  Estimator.Aalpha,  sys_info);
Estimator.phiXihat = LinearCombinationBasis(Estimator.Xibasis, Estimator.Xialpha, sys_info);
end